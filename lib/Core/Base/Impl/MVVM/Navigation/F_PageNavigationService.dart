
import 'dart:async';

import 'package:get/get.dart';
import '../../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../../Abstractions/MVVM/IPageNavigationService.dart';
import '../../../../Abstractions/MVVM/NavigationParameters.dart';
import '../../../../Abstractions/MVVM/UrlNavigationHelper.dart';
import '../../Diagnostic/LoggableService.dart';
import '../../MVVM/ViewModels/PageViewModel.dart';



class F_PageNavigationService with LoggableService implements IPageNavigationService
{
  List<String> stack = [];
  final List<PageViewModel> vmStack = [];
  static const Duration navigationAnimationDuration = Duration(milliseconds: 400);

  F_PageNavigationService()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogUINavigationKey);
  }

  bool get CanNavigateBack
  {
    final result = stack.length > 1;
    var stackString = stack.join('>');
    SpecificLogMethodFinished('CanNavigateBack', {'result': result, 'stack': stackString});
    return result;
  }

  @override
  Future<void> NavigateToRoot({NavigationParameters? parameters}) async
  {
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('NavigateToRoot', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

    vmStack.last.OnNavigatedFrom();

    var params = NavigationParameters();
    if(parameters != null)
    {
      params = parameters;
    }

    final rootCtrl = stack.first;
    stack = [rootCtrl];
    Get.until((route)
    {
      return route.settings.name == '/$rootCtrl';
    });
    await Future.delayed(navigationAnimationDuration);

    vmStack.last.OnNavigatedTo(params);


    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('NavigateToRoot', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

  @override
  Future<void> Navigate(String url, {NavigationParameters? parameters}) async
  {
    SpecificLogMethodStart('Navigate', {'url': url});

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
    final page = url;
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('OnPushAsync', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

    vmStack.last.OnNavigatedFrom();

    stack.add(page);
    //we need to put forward slash for route, this is GetX requirement
    final route = "/"+ page;
    unawaited(Get.toNamed(route, arguments: parameters));//do not need to await
    await Future.delayed(navigationAnimationDuration);

    final vm = GetViewModel(page);
    vm.OnNavigatedTo(parameters);

    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('OnPushAsync', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

  Future<void> OnPopAsync(NavigationParameters parameters) async
  {
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('OnPopAsync', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

     vmStack.last.OnNavigatedFrom();
     stack.removeLast();
     Get.back();

     await Future.delayed(navigationAnimationDuration);

    final vm = GetViewModel(stack.last);
    vm.OnNavigatedTo(parameters);

    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('OnPopAsync', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

  Future<void> OnMultiPopAsync(String url, NavigationParameters parameters) async
  {
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('OnMultiPopAsync', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

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

    final vm = GetViewModel(stack.last);
    vm.OnNavigatedTo(parameters);

    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('OnMultiPopAsync', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

  Future<void> OnMultiPopAndPushAsync(String url, NavigationParameters parameters) async
  {
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('OnMultiPopAndPushAsync', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

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
    unawaited(Get.offNamedUntil('/$targetCtrl',
          (route) => route.settings.name == '/${stack[baseIndex]}',
      arguments: parameters,));

    await Future.delayed(navigationAnimationDuration);

    final vm = GetViewModel(stack.last);
    vm.OnNavigatedTo(parameters);

    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('OnMultiPopAndPushAsync', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

  Future<void> OnPushRootAsync(String url, NavigationParameters parameters) async
  {
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('OnPushRootAsync', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

    vmStack.last.OnNavigatedFrom();

     // url comes as "/page"
     final ctrlName = url.startsWith('/')
        ? url.substring(1)
        : url;

     // 1️⃣ reset logical stack
      stack.clear();
      stack.add(ctrlName);

     // 2️⃣ reset GetX navigation
    unawaited(Get.offAllNamed('/$ctrlName', arguments: parameters));

     // 3️⃣ wait for animation end
    await Future.delayed(navigationAnimationDuration);

    final vm = GetViewModel(stack.last);
    vm.OnNavigatedTo(parameters);

    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('OnPushRootAsync', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

  Future<void> OnMultiPushRootAsync(String url, NavigationParameters parameters) async
  {
    var stackString = stack.join('>');
    var vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodStart('OnMultiPushRootAsync', {'stackBefore': stackString, 'vmStackBefore': vmStackString});

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
    unawaited(Get.offAllNamed('/${pages.first}', arguments: parameters));

    // 3️⃣ push remaining pages
    for (int i = 1; i < pages.length; i++)
    {
      unawaited(Get.toNamed('/${pages[i]}', arguments: parameters));
    }

    await Future.delayed(navigationAnimationDuration);

    final vm = GetViewModel(stack.last);
    vm.OnNavigatedTo(parameters);

    stackString = stack.join('>');
    vmStackString = vmStack.map((e) => e.vmName).join(', ');
    SpecificLogMethodFinished('OnMultiPushRootAsync', {'stackAfter': stackString, 'vmStackAfter': vmStackString});
  }

@override
  List<String> GetNavStack()
  {
    return stack;
  }

  PageViewModel GetViewModel(String name)
  {
    SpecificLogMethodStart('GetViewModel', {'name': name});

    final vm = vmStack.firstWhere((v)=>v.vmName == name);
    return vm;
  }

  void SetInitialPage(String page)
  {
    stack = [page];
  }

  @override
  PageViewModel? GetCurrentPageModel() {
    // TODO: implement GetCurrentPageModel
    throw UnimplementedError();
  }



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