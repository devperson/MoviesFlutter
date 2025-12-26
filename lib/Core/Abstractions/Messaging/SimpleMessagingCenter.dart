import 'IMessageEvent.dart';
import 'IMessagesCenter.dart';

class SubMessage implements IMessageEvent
{
  final List<void Function(Object?)> _handlers = [];

  @override
  void Subscribe(void Function(Object?) handler)
  {
    if (!_handlers.contains(handler))
      _handlers.add(handler);
  }

  @override
  void Unsubscribe(void Function(Object?) handler)
  {
    _handlers.remove(handler);
  }

  @override
  void Publish(Object? Args)
  {
    final snapshot = List<void Function(Object?)>.from(_handlers);
    for (final handler in snapshot)
    {
      handler(Args);
    }
  }
}


class SimpleMessageCenter implements IMessagesCenter
{
  final Map<Type, Object> _events = {};

  @override
  TEvent GetOrCreateEvent<TEvent extends IMessageEvent>(TEvent Function() factory)
  {
    final type = TEvent;

    final existing = _events[type];
    if (existing != null)
    {
      return existing as TEvent;
    }

    final newInstance = factory();
    _events[type] = newInstance;
    return newInstance;
  }

// ******** USAGE ********
// final event = Center.GetOrCreateEvent<SubMessage>(() => SubMessage());
}

