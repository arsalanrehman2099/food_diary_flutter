import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_diary/api/search_services.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:food_diary/widgets/header_logo.dart';
import 'package:food_diary/widgets/search_item.dart';

class SearchRecipeScreen extends StatefulWidget {
  final List selectedIngredients;

  SearchRecipeScreen(this.selectedIngredients);

  @override
  _SearchRecipeScreenState createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  bool _loading = true;

  List _recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  fetchRecipes() async {
    final response =
        await SearchServices().fetchRecipes(widget.selectedIngredients);
    final jsonResponse = jsonDecode(response.body);
    setState(() => _loading = false);

    print(jsonResponse);

    if (jsonResponse['error'] == 0) {
      setState(() {
        _recipes = jsonResponse['recipes'];
      });
    } else {
      ConstantManager.showtoast('Network Error. Please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            _divider(),
            _loading
                ? CenterLoader()
                : _recipes.length == 0
                ? _noRecipeFoundText()
                : _recipeGridView(),
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
      child: HeaderLogo(text: 'Results', color: 'black'),
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

  Widget _recipeGridView(){
    return  GridView.count(
      shrinkWrap: true,
      primary: false,
      childAspectRatio: 0.70,
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      children: List.generate(
        _recipes.length,
            (index) => SearchItem(_recipes[index]),
      ),
    );
  }

  Widget _noRecipeFoundText() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.0),
      child: Text(
        'No Recipe Found',
        style: ConstantManager.ktextStyle,
      ),
    );
  }
}
