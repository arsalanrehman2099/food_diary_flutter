import 'package:flutter/material.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/screens/dashboard/recipe_details_screen.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:food_diary/widgets/favorite_item.dart';
import 'package:food_diary/widgets/header_logo.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  double? itemHeight;
  double? itemWidth;

  var _favorites;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  _fetchFavorites() async {
    setState(() => _loading = true);
    _favorites = await RecipeHelper().getFavorite();

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            _divider(),
            _loading
                ? CenterLoader()
                : _favorites.length == 0
                    ? _nofavText()
                    : _favoriteGridView(context),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 8.0,
        left: SizeConfig.blockSizeHorizontal * 4.0,
        right: SizeConfig.blockSizeHorizontal * 4.0,
      ),
      child: HeaderLogo(text: 'Favorites', color: 'black'),
      // child: ConstantManager.blackHeaderLogo('Favorites'),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 4.0,
      ),
      child: Divider(),
    );
  }

  Widget _favoriteGridView(context) {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      childAspectRatio: 0.70,
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      children: List.generate(
        _favorites.length,
        (index) => FavoriteItem(_favorites[index],_fetchFavorites()),
      ),
    );
  }

  Widget _nofavText() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.0),
      child: Text(
        'No Favorites Added',
        style: ConstantManager.ktextStyle,
      ),
    );
  }
}
