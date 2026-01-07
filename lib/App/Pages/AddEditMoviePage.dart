


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_EditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_MultilineEditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../../Core/Base/Impl/UI/Controls/F_PrimaryButton.dart';
import '../../Core/Base/Impl/Utils/ColorConstants.dart';
import '../Controllers/AddEditMoviePageViewModel.dart';

class AddEditMoviePage extends GetView<AddEditMoviePageViewModel>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: F_PageHeaderView(
        title: "Movie Detail",
        rightIcon: Icons.delete,
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
              child: GestureDetector(
                onTap: (){ controller.ChangePhotoCommand.Execute(); },
                child: Card(
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: SizedBox(
                    width: 200,
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        if (!controller.MovieItem.posterPath.isEmpty)
                          CachedNetworkImage(
                            imageUrl: controller.MovieItem.posterPath,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                            const Center(child: CircularProgressIndicator()),
                            errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                          )
                        else
                          Container(color: Colors.grey.shade300),

                        Container(
                          color: Colors.white.withOpacity(0.5),
                        ),

                        const Center(
                          child: Icon(
                            Icons.photo_camera,
                            size: 45,
                            color: Colors.black,
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
                    placeholder: "",
                    onChanged: (text){ controller.MovieItem.title = text;},
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
                    placeholder: "",
                    onChanged: (text){ controller.MovieItem.overview = text; },
                    minHeight: 150,
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
              onTap: (){ controller.SaveCommand.Execute(); },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}