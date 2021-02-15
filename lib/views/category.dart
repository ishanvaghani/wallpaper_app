import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/pagination/query_change_notifier.dart';
import 'package:wallpaper_app/pagination/search_wallpaper_pagination_controller.dart';
import 'package:wallpaper_app/widgets/brand_name.dart';
import 'package:wallpaper_app/widgets/wallpaper_box.dart';

class Category extends StatefulWidget {
  final String categorieName;

  Category({this.categorieName});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      body: CategoryWidget(query: widget.categorieName),
    );
  }
}

class CategoryWidget extends ConsumerWidget {
  String query;

  CategoryWidget({@required this.query});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final queryState = watch(queryChangeNotifierProvider);
    queryState.updateQuery(query);
    final paginationController =
        watch(searchWallpaperPaginationControllerProvider);
    final paginationState =
        watch(searchWallpaperPaginationControllerProvider.state);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                  .refresh(searchWallpaperPaginationControllerProvider)
                  .getSearchWallpapers();
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
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String query;

  const _ErrorBody({
    Key key,
    @required this.message,
    this.query,
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
                .refresh(searchWallpaperPaginationControllerProvider)
                .getSearchWallpapers(),
            child: Text('Try again'),
          ),
        ],
      ),
    );
  }
}
