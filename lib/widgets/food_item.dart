import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/screens/dashboard/recipe_details_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:intl/intl.dart';

class FoodItem extends StatefulWidget {
  final food;

  FoodItem(this.food);

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _checkFav();
  }

  _checkFav() async {
    _isFav = await RecipeHelper().isFavorite(widget.food['recipe']['id']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: () => ConstantManager.screenNavigation(
          context, RecipeDetailScreen(widget.food)),
      child: Container(
        decoration: ConstantManager.getBoxDecoration(),
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2.0,
            vertical: SizeConfig.blockSizeVertical * 2.0),
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                child: CachedNetworkImage(
                  imageUrl:  widget.food['recipe']['imgUrl'],
                    placeholder: (context, url) => CenterLoader(),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 3.0,
                  right: SizeConfig.blockSizeHorizontal * 3.0,
                  // top: SizeConfig.blockSizeVertical * 1.5,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.food['recipe']['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ConstantManager.ktextStyle.copyWith(
                                  color: ConstantManager.primaryClr,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 6.0,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              Text(
                                "recipe by " + widget.food['user']['username'],
                                style: ConstantManager.ktextStyle.copyWith(
                                  color: Colors.black54,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 3.5,
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_isFav)
                              RecipeHelper()
                                  .removeFavorite(widget.food['recipe']['id']);
                            else
                              RecipeHelper()
                                  .addFavorite(widget.food['recipe']['id']);
                            setState(() => _isFav = !_isFav);
                          },
                          icon: Icon(
                            _isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Icon(Icons.thumb_up_alt_outlined,
                                    color: ConstantManager.secondaryClr),
                                SizedBox(height: SizeConfig.blockSizeVertical),
                                Text(
                                  widget.food['recipe']['likes'].toString(),
                                  style: ConstantManager.ktextStyle.copyWith(
                                      color: ConstantManager.secondaryClr,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.5),
                                )
                              ],
                            ),
                            SizedBox(
                                width: SizeConfig.blockSizeHorizontal * 3.5),
                            Column(
                              children: [
                                Icon(Icons.thumb_down_alt_outlined,
                                    color: ConstantManager.secondaryClr),
                                SizedBox(height: SizeConfig.blockSizeVertical),
                                Text(
                                  widget.food['recipe']['dislikes'].toString(),
                                  style: ConstantManager.ktextStyle.copyWith(
                                    color: ConstantManager.secondaryClr,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3.5,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Text(
                          'Posted on ' +
                              DateFormat('dd/MM/yyyy')
                                  .format(widget.food['recipe']['timestamp']
                                      .toDate())
                                  .toString(),
                          style: ConstantManager.ktextStyle.copyWith(
                            color: Colors.black,
                            fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
