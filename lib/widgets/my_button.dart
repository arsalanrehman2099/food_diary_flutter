import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final void Function()? onClick;

  MyButton({this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical:  SizeConfig.blockSizeVertical * 2.5),
        decoration: BoxDecoration(
            color: ConstantManager.secondaryClr,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        width: double.infinity,
        child: Text(
          text!.toUpperCase(),
          style: ConstantManager.ktextStyle.copyWith(color: Colors.white, letterSpacing: 1),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
