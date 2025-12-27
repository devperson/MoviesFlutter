class SimpleEvent
{
  final List<void Function()> _handlers = <void Function()>[];

  void AddListener(void Function() listener)
  {
    _handlers.add(listener);
  }

  // swift-friendly version of minusAssign
  void RemoveListener(void Function() listener)
  {
    _handlers.remove(listener);
  }

  void Invoke()
  {
    final List<void Function()> handlersCopy = List<void Function()>.from(_handlers);

    for (final handler in handlersCopy)
    {
      handler();
    }
  }
}


class Event<T>
{
  // List of functions (handlers) that will be called when the event is triggered
  final List<void Function(T)> _handlers = <void Function(T)>[];

  void AddListener(void Function(T) listener)
  {
    _handlers.add(listener);
  }

  void RemoveListener(void Function(T) listener)
  {
    _handlers.remove(listener);
  }

  // Invokes the event, calling all subscribed handlers with the provided value.
  void Invoke(T Value)
  {
    final handlersCopy = List<void Function(T)>.from(_handlers);
    for (final handler in handlersCopy)
    {
      handler(Value);
    }
  }
}
