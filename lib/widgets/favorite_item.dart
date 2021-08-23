import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/screens/dashboard/recipe_details_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';

class FavoriteItem extends StatelessWidget {

  final data;
  final reload;

  FavoriteItem(this.data,this.reload);

  @override
  Widget build(BuildContext context) {
    print(data);
    SizeConfig().init(context);

    return InkWell(
      onTap: (){
        ConstantManager.screenNavigation(context, RecipeDetailScreen(data));
      },
      child: Container(
        decoration: BoxDecoration(
          color: ConstantManager.secondaryClr,
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal),
        child: Stack(
          children: [
            _backgroundImage(data['recipe']['imgUrl']),
            _blackEffect(),
            _favoriteBtn(),
            _recipeName(data['recipe']['name'])
          ],
        ),
      ),
    );
  }

  // image
  Widget _backgroundImage(url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _blackEffect() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  }

  Widget _favoriteBtn() {
    return Positioned(
      right: 10,
      top: 10,
      child: InkWell(
        onTap: (){
          RecipeHelper().removeFavorite(data['recipe']['id']);
          reload();
        },
        child: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
          decoration: BoxDecoration(
            shape: BoxShape.circle
          ),
          child: Icon(
            Icons.favorite,
            color: Colors.redAccent,
            size: SizeConfig.blockSizeHorizontal * 5.5,
          ),
        ),
      ),
    );
  }

  Widget _recipeName(text) {
    return Positioned(
      bottom: 0,
      left: 15,
      top: 0,
      right: 15,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: ConstantManager.ktextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize:SizeConfig.blockSizeHorizontal * 4.5,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
