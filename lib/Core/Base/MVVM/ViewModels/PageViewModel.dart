import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Messaging/IMessagesCenter.dart';
import 'package:movies_flutter/Core/Abstractions/Navigation/NavigationParameters.dart';
import 'package:movies_flutter/Core/Abstractions/UI/IAlertDialogService.dart';
import 'package:movies_flutter/Core/Abstractions/UI/ISnackbarService.dart';
import 'package:movies_flutter/Core/Base/MVVM/ViewModels/NavigatingBaseViewModel.dart';

import '../../../Abstractions/REST/Enums.dart';
import '../../../Abstractions/REST/Exceptions/AuthExpiredException.dart';
import '../../../Abstractions/REST/Exceptions/HttpConnectionException.dart';
import '../../../Abstractions/REST/Exceptions/HttpRequestException.dart';
import '../../../Abstractions/REST/Exceptions/ServerApiException.dart';
import '../../Impl/Utils/LazyInjected.dart';
import '../Helpers/AsyncCommand.dart';

class PageViewModel extends NavigatingBaseViewModel
{
   final snackbarService = LazyInjected<ISnackbarService>();
   final alertService = LazyInjected<IAlertDialogService>();
   final eventAggregator = LazyInjected<IMessagesCenter>();

   String get vmName => runtimeType.toString();

   Rx<String> Title = "".obs;
   late final AsyncCommand BackCommand = AsyncCommand(OnBackCommand);
   late final AsyncCommand DeviceBackCommand = AsyncCommand(DoDeviceBackCommand);
   final IsPageVisable = false.obs;
   final IsFirstTimeAppears = true.obs;
   final BusyLoading = false.obs;
   final DisableDeviceBackButton = false;

  Future<void> OnBackCommand(Object? param)
  {
    LogVirtualBaseMethod("OnBackCommand()");
    return NavigateBack(NavigationParameters());
  }

  // this method will be called when user click system bar back in Android and swipe back gesture in iOS
   Future<void> DoDeviceBackCommand(Object? param) async
   {
     LogVirtualBaseMethod("DoDeviceBackCommand()");

     if (DisableDeviceBackButton)
     {
       loggingService.Value.Log("Cancel ${runtimeType}.DoDeviceBackCommand(): Ignore back command because this page is set to cancel any device back button.",);
       return;
     }

     await OnBackCommand(param);
   }

   Future<void> ShowLoading(Future<void> Function() AsyncAction, void Function(bool)? OnComplete) async
   {
     try
     {
       LogMethodStart("ShowLoading");
       BusyLoading.value = true;

       // Run in background isolate queue
       await Future(() async {
         await AsyncAction();
       });

       OnComplete?.call(true);
     }
     finally
     {
       BusyLoading.value = false;
     }
   }

   Future<T> ShowLoadingWithResult<T>(Future<T> Function() AsyncAction, {bool SetIsBusy = true}) async
   {
     try
     {
       LogMethodStart("ShowLoadingWithResult");
       BusyLoading.value = SetIsBusy;

       final result = await Future(() async {
         return await AsyncAction();
       });

       return result;
     }
     finally
     {
       BusyLoading.value = false;
     }
   }

   Future<void> ShowLoadingAndHandleErrorInBackground(Future<void> Function() BackgroundActionAsync, {bool SetIsBusy = true}) async
   {
     LogMethodStart("ShowLoadingAndHandleErrorInBackground");

     try
     {
       BusyLoading.value = SetIsBusy;

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
       BusyLoading.value = false;
     }
   }

   Future<T?> GetWithLoadingAndHandleError<T>(Future<T> Function() backgroundActionAsync, {bool setIsBusy = true}) async
   {
     LogMethodStart("GetWithLoadingAndHandleError");

     try
     {
       BusyLoading.value = setIsBusy;

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
       BusyLoading.value = false;
     }
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