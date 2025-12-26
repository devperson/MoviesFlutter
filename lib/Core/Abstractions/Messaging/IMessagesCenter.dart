import 'IMessageEvent.dart';

abstract class IMessagesCenter
{
  TEvent GetOrCreateEvent<TEvent extends IMessageEvent>(TEvent Function() factory);
}
