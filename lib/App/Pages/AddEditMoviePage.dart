import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_EditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_ImageView.dart';
import '../../Core/Base/Impl/UI/Controls/F_MultilineEditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../../Core/Base/Impl/UI/Controls/F_PrimaryButton.dart';
import '../Controllers/AddEditMoviePageViewModel.dart';
import 'Controls/SystemBackInterceptor.dart';

class AddEditMoviePage extends StatelessWidget {
  const AddEditMoviePage({super.key}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEditMoviePageViewModel>(
      builder: (controller) {
        return SystemBackInterceptor(
          onSystemBack: () => controller.DeviceBackCommand.Execute(),
          child: Scaffold(
            appBar: F_PageHeaderView(
              title: controller.Title,
              rightIcon: controller.IsEdit ? Icons.delete : null,
              onRightPressed: () {
                controller.DeleteCommand.Execute();
              },
              viewModel: controller,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    // =========================
                    // Photo card
                    // =========================
                    Center(
                      child: Card(
                        elevation: 1,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 200,
                            height: 300,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // 1. Background Image
                                F_ImageView(
                                  path: controller.MovieItem.posterPath,
                                  fit: BoxFit.cover,
                                ),

                                // 2. Semi-transparent Overlay
                                Container(
                                  // Cannot be const because of withValues runtime call
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),

                                // 3. Icon
                                const Center(
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 45,
                                    color: Colors.black,
                                  ),
                                ),

                                // 4. THE RIPPLE LAYER
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.grey.withValues(alpha: 0.4),
                                      highlightColor: Colors.grey.withValues(alpha: 0.2),
                                      onTap: () {
                                        controller.ChangePhotoCommand.Execute();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // =========================
                    // Name
                    // =========================
                    Row(
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Text(
                            'Title:',
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: F_EditTextField(
                            controller: controller.titleController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // Description
                    // =========================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "Description:",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: F_MultilineEditTextField(
                            controller: controller.descriptionController,
                            minHeight: 200,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // =========================
                    // Save button
                    // =========================
                    F_PrimaryButton(
                      text: 'Save',
                      onTap: () {
                        controller.SaveCommand.Execute();
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
