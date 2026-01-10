import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

import '../../Abstractions/AppServices/IInfrastructureServices.dart';
import 'REST/RequestQueueList.dart';

abstract class BaseInfrastructureService implements IInfrastructureServices
{
  final restQueueService = LazyInjected<RequestQueueList>();

  @override
  Future<void> Start() async
  {
  }

  @override
  Future<void> Pause() async
  {
    restQueueService.Value.Pause();
  }

  @override
  Future<void> Resume() async
  {
    restQueueService.Value.Resume();
  }

  @override
  Future<void> Stop() async
  {
    restQueueService.Value.Release();
  }

}