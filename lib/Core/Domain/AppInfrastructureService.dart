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
    LogMethodStart();
    await super.Start();
    await dbInitilizer.Value.Init();
  }

  @override
  Future<void> Pause() async
  {
    LogMethodStart();
    await super.Pause();
  }

  @override
  Future<void> Resume() async
  {
    LogMethodStart();
    await super.Resume();
  }

  @override
  Future<void> Stop() async
  {
    LogMethodStart();
    await super.Stop();
    await dbInitilizer.Value.Release();
  }

}