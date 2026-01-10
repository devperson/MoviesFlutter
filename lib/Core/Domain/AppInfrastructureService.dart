import 'package:movies_flutter/Core/Base/Impl/Diagnostic/LoggableService.dart';
import 'package:movies_flutter/Core/Base/Impl/InfrastructureService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

import '../Abstractions/AppServices/IInfrastructureServices.dart';
import '../Abstractions/Repository/ILocalDbInitilizer.dart';

class AppInfrastructureService extends BaseInfrastructureService with LoggableService implements IInfrastructureServices
{
  final dbInitilizer = LazyInjected<ILocalDbInitilizer>();

  @override
  Future<void> Start() async
  {
    LogMethodStart("Start");
    await super.Start();
    await dbInitilizer.Value.Init();
  }

  @override
  Future<void> Pause() async
  {
    LogMethodStart("Pause");
    await super.Pause();
  }

  @override
  Future<void> Resume() async
  {
    LogMethodStart("Resume");
    await super.Resume();
  }

  @override
  Future<void> Stop() async
  {
    LogMethodStart("Stop");
    await super.Stop();
    await dbInitilizer.Value.Release();
  }
}
