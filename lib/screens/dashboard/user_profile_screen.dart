import 'package:flutter/material.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/screens/dashboard/chat_screen.dart';
import 'package:food_diary/screens/dashboard/recipe_details_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';

class UserProfileScreen extends StatefulWidget {
  final user_id;

  UserProfileScreen(this.user_id);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var _userData;
  var _recipeData = [];

  bool _loading = false;
  bool _recipeLoader = true;
  bool? _isfollowing;

  int _noOfLikes = 0;

  @override
  void initState() {
    _fetchUserInfo();
    _fetchUserRecipes();
    _checkfollowing();
  }

  _fetchUserInfo() async {
    setState(() => _loading = true);

    final response = await UserHelper().getUserInfo(widget.user_id);
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

    final response = await RecipeHelper().getUserRecipes(widget.user_id);
    setState(() => _recipeLoader = false);
    if (response['error'] == 1) {
      ConstantManager.snackBar(response['message'], context);
    } else {
      _recipeData = response['data'];
      _calcLikes();
    }
  }

  _checkfollowing() async {
    _isfollowing = await UserHelper().checkFollowing(widget.user_id);
    setState(() {});
  }

  _calcLikes() {
    for (int i = 0; i < _recipeData.length; i++) {
      var recipe = _recipeData[i].data();
      setState(() {
        _noOfLikes += int.parse(recipe['likes'].toString());
      });
    }
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileImage(),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                        userInfo(),
                        SizedBox(height: SizeConfig.blockSizeVertical * 3.0),
                        _recipeLoader ? CenterLoader() : myRecipeList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget ProfileImage() {
    return CircleAvatar(
      backgroundColor: ConstantManager.secondaryClr,
      radius: SizeConfig.blockSizeVertical * 12.0,
      child: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(0.5),
        radius: SizeConfig.blockSizeVertical * 11.5,
        backgroundImage: _userData['imgUrl'] == null
            ? NetworkImage(_userData['gender'] == "Female"
                ? ConstantManager.femaleChefAvatar
                : ConstantManager.maleChefAvatar)
            : NetworkImage(_userData['imgUrl']),
      ),
    );
  }

  Widget FollowMessageButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FollowBtn(),
          SizedBox(width: SizeConfig.blockSizeHorizontal * 4.0),
          MsgBtn(),
        ],
      ),
    );
  }

  Widget FollowBtn() {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (_isfollowing!) {
            UserHelper().unfollow(widget.user_id);
          } else {
            UserHelper().follow(widget.user_id);
          }
          setState(() {
            _isfollowing = !_isfollowing!;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 1.5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5), offset: Offset(2, 2))
            ],
            borderRadius: BorderRadius.circular(20.0),
            gradient: new LinearGradient(
              colors: [
                Colors.pink,
                Colors.red,
                Colors.orange,
                Colors.yellow,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, color: Colors.white),
              SizedBox(width: SizeConfig.blockSizeHorizontal),
              Text(
                _isfollowing != null
                    ? _isfollowing!
                        ? 'Followed'
                        : 'Follow'
                    : '',
                style: ConstantManager.ktextStyle.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MsgBtn() {
    return Expanded(
      child: InkWell(
        onTap: () {
          var id = widget.user_id;
          var username = _userData['username'];
          var imgUrl = _userData['imgUrl'] == null
              ? _userData['gender'] == "Female"
                  ? ConstantManager.femaleChefAvatar
                  : ConstantManager.maleChefAvatar
              : _userData['imgUrl'];

          ConstantManager.screenNavigation(
            context,
            ChatScreen(
              other_id: id,
              other_name: username,
              other_img: imgUrl,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 1.5),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5), offset: Offset(2, 2))
              ],
              borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message),
              SizedBox(width: SizeConfig.blockSizeHorizontal),
              Text('Message', style: ConstantManager.ktextStyle),
            ],
          ),
        ),
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
        FollowMessageButtons(),
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
                  child: Image.network(
                    _recipeData[index].data()['imgUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          );
  }
}
