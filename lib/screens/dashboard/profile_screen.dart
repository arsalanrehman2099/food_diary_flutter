import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/screens/dashboard/recipe_details_screen.dart';
import 'package:food_diary/screens/dashboard/setting_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _userData;
  var _recipeData = [];

  bool _loading = false;
  bool _recipeLoader = true;

  int _noOfLikes = 0;

  @override
  void initState() {
    _fetchUserInfo();
    _fetchUserRecipes();
  }

  _fetchUserInfo() async {
    setState(() => _loading = true);

    final response = await UserHelper().getUserInfo(UserHelper().myId());
    setState(() => _loading = false);
    if (response['error'] == 1) {
      ConstantManager.snackBar(response['message'], context);
    } else {
      setState(() {
        _userData = response['data'];
      });
    }
  }

  _fetchUserRecipes() async {
    setState(() => _recipeLoader = true);

    final response = await RecipeHelper().getUserRecipes(UserHelper().myId());
    setState(() => _recipeLoader = false);
    if (response['error'] == 1) {
      ConstantManager.snackBar(response['message'], context);
    } else {
      _recipeData = response['data'];
      _calcLikes();
    }
  }

  _calcLikes() {
    for (int i = 0; i < _recipeData.length; i++) {
      var recipe = _recipeData[i].data();
      setState(() {
        _noOfLikes += int.parse(recipe['likes'].toString());
      });
    }
  }

  _navigateSettingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingScreen(_userData),
      ),
    ).then((value) {
      _fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: _loading
          ? CenterLoader()
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 4.0),
                  child: Center(
                    child: Stack(
                      children: [
                        SettingButton(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileImage(),
                            SizedBox(
                                height: SizeConfig.blockSizeVertical * 1.5),
                            userInfo(),
                            SizedBox(
                                height: SizeConfig.blockSizeVertical * 3.0),
                            _recipeLoader ? CenterLoader() : myRecipeList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget SettingButton() {
    return InkWell(
      onTap: _navigateSettingScreen,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: CircleAvatar(
            backgroundColor: ConstantManager.secondaryClr,
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget ProfileImage() {
    return InkWell(
      onTap: _navigateSettingScreen,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: ConstantManager.secondaryClr,
            radius: SizeConfig.blockSizeVertical * 12.0,
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.5),
              radius: SizeConfig.blockSizeVertical * 11.5,
              backgroundImage: _userData['imgUrl'] == null
                  ? CachedNetworkImageProvider(_userData['gender'] == "Female"
                      ? ConstantManager.femaleChefAvatar
                      : ConstantManager.maleChefAvatar)
                  : CachedNetworkImageProvider(_userData['imgUrl']),
            ),
          ),
          Positioned(
            right: 0,
            bottom: SizeConfig.blockSizeVertical * 1.5,
            child: CircleAvatar(
              backgroundColor: ConstantManager.primaryClr,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userInfo() {
    return Column(
      children: [
        Text(
          _userData['username'],
          style: ConstantManager.ktextStyle.copyWith(
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.blockSizeHorizontal * 6.0,
              color: Colors.black87),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
        Divider(),
        SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            infoItem('likes', _noOfLikes.toString()),
            infoItem(
                'followers',
                _userData['followers'] == null
                    ? '0'
                    : _userData['followers'].length.toString()),
            infoItem('recipes', _recipeData.length.toString()),
          ],
        ),
      ],
    );
  }

  Widget infoItem(key, val) {
    return Column(
      children: [
        Text(
          val,
          style: ConstantManager.ktextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeHorizontal * 4.5),
        ),
        SizedBox(height: 2.0),
        Text(
          key,
          style: ConstantManager.ktextStyle.copyWith(
            fontSize: SizeConfig.blockSizeHorizontal * 3.0,
          ),
        ),
      ],
    );
  }

  Widget myRecipeList() {
    return _recipeData.length == 0
        ? Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.0),
            child: Text(
              'No Recipe Found',
              style: ConstantManager.ktextStyle,
            ))
        : GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            children: List.generate(
              _recipeData.length,
              (index) {
                return InkWell(
                  onTap: () {
                    var data = {
                      'user': _userData,
                      'recipe': _recipeData[index]
                    };
                    ConstantManager.screenNavigation(
                        context, RecipeDetailScreen(data));
                  },
                  child: CachedNetworkImage(
                    imageUrl: _recipeData[index].data()['imgUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          );
  }
}
