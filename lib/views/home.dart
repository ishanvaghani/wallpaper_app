import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/model/categories_model.dart';
import 'package:wallpaper_app/pagination/query_change_notifier.dart';
import 'package:wallpaper_app/pagination/wallpaper_pagination_controller.dart';
import 'package:wallpaper_app/views/search.dart';
import 'package:wallpaper_app/widgets/brand_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/widgets/category_tile.dart';
import 'package:wallpaper_app/widgets/wallpaper_box.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      body: HomeWidget(),
    );
  }
}

class HomeWidget extends ConsumerWidget {
  TextEditingController _searchController = TextEditingController();
  List<CategoriesModel> _categories = getCategories();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final queryState = watch(queryChangeNotifierProvider);
    final paginationController = watch(wallpaperPaginationControllerProvider);
    final paginationState = watch(wallpaperPaginationControllerProvider.state);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: Color(0xfff5f8fd),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      context
                          .read(queryChangeNotifierProvider)
                          .updateQuery(_searchController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(
                            searchQuery: _searchController.text,
                          ),
                        ),
                      );
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Wallpaper',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context
                        .read(queryChangeNotifierProvider)
                        .updateQuery(_searchController.text);
                    if (_searchController.text != "") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(
                            searchQuery: _searchController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: Ink(
                    child: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80.0,
            child: AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return CategoriesTile(
                    index: index,
                    imageUrl: _categories[index].imageUrl,
                    title: _categories[index].categoriesName,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (paginationState.refreshError) {
                  return _ErrorBody(message: paginationState.errorMessage);
                } else if (paginationState.wallpapers.isEmpty) {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () {
                    return context
                        .refresh(wallpaperPaginationControllerProvider)
                        .getWallpapers();
                  },
                  child: AnimationLimiter(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      itemCount: paginationState.wallpapers.length,
                      staggeredTileBuilder: (index) =>
                          StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      itemBuilder: (context, index) {
                        paginationController.handleScrollWithIndex(index);
                        return WallpaperBox(
                          index: index,
                          wallpaperModel: paginationState.wallpapers[index],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context
                .refresh(wallpaperPaginationControllerProvider)
                .getWallpapers(),
            child: Text('Try again'),
          ),
        ],
      ),
    );
  }
}
