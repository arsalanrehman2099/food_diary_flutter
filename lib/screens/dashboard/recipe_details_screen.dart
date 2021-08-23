import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/screens/dashboard/profile_screen.dart';
import 'package:food_diary/screens/dashboard/user_profile_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:intl/intl.dart';

class RecipeDetailScreen extends StatelessWidget {
  final data;

  RecipeDetailScreen(this.data);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            RecipeImage(context),
            DraggableScrollableSheet(
              initialChildSize: 0.68,
              minChildSize: 0.40,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 5.0,
                          horizontal: SizeConfig.blockSizeHorizontal * 3.5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () => ConstantManager.screenNavigation(
                                    context,
                                    data['user']['id'] == UserHelper().myId()
                                        ? ProfileScreen()
                                        : UserProfileScreen(data['user']['id']),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['recipe']['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            ConstantManager.ktextStyle.copyWith(
                                          color: ConstantManager.primaryClr,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  5.5,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                      SizedBox(
                                          height: SizeConfig.blockSizeVertical /
                                              2.0),
                                      Row(
                                        children: [
                                          Text(
                                            'recipe by ',
                                            style: ConstantManager.ktextStyle
                                                .copyWith(
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        3.5,
                                                    color: Colors.black
                                                        .withOpacity(0.75)),
                                          ),
                                          Text(
                                            data['user']['username'],
                                            style: ConstantManager.ktextStyle
                                                .copyWith(
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  3.5,
                                              color:
                                                  ConstantManager.secondaryClr,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                    color: ConstantManager.secondaryClr,
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Text(
                                  data['recipe']['category'],
                                  style: ConstantManager.ktextStyle
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.thumb_up,
                                          color: ConstantManager.secondaryClr),
                                      SizedBox(
                                          height: SizeConfig.blockSizeVertical),
                                      Text(
                                        data['recipe']['likes'].toString(),
                                        style:
                                            ConstantManager.ktextStyle.copyWith(
                                          color: ConstantManager.secondaryClr,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.5,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 3.5),
                                  Column(
                                    children: [
                                      Icon(Icons.thumb_down,
                                          color: ConstantManager.secondaryClr),
                                      SizedBox(
                                          height: SizeConfig.blockSizeVertical),
                                      Text(
                                        data['recipe']['dislikes'].toString(),
                                        style: ConstantManager.ktextStyle
                                            .copyWith(
                                                color: ConstantManager
                                                    .secondaryClr,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    3.5),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                'Posted on ' +
                                    DateFormat('dd/MM/yyyy')
                                        .format(data['recipe']['timestamp']
                                            .toDate())
                                        .toString(),
                                style: ConstantManager.ktextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3.5),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          Divider(),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ingredients',
                              style: ConstantManager.ktextStyle.copyWith(
                                color: ConstantManager.primaryClr,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeHorizontal * 5.5,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 2.5),
                          MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.separated(
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: data['recipe']['ingredients'].length,
                              separatorBuilder: (ctx, i) =>
                                  SizedBox(height: 5.0),
                              itemBuilder: (ctx, i) {
                                return keyValue(
                                  data['recipe']['ingredients']
                                      .keys
                                      .toList()[i],
                                  data['recipe']['ingredients']
                                      .values
                                      .toList()[i],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          Divider(),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Method',
                              style: ConstantManager.ktextStyle.copyWith(
                                color: ConstantManager.primaryClr,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeHorizontal * 5.5,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data['recipe']['method'],
                              style: ConstantManager.ktextStyle.copyWith(
                                color: Colors.black,
                                fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget RecipeImage(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: CachedNetworkImage(
        imageUrl: data['recipe']['imgUrl'],
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget FavoriteButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
            size: SizeConfig.blockSizeVertical * 5.0,
          ),
        ),
      ),
    );
  }

  Widget keyValue(key, val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            key + ":",
            style: ConstantManager.ktextStyle
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
            child: Text(
          val,
          style: ConstantManager.ktextStyle,
          textAlign: TextAlign.right,
        )),
      ],
    );
  }
}
