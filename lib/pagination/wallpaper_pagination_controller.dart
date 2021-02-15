import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pagination/wallpaper_pagination.dart';
import '../services/wallpaper_exception.dart';
import '../services/wallpaper_service.dart';

final wallpaperPaginationControllerProvider =
    StateNotifierProvider<WallpaperPaginationController>((ref) {
  final wallpaperService = ref.read(wallpaperServiceProvider);
  return WallpaperPaginationController(wallpaperService);
});

class WallpaperPaginationController extends StateNotifier<WallpaperPagination> {
  WallpaperPaginationController(this._wallpaperService,
      [WallpaperPagination state])
      : super(
          state ?? WallpaperPagination.initial(),
        ) {
    getWallpapers();
  }

  final WallpaperService _wallpaperService;

  Future<void> getWallpapers() async {
    try {
      final wallpapers = await _wallpaperService.getWallpapers(state.page);
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
      getWallpapers();
    }
  }
}
