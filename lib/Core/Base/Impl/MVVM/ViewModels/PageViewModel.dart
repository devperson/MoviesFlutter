import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/AppServices/Some.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Messaging/IMessagesCenter.dart';
import 'package:movies_flutter/Core/Abstractions/UI/IAlertDialogService.dart';
import 'package:movies_flutter/Core/Abstractions/UI/ISnackbarService.dart';


import '../../../../Abstractions/MVVM/IPageLifecycleAware.dart';
import '../../../../Abstractions/MVVM/NavigationParameters.dart';
import '../../../../Abstractions/REST/Enums.dart';
import '../../../../Abstractions/REST/Exceptions/AuthExpiredException.dart';
import '../../../../Abstractions/REST/Exceptions/HttpConnectionException.dart';
import '../../../../Abstractions/REST/Exceptions/HttpRequestException.dart';
import '../../../../Abstractions/REST/Exceptions/ServerApiException.dart';
import '../../Utils/LazyInjected.dart';
import '../Helpers/AsyncCommand.dart';
import 'NavigatingBaseViewModel.dart';

class PageViewModel extends NavigatingBaseViewModel implements IPageLifecycleAware
{
   final snackbarService = LazyInjected<ISnackbarService>();
   final alertService = LazyInjected<IAlertDialogService>();
   final eventAggregator = LazyInjected<IMessagesCenter>();

   late final AppLifecycleListener _listener;

   PageViewModel()
   {
       _listener = AppLifecycleListener(
         // Triggered when app moves to foreground (WillEnterForeground / onResume)
         onResume: () => ResumedFromBackground(),

         // Triggered when app is backgrounded (DidEnterBackground / onPause)
         onPause: () => PausedToBackground(),
       );
   }

   String get vmName => runtimeType.toString();

   late final AsyncCommand BackCommand = AsyncCommand(OnBackCommand);
   late final AsyncCommand DeviceBackCommand = AsyncCommand(DoDeviceBackCommand);
   late final AsyncCommand RefreshCommand = AsyncCommand(OnRefreshCommand);

   var IsPageVisable = false;
   var IsFirstTimeAppears = true;
   var DisableDeviceBackButton = false;
   var Title = "";
   bool IsRefreshing = false;

   bool _busyLoading = false;
   bool get BusyLoading => _busyLoading;
   set BusyLoading(bool value)
   {
     _busyLoading = value;
     NotifyUpdate();
   }





   @override void OnAppearing()
   {
     LogVirtualBaseMethod("OnAppearing()");
     IsPageVisable = true;

     if (IsFirstTimeAppears)
     {
       IsFirstTimeAppears = false;
       OnFirstTimeAppears();
     }
   }

   void OnFirstTimeAppears()
   {
     LogVirtualBaseMethod("OnFirstTimeAppears()");
   }

   @override void OnDisappearing()
   {
     LogVirtualBaseMethod("OnDisappearing()");
     IsPageVisable = false;
   }

   @override
   void PausedToBackground()
   {
     LogVirtualBaseMethod("PausedToBackground()");
   }

   @override
   void ResumedFromBackground()
   {
     LogVirtualBaseMethod("ResumedFromBackground()");
   }

   ///Must be called in child class when overriding
   @override
  void Destroy()
  {
    super.Destroy();

    _listener.dispose();
  }

  Future<void> OnBackCommand(Object? param)
  {
    LogVirtualBaseMethod("OnBackCommand");
    return NavigateBack(NavigationParameters());
  }

  // this method will be called when user click system bar back in Android and swipe back gesture in iOS
   Future<void> DoDeviceBackCommand(Object? param) async
   {
     LogVirtualBaseMethod("DoDeviceBackCommand");

     if (DisableDeviceBackButton)
     {
       loggingService.Value.Log("Cancel ${runtimeType}.DoDeviceBackCommand(): Ignore back command because this page is set to cancel any device back button.",);
       return;
     }

     if (this.navigationService.Value.CanNavigateBack == false)
     {
       loggingService.Value.Log("Cancel ${runtimeType}.DoDeviceBackCommand(): Ignore back command because this page CanNavigateBack is false.",);
       return;
     }

     await OnBackCommand(param);
   }

   Future<void> OnRefreshCommand(Object? param) async
   {
     LogMethodStart("OnRefreshCommand");
   }

