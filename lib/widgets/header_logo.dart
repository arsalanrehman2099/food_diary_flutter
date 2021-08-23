import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';

import 'logo_image.dart';


class HeaderLogo extends StatelessWidget {
  final text;
  final color;

  HeaderLogo({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          text,
          style: ConstantManager.ktextStyle.copyWith(
            color: color == "white" ? Colors.white : Colors.black,
            fontSize: SizeConfig.blockSizeHorizontal * 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        LogoImage(
          h: SizeConfig.blockSizeVertical * 15.0,
          w: SizeConfig.blockSizeVertical * 15.0,
          path: color == "white"
              ? ConstantManager.whiteLogoPath
              : ConstantManager.blackLogoPath,
        ),
      ],
    );
  }
}
