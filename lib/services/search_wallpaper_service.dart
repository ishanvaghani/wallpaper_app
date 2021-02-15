import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/services/wallpaper_exception.dart';

import '../enviroment_config.dart';

final searchWallpaperServiceProvider = Provider<SearchWallpaperService>((ref) {
  final config = ref.watch(environmentConfigProvider);
  return SearchWallpaperService(config, Dio());
});


class SearchWallpaperService {
  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  SearchWallpaperService(this._environmentConfig, this._dio);

  Future<List<WallpaperModel>> getSearchWallpapers(String query,
      [int page = 1]) async {
    try {
      _dio.options.headers['Authorization'] =
          _environmentConfig.wallpaperApiKey;
      final response = await _dio.get(
          'https://api.pexels.com/v1/search?query=$query&per_page=20&page=$page');

      final results = List<Map<String, dynamic>>.from(response.data['photos']);
      List<WallpaperModel> wallpapers = results
          .map((movieData) => WallpaperModel.fromMap(movieData))
          .toList(growable: false);

      return wallpapers;
    } on DioError catch (dioError) {
      print(dioError.message);
      throw WallpaperException.fromDioError(dioError);
    }
  }
}