   Future<void> ShowLoading(Future<void> Function() AsyncAction, void Function(bool)? OnComplete) async
   {
     try
     {
       LogMethodStart("ShowLoading");
       BusyLoading = true;

       // Run in background isolate queue
       await Future(() async {
         await AsyncAction();
       });

       OnComplete?.call(true);
     }
     finally
     {
       BusyLoading = false;
     }
   }

   Future<T> ShowLoadingWithResult<T>(Future<T> Function() AsyncAction, {bool SetIsBusy = true, bool handleError = true}) async
   {
     try
     {
       LogMethodStart("ShowLoadingWithResult", args: {"SetIsBusy": SetIsBusy, "handleError": handleError});
       BusyLoading = SetIsBusy;

       final result = await Future(() async
       {
         return await AsyncAction();
       });

       if(result is! ISome)
         {
           loggingService.Value.LogWarning("ShowLoadingWithResult(): the result is not ISome (result: ${result.runtimeType}) thus can not check result");
           return result;
         }

       if(!result.Success)
         {
           loggingService.Value.LogWarning("ShowLoadingWithResult(): failed! App will try to show error to user.");
           if(handleError)
           {
             if(result.Error != null)
               HandleUIErrorFromException(result.Error!);
             else
               loggingService.Value.LogWarning("ShowLoadingWithResult(): can not show error because result.Error: null");
           }
           else
           {
             loggingService.Value.LogWarning("ShowLoadingWithResult(): skip show error because handleError: false");
           }
         }

       return result;
     }
     finally
     {
       BusyLoading = false;
     }
   }



   Future<void> ShowLoadingAndHandleErrorInBackground(Future<void> Function() BackgroundActionAsync, {bool SetIsBusy = true}) async
   {
     LogMethodStart("ShowLoadingAndHandleErrorInBackground");

     try
     {
       BusyLoading = SetIsBusy;

       await Future(() async {
         await BackgroundActionAsync();
       });
     }
     catch (ex, stack)
     {
       HandleUIError(ex, stack);
     }
     finally
     {
       BusyLoading = false;
     }
   }

   Future<T?> GetWithLoadingAndHandleError<T>(Future<T> Function() backgroundActionAsync, {bool setIsBusy = true}) async
   {
     LogMethodStart("GetWithLoadingAndHandleError");

     try
     {
       BusyLoading = setIsBusy;

       final result = await Future(() async {
         return await backgroundActionAsync();
       });

       return result;
     }
     catch (ex, stack)
     {
       HandleUIError(ex, stack);
       return null;
     }
     finally
     {
       BusyLoading = false;
     }
   }

   void HandleUIErrorFromException(AppException ex)
   {
     HandleUIError(ex, ex.ErrorStackTrace);
   }

   void HandleUIError(Object error, StackTrace stack)
   {
     LogMethodStart("HandleUIError");

     var KnownError = true;

     // // Cancellation / intentional ignore
     // if (error is CancelledException)
     // {
     //   loggingService.Value.LogWarning(
     //     "Ignoring the CancelledException",
     //   );
     //   return;
     // }

     // Auth expired / unauthorized
     if (error is AuthExpiredException ||
         error is HttpRequestException &&
             error.statusCode == HttpStatusCode.Unauthorized)
     {
       loggingService.Value.LogWarning(
         "Skip showing error popup for user because this error is handled in main view: ${error.runtimeType}: ${error.toString()}",
       );
       return;
     }

     // No internet
     if (error is HttpConnectionException)
     {
       snackbarService.Value.ShowError(
         "It looks like there may be an issue with your connection. Please check your internet connection and try again.",
       );
     }
     // HTTP errors
     else if (error is HttpRequestException)
     {
       if (error.statusCode == HttpStatusCode.ServiceUnavailable)
       {
         snackbarService.Value.ShowError(
           "The server is temporarily unavailable. Please try again later.",
         );
       }
       else
       {
         snackbarService.Value.ShowError(
           "It seems server is not available, please try again later. (StatusCode - ${error.statusCode}).",
         );
       }
     }
     // API errors
     else if (error is ServerApiException)
     {
       snackbarService.Value.ShowError(
         "Internal Server Error. Please try again later.",
       );
     }
     else
     {
       KnownError = false;
       snackbarService.Value.ShowError(
         "Oops something went wrong, please try again later.",
       );
     }

     if (KnownError)
     {
       loggingService.Value.LogError(error, stack);
     }
     else
     {
       loggingService.Value.TrackError(error, stack);
     }
   }
}
