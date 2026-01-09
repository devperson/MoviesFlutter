import 'package:flutter/material.dart';

class ObservableCollection<T>
{
  final List<T> _items = <T>[];

  GlobalKey<AnimatedListState> ListKey = GlobalKey<AnimatedListState>();
  RemovedItemAnimationBuilder<T>? RemovedItemAnimationDelegate;
  final animationDuration = Duration(milliseconds: 150);

  // -------- Read-only --------

  List<T> get Items
  {
    return List.unmodifiable(_items);
  }

  int get Length
  {
    return _items.length;
  }

  T operator [](int index)
  {
    return _items[index];
  }

  // -------- Single-item (animated) --------

  void Add(T item)
  {
    _items.add(item);
    ListKey.currentState?.insertItem(_items.length - 1);
  }

  void Insert(int index, T item)
  {
    _items.insert(index, item);
    ListKey.currentState?.insertItem(index);
  }

  void Remove(T removedItem)
  {
    final index = _items.indexOf(removedItem);
    RemoveAt(index);
  }

  void RemoveAt(int index)
  {
    final T removedItem = _items[index];
    _items.removeAt(index);
    ListKey.currentState?.removeItem(index, (context, animation)
                                            {
                                              if (RemovedItemAnimationDelegate != null)
                                              {
                                                return RemovedItemAnimationDelegate!(removedItem, animation);
                                              }

                                              return SizeTransition(
                                                sizeFactor: animation,
                                                child: const SizedBox.shrink(),
                                              );
                                            },
                                            duration: animationDuration);

    // await Future.delayed(animationDuration);//wait animation end
  }

  void Update(int index, T newItem)
  {
    _items[index] = newItem;
    // Caller must rebuild UI
  }

  // -------- Batch (NO animation) --------

  void AddRange(Iterable<T> items)
  {
    _items.addAll(items);
    ResetListKey();
  }

  void Clear()
  {
    if (_items.isNotEmpty)
    {
      _items.clear();
      ResetListKey();
    }
  }

  // -------- Internal --------
  void ResetListKey()
  {
     ListKey = GlobalKey<AnimatedListState>();
  }
}

typedef RemovedItemAnimationBuilder<T> = Widget Function(T item, Animation<double> animation);
