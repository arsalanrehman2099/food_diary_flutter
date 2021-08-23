import 'package:flutter/material.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/models/user.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:food_diary/widgets/profile_image.dart';
import 'package:food_diary/widgets/user_item.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _loading = false;

  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _readData();
  }

  _readData() async {
    setState(() => _loading = true);
    final response = await UserHelper().listOfUsers();

    setState(() => _loading = false);
    if (response['error'] == 1) {
      ConstantManager.snackBar(response['message'], context);
    } else {
      setState(() => _users = response['data']);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: _appBar(),
      body: _loading ? CenterLoader() : _userGridView(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Contacts',
        style: ConstantManager.htextStyle.copyWith(
          letterSpacing: 1.5,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        )
      ],
    );
  }

  Widget _userGridView() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 2.0),
      children: List.generate(_users.length, (i) {
        User user = _users[i];
        return UserItem(
          id: user.id,
          username: user.username,
          imgUrl: user.imgUrl == null
              ? user.gender == "Female"
              ? ConstantManager.femaleChefAvatar
              : ConstantManager.maleChefAvatar
              : user.imgUrl,
        );
      }),
    );
  }


}
