import 'package:movies_flutter/Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';

class PageViewModelResolver
{
  static final Map<String, PageViewModel Function()> _Factories = {};

  /// Registers a ViewModel factory under a navigation name
  ///
  /// C# mental model:
  /// services.AddTransient<HomeViewModel>("HomePage");
  static void Register<TViewModel extends PageViewModel>(String name,PageViewModel Function() factory)
  {
    if (_Factories.containsKey(name))
    {
      throw Exception('ViewModel with name "$name" is already registered.');
    }

    _Factories[name] = factory;
  }

  /// Resolves a ViewModel by navigation name
  static PageViewModel Resolve(String name)
  {
    final factory = _Factories[name];

    if (factory == null)
    {
      throw Exception('No ViewModel registered for navigation name "$name".');
    }

    return factory();
  }
}