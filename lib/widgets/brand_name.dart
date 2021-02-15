import 'package:flutter/material.dart';

class BrandName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Wallpaper',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'App',
            style: TextStyle(color: Colors.blue),
          ),
        ]),
  );
  }
}