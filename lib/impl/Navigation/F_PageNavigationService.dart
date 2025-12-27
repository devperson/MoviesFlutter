
import 'package:get/get.dart';
import 'UrlNavigationHelper.dart';

abstract class IPageNavigationService
{
  Future<void> Navigate(String url, { Map<String, dynamic>? parameters});

  Future<void> NavigateToRoot({Map<String, dynamic>? parameters});

  // Widget? getCurrentPage();
  // GetxController? getCurrentPageModel();
  // GetxController? getRootPageModel();
  // List<GetxController> getNavStackModels();

  bool get CanNavigateBack;
}


class F_PageNavigationService implements IPageNavigationService
{

  final List<String> stack = [];
  static const Duration navigationAnimationDuration = Duration(milliseconds: 300);


  bool get CanNavigateBack => stack.length > 1;

  @override
  Future<void> NavigateToRoot({Map<String, dynamic>? parameters}) async
  {
    //await Get.offAllNamed('/', arguments: parameters);
  }

  @override
  Future<void> Navigate(String url, {Map<String, dynamic>? parameters}) async
  {
    final nav = UrlNavigationHelper.Parse(url);

    if (nav.IsPush)
    {
      await OnPushAsync(url, parameters);
    }
    else if (nav.IsPop)
    {
      await OnPopAsync();
    }
    else if (nav.IsMultiPop)
    {
      await OnMultiPopAsync(url, parameters);
    }
    else if (nav.IsMultiPopAndPush)
    {
      await OnMultiPopAndPushAsync(url, parameters);
    }
    else if (nav.IsPushAsRoot)
    {
      await OnPushRootAsync(url, parameters);
    }
    else if (nav.IsMultiPushAsRoot)
    {
      await OnMultiPushRootAsync(url, parameters);
    }
    else
    {
      throw Exception("Unknown navigation type");
    }
  }

  Future<void> OnPushAsync(String url, Map<String, dynamic>? parameters) async
  {
    stack.add(url);
    //we need to put forward slash for route, this is GetX requirement
    final route = "/"+ url;
    Get.toNamed(route, arguments: parameters);

    await Future.delayed(navigationAnimationDuration);
  }

  Future<void> OnPopAsync() async
  {
     stack.removeLast();
     Get.back();

     await Future.delayed(navigationAnimationDuration);
  }

  Future<void> OnMultiPopAsync(String url, Map<String, dynamic>? parameters) async
  {
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
  }

  Future<void> OnMultiPopAndPushAsync(String url, Map<String, dynamic>? parameters) async
  {
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
  }

  Future<void> OnPushRootAsync(String url, Map<String, dynamic>? parameters) async
  {
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
  }

  Future<void> OnMultiPushRootAsync(String url, Map<String, dynamic>? parameters) async
  {
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