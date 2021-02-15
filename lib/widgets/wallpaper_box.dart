import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/views/image_view.dart';

class WallpaperBox extends StatelessWidget {
  final WallpaperModel wallpaperModel;
  final int index;

  const WallpaperBox({Key key, this.wallpaperModel, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(
                imageUrl: wallpaperModel.src.portrait,
              ),
            ),
          );
        },
        child: AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: ScaleAnimation(
              child: Hero(
                tag: wallpaperModel.src.portrait,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedNetworkImage(
                      imageUrl: wallpaperModel.src.portrait,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assests/images/placeholder.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}