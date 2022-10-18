import 'dart:ui';import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height-(size.height/5));
    path.quadraticBezierTo(size.width/4, size.height, size.width/2, size.height-(size.height/8));
    path.quadraticBezierTo(size.width - (size.width/4), size.height-(size.height/3.5),
        size.width, size.height-(size.height/7));
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}