import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/pagination/query_change_notifier.dart';
import 'package:wallpaper_app/services/search_wallpaper_service.dart';
import 'package:wallpaper_app/services/wallpaper_exception.dart';

import 'wallpaper_pagination.dart';

final searchWallpaperPaginationControllerProvider =
    StateNotifierProvider<SearchWallpaperPaginationController>(
  (ref) {
    final queryProvider = ref.read(queryChangeNotifierProvider);
    final searchWallpaperService = ref.read(searchWallpaperServiceProvider);
    return SearchWallpaperPaginationController(
        searchWallpaperService, queryProvider.searchQuery);
  },
);

class SearchWallpaperPaginationController
    extends StateNotifier<WallpaperPagination> {
  SearchWallpaperPaginationController(this._searchWallpaperService, this.query,
      [WallpaperPagination state])
      : super(
          state ?? WallpaperPagination.initial(),
        ) {
    getSearchWallpapers();
  }

  final SearchWallpaperService _searchWallpaperService;
  final String query;

  Future<void> getSearchWallpapers() async {
    try {
      final wallpapers =
          await _searchWallpaperService.getSearchWallpapers(query, state.page);
      state = state.copyWith(wallpapers: [
        ...state.wallpapers,
        ...wallpapers,
      ], page: state.page + 1);
    } on WallpaperException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 20 == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ 20;

    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getSearchWallpapers();
    }
  }
}
