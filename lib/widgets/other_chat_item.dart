
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/profile_image.dart';
import 'package:intl/intl.dart';

class OtherChatItem extends StatelessWidget {
  String? message;
  String? name;
  String? imgUrl;
  Timestamp? dateTime;

  OtherChatItem({this.message, this.name, this.imgUrl, this.dateTime});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImage(image: imgUrl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 3.2,
                ),
                child: Text(
                  name!.split(" ")[0],
                  textAlign: TextAlign.left,
                  style: ConstantManager.ktextStyle.copyWith(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: SizeConfig.blockSizeHorizontal * 3.0,
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.70),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 3.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message!,
                      textAlign: TextAlign.left,
                      style: ConstantManager.ktextStyle.copyWith(color: Colors.black),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical / 1.5),
                    Text(
                      DateFormat('hh:mm a').format(
                          DateTime.parse(dateTime!.toDate().toString())),
                      style: ConstantManager.ktextStyle.copyWith(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: SizeConfig.blockSizeHorizontal * 2.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
