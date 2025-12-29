import 'package:flutter/foundation.dart';

import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';

class StandartPlatformOutput implements IPlatformOutput
{
    @override
    void Info(String message)
    {
      if (kDebugMode)
      {
        print(message);
      }
    }

    @override
    void Warn(String message)
    {
        if (kDebugMode)
        {
          print(message);
        }
    }

    @override
    void Error(String message)
    {
      if (kDebugMode)
      {
        print(message);
      }
    }
}
