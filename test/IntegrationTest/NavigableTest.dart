import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Abstractions/MVVM/IPageNavigationService.dart';
import 'package:movies_flutter/Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';

abstract class NavigableTest
{
  /// Called after every test
  void LogOut()
  {
    LogMessage("***********TEST method ends****************");
  }

  PageViewModel? GetCurrentPage()
  {
    final navigation = ContainerLocator.Resolve<IPageNavigationService>();
    return navigation.GetCurrentPageModel();
  }

  void EnsureNoError()
  {
    final log = ContainerLocator.Resolve<ILoggingService>();

    if (log.HasError)
    {
      final exc = log.LastError!;
      log.LastError = null;


      throw LogLastErrorException(exc.ToAppException(log.LastStackTrace!));
    }
  }

  Future<void> Navigate(String name) async
  {
    final nav = ContainerLocator.Resolve<IPageNavigationService>();
    await nav.Navigate(name);
  }

  /// Kotlin `reified` equivalent:
  /// explicit runtime type comparison
  Never ThrowWrongPageError<T extends PageViewModel>(PageViewModel wrongPage)
  {
    final correctPageName = T.toString();
    final wrongPageName = wrongPage.runtimeType.toString();

    final error = "App should be navigated to $correctPageName but navigated to $wrongPageName.";

    ThrowException(error);
  }

  T GetNextPage<T extends PageViewModel>()
  {
    EnsureNoError();

    final page = GetCurrentPage();

    if (page is T)
    {
      return page;
    }
    else
    {
      ThrowWrongPageError<T>(page ?? (throw Exception("No current page")));
    }
  }

  // ---------------------------------------------------------------------------
  // Helper placeholders (test framework integration)
  // ---------------------------------------------------------------------------

  void LogMessage(String message)
  {
    print(message);
  }

  Never ThrowException(String message)
  {
    throw Exception(message);
  }
}

class LogLastErrorException extends AppException
{
  LogLastErrorException(AppException causedEx) : super.FromException("LogLastErrorException: App logger captured error, check caused exception", causedException: causedEx);
}
