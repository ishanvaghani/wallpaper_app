import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wallpaper_app/views/category.dart';

class CategoriesTile extends StatelessWidget {
  final String imageUrl, title;
  final int index;

  CategoriesTile(
      {@required this.imageUrl, @required this.title, @required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category(
              categorieName: title,
            ),
          ),
        );
      },
      child: AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 5.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 50.0,
                      width: 100.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assests/images/placeholder.jpg',
                        fit: BoxFit.cover,
                        height: 50.0,
                        width: 100.0,
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
