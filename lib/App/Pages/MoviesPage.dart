import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/FontConstants.dart';

import '../../Core/Base/Impl/UI/Controls/F_CircleIconButton.dart';
import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../Controllers/MoviesPageViewModel.dart';
import '../MockData.dart';
import 'Controls/SideMenuView.dart';


class MoviesPage extends GetView<MoviesPageViewModel>
{
  // GetView<T> gives you controller automatically

  @override
  Widget build(BuildContext context)
  {
    controller.Movies.RemovedItemAnimationDelegate = this.BuildRemovedItem;

    return Scaffold(
      appBar: F_PageHeaderView(
        title: "Movies",
        leftIcon: Icons.menu,
        onLeftPressed: () {
            Scaffold.of(context).openDrawer();
        },
        rightIcon: Icons.add,
        onRightPressed: () {
        },
        viewModel: controller,
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
          key: controller.Movies.ListKey,
          initialItemCount: controller.Movies.Length,
          itemBuilder: (context, index, animation)
          {
            final item = controller.Movies[index];
            return SizeTransition(sizeFactor: animation,  child: BuildMovieCell(item, index));
          },
        ),
      ),
    );
  }

  Widget BuildRemovedItem(MovieItemModel item, Animation<double> animation)
  {
    return SizeTransition(
      sizeFactor: animation,
      child: BuildMovieCell(item, 0),
    );
  }

  Widget BuildMovieCell(MovieItemModel movie, int index)
  {
    return InkWell(
      onTap: () {
        controller.ItemTappedCommand.Execute(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ImageView
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 100,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath,
                  fit: BoxFit.fitHeight, // closest to fitStart
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            ),

            // Texts column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 20, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontFamily: FontConstants.RegularFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Description
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        fontFamily: FontConstants.RegularFont,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}