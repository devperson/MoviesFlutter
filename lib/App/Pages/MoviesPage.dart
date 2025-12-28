import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_CircleIconButton.dart';
import '../Controllers/MoviesPageViewModel.dart';


class MoviesPage extends GetView<MoviesPageViewModel>
{
  // GetView<T> gives you controller automatically

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(padding: const EdgeInsets.only(left: 8),
                        child: F_CircleIconButton(
                          icon: Icons.menu,
                          onPressed: () {
                            print('Menu pressed');
                          },
                        ),
                      ),
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
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
      body: Center(
        child: Obx(() => Text(
          'Count: ${controller.count}',
          style: const TextStyle(fontSize: 24),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}