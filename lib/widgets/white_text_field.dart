import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';

class WhiteTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextInputType textInputType;
  final bool hideText;
  final bool enable;

  WhiteTextField(
      {this.controller,
        this.hint,
        this.textInputType = TextInputType.text,
        this.hideText = false,this.enable=true});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint!,
            style: ConstantManager.ktextStyle.copyWith(color:ConstantManager.primaryClr.withOpacity(0.9)),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal:SizeConfig.blockSizeHorizontal * 2.0),
          child: TextField(
            controller: controller,
            keyboardType: textInputType,
            obscureText: hideText,
            enabled: enable,
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}
