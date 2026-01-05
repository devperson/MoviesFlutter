abstract interface class IInfrastructureServices
{
    Future<void> Start();

    Future<void> Pause();

    Future<void> Resume();

    Future<void> Stop();
}
