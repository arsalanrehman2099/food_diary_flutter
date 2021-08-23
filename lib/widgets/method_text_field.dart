import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';

class MethodTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;

  MethodTextField({this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint!,
            style: ConstantManager.ktextStyle.copyWith(color: ConstantManager.primaryClr.withOpacity(0.9)),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Container(
          height: SizeConfig.blockSizeVertical * 30.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.0),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
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

