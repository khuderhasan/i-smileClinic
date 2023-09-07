import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class CustomShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height ;
    double width = size.width ;
    var path = Path();
    path.lineTo(0, height-55);
    path.quadraticBezierTo(width /2  , height, width, height-55) ;
    path.lineTo(width, 0);
    path.close();
    return path ;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true ;
  }

}