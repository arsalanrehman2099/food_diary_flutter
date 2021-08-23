import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/screens/dashboard/user_list_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/screens/dashboard/recipe_details_screen.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:food_diary/widgets/food_item.dart';
import 'package:food_diary/widgets/logo_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data = [];

  bool _loading = false;

  @override
  void initState() {
    fetchRecipe();
  }

  fetchRecipe() async {
    setState(() => _loading = true);
    final response = await RecipeHelper().getRecipesWithUser();

    setState(() {
      _loading = false;
      data = response['response'];
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 245, 248, 1),
      appBar: mAppBar(context),
      body: _loading ? CenterLoader() : foodList(context),
    );
  }

  mAppBar(context) {
    return AppBar(
      backgroundColor: ConstantManager.primaryClr,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(15.0),
        child: LogoImage(
          h: 10.0,
          w: 10.0,
        ),
      ),
      title: Text('Food Diary',
          style: ConstantManager.htextStyle.copyWith(letterSpacing: 2.0)),
      actions: [
        IconButton(
          onPressed: () =>
              ConstantManager.screenNavigation(context, UserListScreen()),
          icon: FaIcon(FontAwesomeIcons.sms),
        ),
      ],
    );
  }

  Widget foodList(context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        viewportFraction: 1,
      ),
      items: data
          .map((i) => Builder(
                builder: (BuildContext context) => FoodItem(i),
              ))
          .toList(),
    );
  }
}
