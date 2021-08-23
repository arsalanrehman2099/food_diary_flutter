import 'package:flutter/material.dart';
import 'package:food_diary/screens/dashboard/chat_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/profile_image.dart';

class UserItem extends StatelessWidget {
  final id;
  final username;
  final imgUrl;

  UserItem({this.id, this.username, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      decoration: ConstantManager.getBoxDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ConstantManager.screenNavigation(
            context,
            ChatScreen(
              other_id: id,
              other_name: username,
              other_img: imgUrl,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 6,
                  child: ProfileImage(
                    image: imgUrl,
                    size: SizeConfig.blockSizeVertical * 8.0,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical,
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    username.toString(),
                    textAlign: TextAlign.center,
                    style: ConstantManager.ktextStyle.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
