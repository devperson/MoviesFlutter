import '../../../Abstractions/Common/AppException.dart';
import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
import '../Utils/ContainerLocator.dart';

class ConsoleServiceImpl
{
  IPlatformOutput? GetPlatformConsole()
  {
    try
    {
      return ContainerLocator.Resolve<IPlatformOutput>();
    }
    catch (ex, stackTrace)
    {
      final error = ex.ToExceptionString(stackTrace);
      print(error);
      return null;
    }
  }

  void PrintException(Object obj, StackTrace stackTrace)
  {
    final error = obj.ToExceptionString(stackTrace);
    final console = _ensureConsole();
    console.Error(error);
  }

  void PrintOrange(String message)
  {
    final console = _ensureConsole();
    console.Warn(message);
  }

  void PrintRed(String message)
  {
    final console = _ensureConsole();
    console.Error(message);
  }

  IPlatformOutput _ensureConsole()
  {
    final console = GetPlatformConsole();

    if(console == null)
    {
      throw AppException.Throw("Failed to resolve IPlatformConsole. It seems there are some issue in IPlatformOutput. The error happened in ConsoleServiceImpl.PrintException()");
    }

    return console;
  }
}

mixin ConsoleService
{
  ConsoleServiceImpl conoleSer = ConsoleServiceImpl();
  IPlatformOutput? GetPlatformConsole()
  {
    return conoleSer.GetPlatformConsole();
  }

  void PrintException(Object obj, StackTrace stackTrace)
  {
    conoleSer.PrintException(obj, stackTrace);
  }

  void PrintRed(String message)
  {
    conoleSer.PrintRed(message);
  }

  void PrintOrange(String message)
  {
    conoleSer.PrintOrange(message);
  }
}