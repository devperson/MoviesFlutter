abstract interface class IDeviceThreadService
{
    void BeginInvokeOnMainThread(void Function() action);
}
