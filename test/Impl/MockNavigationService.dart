import 'package:movies_flutter/Core/Abstractions/MVVM/IPageNavigationService.dart';
import 'package:movies_flutter/Core/Abstractions/MVVM/NavigationParameters.dart';
import 'package:movies_flutter/Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';

import 'PageViewModelResolver.dart';

class MockPageNavigationService implements IPageNavigationService {
  final List<PageViewModel> ViewModelStackList = [];

  @override
  bool get CanNavigateBack => ViewModelStackList.length > 1;

  @override
  Future<void> Navigate(String name, {NavigationParameters? parameters}) async
  {
    GetCurrentPageModel()?.OnDisappearing();

    var newPageName = name;

    if (name.contains('../'))
    {
      final splitCount = name.split('/').length - 1;

      for (var i = 0; i < splitCount; i++)
      {
        GetCurrentPageModel()?.Destroy();
        if (ViewModelStackList.isNotEmpty)
        {
          ViewModelStackList.removeLast();
        }
      }

      newPageName = name.replaceAll('../', '');
    }
    else if (name.contains('/'))
    {
      for (final vm in ViewModelStackList)
      {
        vm.Destroy();
      }
      ViewModelStackList.clear();
      newPageName = name.replaceAll('/', '');
    }

    if (newPageName.isEmpty)
    {
      if (name.contains('../') &&
          parameters != null &&
          parameters.Count() > 0)
      {
        GetCurrentPageModel()?.OnNavigatedTo(parameters);
      }
      return;
    }

    // Resolve directly from DI container (Koin equivalent)
    final PageViewModel viewModel = PageViewModelResolver.Resolve(newPageName);

    final params = parameters ?? NavigationParameters();
    viewModel.Initialize(params);
    viewModel.OnNavigatedTo(params);
    viewModel.OnAppearing();
    // viewModel.OnAppeared();

    GetCurrentPageModel()?.OnNavigatedFrom();

    ViewModelStackList.add(viewModel);
  }

  @override
  Future<void> NavigateToRoot({NavigationParameters? parameters}) async
  {
    while (ViewModelStackList.length > 1)
    {
      final current = ViewModelStackList.removeLast();
      current.Destroy();
    }
  }

  // @override
  // IPage? GetCurrentPage() {
  //   throw UnimplementedError();
  // }


  PageViewModel? GetCurrentPageModel()
  {
    return ViewModelStackList.isNotEmpty
        ? ViewModelStackList.last
        : null;
  }

  // @override
  // PageViewModel? GetRootPageModel() {
  //   throw UnimplementedError();
  // }
  //
  // @override
  // List<PageViewModel> GetNavStackModels() {
  //   return List.unmodifiable(ViewModelStackList);
  // }

  @override
  List<String> GetNavStack() {
    // TODO: implement GetNavStack
    throw UnimplementedError();
  }
}