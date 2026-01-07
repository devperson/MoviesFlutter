import 'package:movies_flutter/Core/Base/Impl/Diagnostic/LoggableService.dart';
import 'package:movies_flutter/Core/Base/Impl/InfrastructureService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

import '../Abstractions/Repository/ILocalDbInitilizer.dart';

class AppInfrastructureService extends InfrastructureService with LoggableService
{
  final dbInitilizer = LazyInjected<ILocalDbInitilizer>();

  @override
  Future<void> Start() async
  {
    await super.Start();
    dbInitilizer.Value.Init();
  }

  @override
  Future<void> Pause() async
  {
    await super.Pause();
  }

  @override
  Future<void> Resume() async
  {
    await super.Resume();
  }

  @override
  Future<void> Stop() async
  {
    await super.Stop();
    dbInitilizer.Value.Release();
  }

}