import 'IMessageEvent.dart';

abstract interface class IMessagesCenter
{
  TEvent GetOrCreateEvent<TEvent extends IMessageEvent>(TEvent Function() factory);
}
