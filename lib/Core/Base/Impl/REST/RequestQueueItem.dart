import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/REST/Enums.dart';
import 'dart:async';
import 'RequestQueueList.dart';

class RequestQueueItem
{
  //fields
    DateTime startedAt = DateTime.now();
    ILoggingService? logger;
    RequestQueueList? parentList;
    Priority priority = Priority.NORMAL;
    TimeoutType timeoutType = TimeoutType.Medium;
    //properties
    String Id = "";
    Future<String> Function()? RequestAction;
    final Completer<String> CompletionSource = Completer<String>();
    bool IsCompleted = false;
    bool IsRunning = false;
    String? result;

    //Gets value that indicates in what n seconds the request will timeout
    int get TimeOut
    {
        switch (timeoutType)
        {
            case TimeoutType.High:
              return TimeoutType.High.value + 5;
            case TimeoutType.VeryHigh:
              return TimeoutType.VeryHigh.value + 5;
            default: return TimeoutType.Medium.value + 1;
        }
    }

    bool get isTimeOut
    {
        if (IsCompleted)
            return false;

        final now = DateTime.now();
        final elapsedSeconds = now.difference(startedAt).inSeconds;
        return elapsedSeconds > TimeOut;
    }

    Future<void> RunRequest() async
    {
        try
        {
            IsRunning = true;
            startedAt = DateTime.now();
            result = await RequestAction?.call();

            if (!CompletionSource.isCompleted)
            {
                CompletionSource.complete(result ?? "");
            }
            else
            {
                logger?.LogWarning("RequestQueueItem: Skip setting result for Id:$Id because CompletionSource was completed/cancelled");
            }

            IsCompleted = true;
            IsRunning = false;
        }
        catch (ex, stackTraces)
        {
          ForceToComplete(ex, stackTraces, "Id:$Id Failed to invoke RequestAction()");
        }
        RemoveFromParent();
    }

    void ForceToComplete(Object error, StackTrace stackTrace, String logString)
    {
        if (IsCompleted)
        {
            logger?.LogWarning("No need to force complete the request Id:$Id because it is already completed");
            logger?.LogError(error, stackTrace, "This request (with Id:$Id) was completed with error");
            return;
        }

        IsRunning = false;
        IsCompleted = true;
        if (!CompletionSource.isCompleted)
        {
          CompletionSource.completeError(error);
        }
        logger?.LogError(error, stackTrace, logString);
    }

    void RemoveFromParent()
    {
        try
        {
            if (parentList != null)
            {
                if(parentList!.contains(this))
                {
                    parentList!.remove(this);
                    parentList!.OnItemCompleted(this);
                }
            }
            parentList = null;
        }
        catch (ex, stackTrace)
        {
           logger?.LogError(ex, stackTrace, "Failed to remove item $Id from parent list");
        }
    }

    @override
  String toString()
    {
      return "RequestQueueItem {Id: $Id}";
    }
}
