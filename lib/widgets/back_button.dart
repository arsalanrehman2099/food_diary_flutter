import 'package:flutter/material.dart';
import 'package:food_diary/utils/size_config.dart';

class BackButton extends StatelessWidget {

  final color;

  BackButton({@required this.color:Colors.white});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 20.0,
          right: 20.0,
          bottom: 15.0,
        ),
        child: Icon(
          Icons.arrow_back_ios,
          color: color,
          size: SizeConfig.blockSizeHorizontal * 8.0,
        ),
      ),
    );
  }
}
