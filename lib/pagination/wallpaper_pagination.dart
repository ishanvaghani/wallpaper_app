import 'package:flutter/foundation.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';

class WallpaperPagination {
  final List<WallpaperModel> wallpapers;
  final int page;
  final String errorMessage;
  WallpaperPagination({
    this.wallpapers,
    this.page,
    this.errorMessage,
  });

  WallpaperPagination.initial()
      : wallpapers = [],
        page = 1,
        errorMessage = '';

  bool get refreshError => errorMessage != '' && wallpapers.length <= 20;

  WallpaperPagination copyWith({
    List<WallpaperModel> wallpapers,
    int page,
    String errorMessage,
  }) {
    return WallpaperPagination(
      wallpapers: wallpapers ?? this.wallpapers,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'WallpaperPagination(wallpapers: $wallpapers, page: $page, errorMessage: $errorMessage)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WallpaperPagination &&
        listEquals(o.wallpapers, wallpapers) &&
        o.page == page &&
        o.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      wallpapers.hashCode ^ page.hashCode ^ errorMessage.hashCode;
}
