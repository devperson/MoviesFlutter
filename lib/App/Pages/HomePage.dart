import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/MoviesPageViewModel.dart';


class HomePage extends GetView<MoviesPageViewModel>
{
  // GetView<T> gives you controller automatically

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
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