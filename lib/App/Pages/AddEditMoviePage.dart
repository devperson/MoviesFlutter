


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_EditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_MultilineEditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../../Core/Base/Impl/UI/Controls/F_PrimaryButton.dart';
import '../Controllers/AddEditMoviePageViewModel.dart';
import 'Controls/SystemBackInterceptor.dart';

class AddEditMoviePage extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder<AddEditMoviePageViewModel>(
        builder: (controller)
        {
          return SystemBackInterceptor(
              onSystemBack: ()=> controller.DeviceBackCommand.Execute(),
              child: Scaffold(
            appBar: F_PageHeaderView(
              title: controller.Title.value,
              rightIcon: controller.IsEdit ? Icons.delete : null,
              //show delete button only if in edit mode
              onRightPressed: () {
                controller.DeleteCommand.Execute();
              },
              viewModel: controller,
            ),

            body: SingleChildScrollView(
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
                      // Material is required for InkWell to render
                      child: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 200,
                          height: 300,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // 1. Background Image
                              if (!controller.MovieItem.posterPath.isEmpty)
                                CachedNetworkImage(
                                  imageUrl: controller.MovieItem.posterPath,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) =>
                                  const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                                )
                              else
                                Container(color: Colors.grey.shade300),

                              // 2. Semi-transparent Overlay
                              Container(
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

                              // 4. THE RIPPLE LAYER (Placed last to be on top)
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    // Set the ripple (splash) color
                                    splashColor: Colors.grey.withValues(
                                        alpha: 0.4),
                                    // Set the color when the button is held down
                                    highlightColor: Colors.grey.withValues(
                                        alpha: 0.2),
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
                        child: Text('Title:', textAlign: TextAlign.right),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: F_EditTextField(
                          controller: controller.titleController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

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
                    text: 'Submit',
                    onTap: () {
                      controller.SaveCommand.Execute();
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          );
        });
  }
}