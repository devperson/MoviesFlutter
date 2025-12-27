import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';

class AppPlatformOutput implements IPlatformOutput
{
  @override
  void Error(String Message) {
    print(Message);
  }

  @override
  void Info(String Message) {
    print(Message);
  }

  @override
  void Warn(String Message) {
    print(Message);
  }

}