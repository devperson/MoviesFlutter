

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../../Core/Base/Impl/Utils/FontConstants.dart';
import '../Controllers/MovieDetailPageViewModel.dart';
import 'Controls/SystemBackInterceptor.dart';

class MovieDetailPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MovieDetailPageViewModel>(
        builder: (controller)
        {
          return SystemBackInterceptor(
            onSystemBack: () => controller.DeviceBackCommand.Execute(),
            child: Scaffold(
              appBar: F_PageHeaderView(
                title: "Movie Detail",
                rightIcon: Icons.edit,
                onRightPressed: () {
                  controller.EditCommand.Execute();
                },
                viewModel: controller,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // ImageView (200x300, centered)
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 300,
                          child: CachedNetworkImage(
                            imageUrl: controller.MovieItem.posterPath,
                            fit: BoxFit.cover, // centerCrop
                            placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, size: 48),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Name row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 77,
                            child: Text('Name:', textAlign: TextAlign.right),
                          ),

                          const SizedBox(width: 10), // labelsSpacing

                          Expanded(
                            child: Text(
                              controller.MovieItem.title,
                              style: const TextStyle(
                                fontFamily: FontConstants.RegularFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16), // labelsSpacing

                      // Description row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description:'),
                          const SizedBox(width: 10), // labelsSpacing
                          Expanded(
                            child: Text(
                              controller.MovieItem.overview,
                              style: const TextStyle(
                                fontFamily: FontConstants.RegularFont,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}