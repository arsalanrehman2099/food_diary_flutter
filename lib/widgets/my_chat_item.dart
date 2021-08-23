
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:intl/intl.dart';

class MyChatItem extends StatelessWidget {
  String? message;
  Timestamp? dateTime;

  MyChatItem({this.message, this.dateTime});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3.5),
          decoration: BoxDecoration(
              color: ConstantManager.secondaryClr, borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message!,
                textAlign: TextAlign.left,
                style: ConstantManager.ktextStyle.copyWith(color: Colors.white),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical / 1.5),
              Text(
                DateFormat('hh:mm a').format(
                    DateTime.parse(dateTime!.toDate().toString())),
                style: ConstantManager.ktextStyle.copyWith(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: SizeConfig.blockSizeHorizontal * 2.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget dateText() {
  //   return Text(
  //     DateFormat('HH:mm')
  //         .format(DateTime.fromMillisecondsSinceEpoch(dateTime!))
  //         .toString(),
  //     style: ktextStyle.copyWith(
  //       color: Colors.white.withOpacity(0.5),
  //       fontSize: SizeConfig.blockSizeHorizontal * 3.0,
  //     ),
  //   );
  // }
}
