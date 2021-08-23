import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';

class LogoImage extends StatelessWidget {
  final double h;
  final double w;
  final String path;

  LogoImage(
      {this.h: 100, this.w: 100, this.path: ConstantManager.whiteLogoPath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      height: h,
      width: w,
    );

  }
}
