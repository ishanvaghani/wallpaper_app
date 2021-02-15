import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:random_string/random_string.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final String imageUrl;

  ImageView({this.imageUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final String _imageName = randomString(10);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int _location = WallpaperManager
      .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
  String _result;

  _save() async {
    await _askPermission();
    var response = await Dio().get(
      widget.imageUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: _imageName,
    );
    _setWallpaper();
  }

  _setWallpaper() async {
    try {
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      _result =
          await WallpaperManager.setWallpaperFromFile(file.path, _location);
    } on PlatformException {
      _result = 'Failed to set wallpaper';
      final snackBar = SnackBar(content: Text(_result));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    Navigator.of(context).pop();
    final snackBar = SnackBar(
      content: Text('Wallpaper set Successfully'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      await [
        Permission.photos,
      ].request();
    } else {
      await [
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white.withOpacity(0.8),
      progressWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color(0xFF1C1B1B).withOpacity(
            0.8,
          )),
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Color(0xFF1C1B1B).withOpacity(0.8),
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Color(0xFF1C1B1B).withOpacity(0.8),
          fontSize: 19.0,
          fontWeight: FontWeight.w600),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Hero(
            tag: widget.imageUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  'assests/images/placeholder.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              pr.show();
              _save();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF1C1B1B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 60.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Set Wallpaper',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Image will be saved in gallery',
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
