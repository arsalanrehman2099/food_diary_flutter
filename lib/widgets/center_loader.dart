import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';

class CenterLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ConstantManager.secondaryClr,
      ),
    );
  }
}
