import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/pagination/query_change_notifier.dart';
import 'package:wallpaper_app/pagination/search_wallpaper_pagination_controller.dart';
import 'package:wallpaper_app/widgets/brand_name.dart';
import 'package:wallpaper_app/widgets/wallpaper_box.dart';

class Search extends StatefulWidget {
  String searchQuery;

  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();

  void _searchWallpaper() {
    context
        .read(queryChangeNotifierProvider)
        .updateQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      body: SearchWidget(
        searchController: _searchController,
      ),
    );
  }
}

class SearchWidget extends ConsumerWidget {
  TextEditingController searchController;

  SearchWidget({@required this.searchController});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final queryState = watch(queryChangeNotifierProvider);
    final paginationController =
        watch(searchWallpaperPaginationControllerProvider);
    final paginationState =
        watch(searchWallpaperPaginationControllerProvider.state);

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
                          .updateQuery(searchController.text);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Wallpaper',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (searchController.text != "") {
                      context
                          .read(queryChangeNotifierProvider)
                          .updateQuery(searchController.text);
                    }
                  },
                  child: Ink(
                    child: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (paginationState.refreshError) {
                  return _ErrorBody(
                      searchController: searchController,
                      message: paginationState.errorMessage);
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
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final TextEditingController searchController;

  const _ErrorBody({
    Key key,
    @required this.message,
    this.searchController,
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
