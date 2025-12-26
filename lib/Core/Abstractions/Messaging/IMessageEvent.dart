abstract class IMessageEvent
{
  void Subscribe(void Function(Object?) Handler);
  void Unsubscribe(void Function(Object?) Handler);
  void Publish(Object? Args);
}
