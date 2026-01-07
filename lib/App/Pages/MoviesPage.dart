import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/FontConstants.dart';
import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../Controllers/MoviesPageViewModel.dart';
import '../MockData.dart';
import 'Controls/SideMenuView.dart';


class MoviesPage extends GetView<MoviesPageViewModel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: F_PageHeaderView(
        title: "Movies",
        leftIcon: Icons.menu,
        onLeftPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        rightIcon: Icons.add,
        onRightPressed: () {
          controller.AddCommand.Execute();
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
        builder: (_) => AnimatedListView<MovieItemModel>(
          items: controller.Movies,
          isSameItem: (oldItem, newItem) => oldItem.id == newItem.id,
          // Correct: itemBuilder only takes context and index
          itemBuilder: (context, index) {
            return BuildMovieCell(index);
          },
          enterTransition: [FadeIn(), ScaleIn()],
          exitTransition: [SlideInLeft()],
          insertDuration: const Duration(milliseconds: 300),
          removeDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget BuildMovieCell(int index) {
    final movie = controller.Movies[index];

    return InkWell(
      key: ValueKey(movie.id),
      onTap: () {
        controller.ItemTappedCommand.Execute(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 100,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 20, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontFamily: FontConstants.RegularFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
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