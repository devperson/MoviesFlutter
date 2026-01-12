import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/FontConstants.dart';
import '../../Core/Base/Impl/UI/Controls/F_ImageView.dart';
import '../../Core/Base/Impl/UI/Controls/F_PageHeaderView.dart';
import '../Controllers/Items/MovieItemModel.dart';
import '../Controllers/MoviesPageViewModel.dart';
import 'Controls/SideMenuView.dart';

class MoviesPage extends StatelessWidget {
  // Use const constructor for the page itself
  const MoviesPage({super.key});

  // Use a final key for the scaffold
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<
      ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoviesPageViewModel>(
        builder: (controller) {
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
                onShareLogs: () {
                  controller.ShareLogsCommand.Execute();
                },
                onLogout: () {
                  controller.LogoutCommand.Execute();
                },
              ),
            ),
            body: RefreshIndicator(
                onRefresh: () async
                {
                  await controller.RefreshCommand.ExecuteAsync();
                },
                child: SafeArea(
                  child: AnimatedListView<MovieItemModel>(
                    items: controller.Movies,
                    isSameItem: (oldItem, newItem) => oldItem.id == newItem.id,
                    itemBuilder: (context, index) {
                      return _buildMovieCell(index, controller);
                    },
                    physics: const AlwaysScrollableScrollPhysics(), // Forces the list to be scrollable even when content is short or empty, so pull-to-refresh (RefreshIndicator) can always be triggered.
                    enterTransition: [FadeIn(), ScaleIn()],
                    // Added const
                    exitTransition: [SlideInLeft()],
                    // Added const
                    insertDuration: const Duration(milliseconds: 300),
                    removeDuration: const Duration(milliseconds: 300),
                  ),
                )
            ),
          );
        });
  }

  Widget _buildMovieCell(int index, MoviesPageViewModel controller) {
    final movie = controller.Movies[index];
    final isLast = index == controller.Movies.length - 1;

    return Column(
      key: ValueKey(movie.id),
      children: [
        InkWell(
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
                    child: F_ImageView(
                        path: movie.posterPath,
                        fit: BoxFit.fitHeight
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
        ),
        if (!isLast)
          const Divider( // Removed redundant Padding as Divider has default height
            height: 1,
            thickness: 0.6,
            indent: 0,
            endIndent: 0,
          ),
      ],
    );
  }
}
