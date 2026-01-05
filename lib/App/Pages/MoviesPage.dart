import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_CircleIconButton.dart';
import '../Controllers/MoviesPageViewModel.dart';
import 'Controls/SideMenuView.dart';


class MoviesPage extends GetView<MoviesPageViewModel>
{
  // GetView<T> gives you controller automatically

  @override
  Widget build(BuildContext context)
  {
    controller.StringItems.RemovedItemAnimationDelegate = this.BuildRemovedItem;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(padding: const EdgeInsets.only(left: 8),
                        child: Builder(builder: (context) => F_CircleIconButton(icon: Icons.menu,
                                                                  onPressed: () {
                                                                    Scaffold.of(context).openDrawer();
                                                                  },),
                        ),
                      ),
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: F_CircleIconButton(
                  icon: Icons.add,
                  onPressed: () {},
                ),
              ),
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: SideMenuView(
          onShareLogs: () { controller.ShareLogsCommand.Execute(); },
          onLogout: () { controller.LogoutCommand.Execute(); },
        ),
      ),
      body: GetBuilder<MoviesPageViewModel>(
        builder: (_) => AnimatedList(
          key: controller.StringItems.ListKey,
          initialItemCount: controller.StringItems.Length,
          itemBuilder: (context, index, animation)
          {
            final item = controller.StringItems[index];
            return SizeTransition(sizeFactor: animation,  child: BuildItem(item, index));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }

  // -------- Row builders --------

  Widget BuildItem(String item, int index)
  {
    return ListTile(
      title: Text(item),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => controller.RemoveCommand.Execute(index)),
    );
  }

  Widget BuildRemovedItem(String item, Animation<double> animation)
  {
    return SizeTransition(
      sizeFactor: animation,
      child: BuildItem(item, 0),
    );
  }
}