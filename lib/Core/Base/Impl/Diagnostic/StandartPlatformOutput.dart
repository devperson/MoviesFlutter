import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';

class StandartPlatformOutput implements IPlatformOutput
{
    @override
    void Info(String message)
    {
        print(message);
    }

    @override
    void Warn(String message)
    {
        print(message);
    }

    @override
    void Error(String message)
    {
        print(message);
    }
}
