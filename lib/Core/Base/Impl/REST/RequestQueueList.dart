import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/REST/Exceptions/RequestQueueTimeOutException.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/LoggableService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/CustomTimer.dart';

import '../../../Abstractions/Common/Event.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/REST/Enums.dart';
import 'RequestQueueItem.dart';
import 'dart:async';
import 'package:collection/collection.dart';

class RequestQueueList extends DelegatingList<RequestQueueItem> with LoggableService
{
    //final ILoggingService _loggingService;
    final List<RequestQueueItem> _items;
    final CustomTimer _timeOutTimer = CustomTimer(Duration(seconds: 15));
    String get _TAG => "${this.runtimeType.toString()}";

    //we need to make sure that this and supper(DelegatingList) shares the same List(_items)
    //use factory to pass list items to supper constructor
    factory RequestQueueList()
    {
      final items = <RequestQueueItem>[];
      return RequestQueueList._(items);
    }

    RequestQueueList._(this._items) : super(_items)
    {
      _timeOutTimer.Elapsed.AddListener(TimeOutTimer_Elapsed);
    }

    final RequestStarted = Event<RequestQueueItem>();
    final RequestPending = Event<RequestQueueItem>();
    final RequestCompleted = Event<RequestQueueItem>();

    final int MaxBackgroundRequest = 1;
    final int MaxHighPriority = 2;
    // In Dart, single-threaded concurrency model makes explicit Semaphore less critical for basic lists, 
    // but for async exclusion we can use a lock if needed. For now, simple async flow.
    // private val queueSemaphor: Semaphore = Semaphore(1)

    void TimeOutTimer_Elapsed()
    {
        loggingService.Value.Log("$_TAG: Time out timer tick elapsed to check request that time out.");
        CheckTimeOutRequest();
    }

    @override
    void add(RequestQueueItem element)
    {
        super.add(element);
        //run without await
        unawaited(Future(() {
            TryRunNextRequest();
        }));
        ResumeTimer();
    }

    void Resume()
    {
        ResumeTimer();
    }

    void Pause()
    {
        _timeOutTimer.Stop();
    }

    void Release()
    {
        _timeOutTimer.Stop();
        super.clear();
    }

    bool TryRunNextRequest()
    {
        var canStart = false;
        try
        {
            // queueSemaphor.withPermit... Dart's single thread handles list integrity, logical concurrency check:
            
            // Assuming Priority is comparable or we use ordinal if enum. Enum index is 'index' in Dart.
            // Items not running and not completed
            final availableItems = _items.where((it) => !it.IsRunning && !it.IsCompleted);
            
            if (availableItems.isNotEmpty)
            {
                // Let's check Priority enum: HIGH(0), NORMAL(1), LOW(2), NONE(3). 
                // Get the highest priority. So minBy index/value is correct for High priority first.
                final nextItem = availableItems.reduce((curr, next) => curr.priority.value < next.priority.value ? curr : next);

                //get count of currently running high priority requests
                final highPriorityRunning = _items.where((it) => it.priority == Priority.HIGH && it.IsRunning).length;
                //get count of all running requests
                final runningCount = _items.where((it) => it.IsRunning).length;

                //run next HIGH priority if MaxHighPriority is allow it to run
                if (nextItem.priority == Priority.HIGH && highPriorityRunning < MaxHighPriority)
                {
                    canStart = true;
                } //run next any priority if MaxBackgroundRequest is allow it to run
                else if (nextItem.priority != Priority.HIGH && highPriorityRunning == 0 && runningCount < MaxBackgroundRequest)
                {
                    canStart = true;
                }
                else
                {
                    //we can not run right now so make the current request pending to wait
                    canStart = false;
                }

                if (canStart)
                {
                  //start request
                    OnRequestStarted(nextItem);
                    //run in background (run without await)
                    unawaited(nextItem.RunRequest());
                }
                else
                {
                  //we can not start right now, so marking it as pending
                    OnRequestPending(nextItem);
                }
            }
        }
        catch (ex, stackTrace)
        {
          loggingService.Value.TrackError(ex, stackTrace);
          return true;
        }
        return canStart;
    }

    void OnItemCompleted(RequestQueueItem requestQueueItem) async
    {
        OnRequestCompleted(requestQueueItem);
        for (var i = 0; i < _items.length; i++)
        {
          final valResult = await Future(()=>TryRunNextRequest());
          if (!valResult)
            break;
        }
    }

    void OnRequestStarted(RequestQueueItem item)
    {
        try
        {
          loggingService.Value.Log("$_TAG: The next request ${item.Id} started. ${GetQueueInfo()}");
            RequestStarted.Invoke(item);
        }
        catch (ex, stackTrace)
        {
          loggingService.Value.LogError(ex, stackTrace, "OnRequestStarted() method failed for item: $item");
        }
    }

    void OnRequestPending(RequestQueueItem? item)
    {
        try
        {
          loggingService.Value.LogWarning("$_TAG: Waiting for running requests to complete. ${GetQueueInfo()}");
            if (item != null) RequestPending.Invoke(item);
        }
        catch (ex, stackTrace)
        {
          loggingService.Value.LogError(ex, stackTrace, "OnRequestPending() method failed for item $item");
        }
    }

    void OnRequestCompleted(RequestQueueItem item)
    {
        try
        {
          loggingService.Value.Log("$_TAG: The request ${item.Id} completed. ${GetQueueInfo()}");
            RequestCompleted.Invoke(item);
        }
        catch (ex, stackTrace)
        {
          loggingService.Value.LogError(ex, stackTrace, "OnRequestCompleted() method failed for item $item");
        }
    }

    String GetQueueInfo()
    {
        final totalCount = _items.length;
        final runningCount = _items.where((it) => it.IsRunning).length;
        final highPriorityCount = _items.where((it) => it.priority == Priority.HIGH).length;
        return "$_TAG: Queue total count: $totalCount, running count: $runningCount, high priority count: $highPriorityCount";
    }

    void CheckTimeOutRequest() async
    {
        if(_items.isEmpty)
        {
            StopTimer();
            return;
        }

        final timeOutList = _items.where((it) => it.isTimeOut).toList();

        if (timeOutList.isEmpty)
        {
          loggingService.Value.Log("$_TAG: No timeout requests, total items count: ${timeOutList.length}");
        }
        else
        {
          loggingService.Value.LogWarning("$_TAG: Found ${timeOutList.length} timeout items, removing them");
            for (var requestItem in timeOutList)
            {
                final emptyStackTrace = StackTrace.empty;//it will not be used because RequestQueueTimeOutException already gets the StackTrace
                requestItem.ForceToComplete(RequestQueueTimeOutException("The request id:${requestItem.Id} is TIME OUT"), emptyStackTrace, "$_TAG: The request id:${requestItem.Id} is TIME OUT");
                requestItem.RemoveFromParent();
            }

            if (_items.isEmpty)
            {
              loggingService.Value.LogWarning("$_TAG: No items to run (Count:0)");
                StopTimer();
            }
            else
            {
              loggingService.Value.Log("$_TAG: Calling TryRunNextRequest() to run next item, totalCount: ${_items.length}");
                await Future(()=> TryRunNextRequest());
            }
        }
    }

    void ResumeTimer()
    {
        if (!_timeOutTimer.IsEnabled)
        {
          loggingService.Value.LogWarning("$_TAG: Starting timer that checks time out request in the Queue list");
            _timeOutTimer.Start();
        }
    }

    void StopTimer()
    {
      loggingService.Value.LogWarning("$_TAG: Queue List is empty: stoping the timeout timer");
        _timeOutTimer.Stop();
    }
}
