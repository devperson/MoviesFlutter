class SimpleEvent
{
  final List<void Function()> _handlers = <void Function()>[];

  void operator +(void Function() Handler)
  {
    _handlers.add(Handler);
  }

  void operator -(void Function() Handler)
  {
    _handlers.remove(Handler);
  }

  // swift-friendly version of plusAssign
  void AddListener(void Function() Listener)
  {
    _handlers.add(Listener);
  }

  // swift-friendly version of minusAssign
  void RemoveListener(void Function() Listener)
  {
    _handlers.remove(Listener);
  }

  void Invoke()
  {
    final List<void Function()> handlersCopy =
    List<void Function()>.from(_handlers);

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

  // Adds a new subscriber (handler) to the event.
  void operator +(void Function(T) Handler)
  {
    _handlers.add(Handler);
  }

  // Removes a subscriber (handler) from the event.
  void operator -(void Function(T) Handler)
  {
    _handlers.remove(Handler);
  }

  // swift-friendly version of plusAssign
  void AddListener(void Function(T) Listener)
  {
    _handlers.add(Listener);
  }

  // swift-friendly version of minusAssign
  void RemoveListener(void Function(T) Listener)
  {
    _handlers.remove(Listener);
  }

  // Invokes the event, calling all subscribed handlers with the provided value.
  void Invoke(T Value)
  {
    for (final handler in _handlers)
    {
      handler(Value);
    }
  }
}
