import 'package:colorid_print/colorid_print.dart';
import '../../../Abstractions/Common/AppException.dart';
import '../../../Abstractions/Diagnostics/CommonTAG.dart';
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
      PrintException(ex, stackTrace);
      return null;
    }
  }

  void PrintException(Object obj, StackTrace stackTrace)
  {
    final error = obj.ToExceptionString(stackTrace);
    final console = GetPlatformConsole();
    if(console!= null)
    {
      console.Error(error);
    }
    else
    {
      PrintRed(error);
    }

  }

  void PrintRed(String message)
  {
    ColoridPrint.redPrint("${CommonTAG.LOGGER_TAG}: $message");
    print("${CommonTAG.LOGGER_TAG}: $message");
  }

  void PrintOrange(String message)
  {
    ColoridPrint.yellowPrint("${CommonTAG.LOGGER_TAG}: $message");
    print("${CommonTAG.LOGGER_TAG}: $message");
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