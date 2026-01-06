
import 'package:get/get.dart';


import '../../../Abstractions/Navigation/IPageNavigationService.dart';
import '../../../Abstractions/Navigation/NavigationParameters.dart';
import '../../../Abstractions/Navigation/UrlNavigationHelper.dart';
import '../../MVVM/ViewModels/BaseViewModel.dart';
import '../../MVVM/ViewModels/NavigatingBaseViewModel.dart';


class F_PageNavigationService implements IPageNavigationService
{
  final List<String> stack = [];
  static const Duration navigationAnimationDuration = Duration(milliseconds: 300);


  bool get CanNavigateBack => stack.length > 1;

  @override
  Future<void> NavigateToRoot({NavigationParameters? parameters}) async
  {
    vmStack.last.OnNavigatedFrom();

    var params = NavigationParameters();
    if(parameters != null)
    {
      params = parameters;
    }

    final rootCtrl = stack.first;
    Get.until((route)
    {
      return route.settings.name == '/$rootCtrl';
    });
    await Future.delayed(navigationAnimationDuration);

    vmStack.last.OnNavigatedTo(params);
  }

  @override
  Future<void> Navigate(String url, {NavigationParameters? parameters}) async
  {
    var params = NavigationParameters();
    if(parameters != null)
    {
      params = parameters;
    }

    final nav = UrlNavigationHelper.Parse(url);

    if (nav.IsPush)
    {
      await OnPushAsync(url, params);
    }
    else if (nav.IsPop)
    {
      await OnPopAsync(params);
    }
    else if (nav.IsMultiPop)
    {
      await OnMultiPopAsync(url, params);
    }
    else if (nav.IsMultiPopAndPush)
    {
      await OnMultiPopAndPushAsync(url, params);
    }
    else if (nav.IsPushAsRoot)
    {
      await OnPushRootAsync(url, params);
    }
    else if (nav.IsMultiPushAsRoot)
    {
      await OnMultiPushRootAsync(url, params);
    }
    else
    {
      throw Exception("Unknown navigation type");
    }
  }

  Future<void> OnPushAsync(String url, NavigationParameters parameters) async
  {
    vmStack.last.OnNavigatedFrom();

    stack.add(url);
    //we need to put forward slash for route, this is GetX requirement
    final route = "/"+ url;
    Get.toNamed(route, arguments: parameters);
    await Future.delayed(navigationAnimationDuration);

    vmStack.last.OnNavigatedTo(parameters);
  }

  Future<void> OnPopAsync(NavigationParameters parameters) async
  {
     vmStack.last.OnNavigatedFrom();
     stack.removeLast();
     Get.back();

     await Future.delayed(navigationAnimationDuration);

     vmStack.last.OnNavigatedTo(parameters);
  }

  Future<void> OnMultiPopAsync(String url, NavigationParameters parameters) async
  {
    vmStack.last.OnNavigatedFrom();

    // how many levels to pop
    final popCount = url.split('/').length - 1;

    // safety
    if (popCount <= 0 || stack.length <= 1)
    {
       throw Exception("Multi pop can not be applied here, url=$url");
    }

    // calculate target index
    final targetIndex = stack.length - 1 - popCount;
    if (targetIndex < 0)
    {
       throw Exception("Multi pop can not be applied here, url=$url. Stack contains less items than tring to pop. Stack: ${stack.join(' > ')}");
    }

    // update logical stack
    stack.removeRange(targetIndex + 1, stack.length);

    int popped = 0;

    Get.until((route)
    {
      if (popped >= popCount)
      {
        return true;
      }

      popped++;
      return false;
    });

    await Future.delayed(navigationAnimationDuration);

    vmStack.last.OnNavigatedTo(parameters);
  }

  Future<void> OnMultiPopAndPushAsync(String url, NavigationParameters parameters) async
  {
    vmStack.last.OnNavigatedFrom();

     final parts = url.split('/');
     final popCount = parts.where((e) => e == '..').length;
     final targetCtrl = parts.last;

     // calculate base index
     final baseIndex = (stack.length - 1 - popCount).clamp(0, stack.length - 1);

     // rebuild logical stack
     stack.removeRange(baseIndex + 1, stack.length);
     stack.add(targetCtrl);

     // now rebuild GetX stack, it will pop until and then push targetCtrl
     Get.offNamedUntil('/$targetCtrl',
          (route) => route.settings.name == '/${stack[baseIndex]}',
      arguments: parameters,);

    await Future.delayed(navigationAnimationDuration);

    vmStack.last.OnNavigatedTo(parameters);
  }

  Future<void> OnPushRootAsync(String url, NavigationParameters parameters) async
  {
    vmStack.last.OnNavigatedFrom();

     // url comes as "/page"
     final ctrlName = url.startsWith('/')
        ? url.substring(1)
        : url;

     // 1️⃣ reset logical stack
      stack.clear();
      stack.add(ctrlName);

     // 2️⃣ reset GetX navigation
     Get.offAllNamed('/$ctrlName', arguments: parameters);

     // 3️⃣ wait for animation end
     await Future.delayed(Get.defaultTransitionDuration);

    vmStack.last.OnNavigatedTo(parameters);
  }

  Future<void> OnMultiPushRootAsync(String url, NavigationParameters parameters) async
  {
    vmStack.last.OnNavigatedFrom();
    // "/page1/page2" -> ["page1", "page2"]
    final pages = url
        .split('/')
        .where((e) => e.isNotEmpty)
        .toList();

    if (pages.isEmpty) return;

    // 1️⃣ reset logical stack
    stack.clear();
    stack.addAll(pages);

    // 2️⃣ push first page as root
    Get.offAllNamed('/${pages.first}', arguments: parameters);

    // 3️⃣ push remaining pages
    for (int i = 1; i < pages.length; i++)
    {
      Get.toNamed('/${pages[i]}', arguments: parameters);
    }

    await Future.delayed(Get.defaultTransitionDuration);

    vmStack.last.OnNavigatedTo(parameters);
  }

@override
  List<String> GetNavStack()
  {
    return stack;
  }

  final List<NavigatingBaseViewModel> vmStack = [];

  // @override
  // Widget? getCurrentPage() {
  //   return Get.routing.current == null ? null : Get.routing.current!;
  // }
  //
  // @override
  // GetxController? getCurrentPageModel() {
  //   return Get.isRegistered<GetxController>()
  //       ? Get.find<GetxController>()
  //       : null;
  // }
  //
  // @override
  // GetxController? getRootPageModel() {
  //   // Root controller usually permanent
  //   return Get.isRegistered<GetxController>()
  //       ? Get.find<GetxController>()
  //       : null;
  // }
  //
  // @override
  // List<GetxController> getNavStackModels() {
  //   // GetX does not expose full stack controllers directly
  //   // This is usually managed manually if needed
  //   return [];
  // }
}