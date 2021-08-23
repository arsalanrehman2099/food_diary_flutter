import 'package:flutter/material.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/image_picker.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/white_text_field.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SettingScreen extends StatefulWidget {
  final userData;

  SettingScreen(this.userData);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();

  bool _loading = false;

  MyImagePicker _imagePicker = MyImagePicker();

  @override
  void initState() {
    super.initState();
    _username.text = widget.userData['username'];
    _email.text = widget.userData['email'];
  }

  _update() {
    if (_username.text == "") {
      ConstantManager.snackBar('Username is required', context);
    } else {
      setState(() => _loading = true);

      if (_imagePicker.image == null) {
        _updateUserInfo({'username': _username.text});
      } else {
        _updateUserImage();
      }
    }
  }

  _updateUserInfo(data) async {
    final response =
        await UserHelper().updateUser(data);
    setState(() => _loading = false);
    if (response['error'] == 1) {
      ConstantManager.snackBar(response['message'], context);
    } else {
      ConstantManager.snackBar('Profile Updated', context);
    }
  }

  _updateUserImage() async {
    final imageResponse =
        await UserHelper().updateUserImage(_imagePicker.image);

    if (imageResponse['error'] == 1) {
      ConstantManager.snackBar(
          'Image Upload Error : ' + imageResponse['error_message'], context);
      setState(() => _loading = false);
    } else {
      var data = {
        'username': _username.text,
        'imgUrl': imageResponse['url'],
      };
      _updateUserInfo(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: ConstantManager.ktextStyle,
        ),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        color: ConstantManager.primaryClr,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: ConstantManager.secondaryClr,
          color: ConstantManager.primaryClr,
        ),
        isLoading: _loading,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 4.0,
              horizontal: SizeConfig.blockSizeHorizontal * 3.0,
            ),
            child: Center(
              child: Column(
                children: [
                  ProfileImage(),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
                  WhiteTextField(
                    hint: 'Username',
                    controller: _username,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
                  WhiteTextField(
                    hint: 'Email',
                    controller: _email,
                    enable: false,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ConstantManager.primaryClr)),
                        onPressed: _update,
                        child: Text(
                          'Update',
                          style: ConstantManager.ktextStyle,
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3.0),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () => UserHelper().userLogout(context),
                        child: Text(
                          'Logout',
                          style: ConstantManager.ktextStyle,
                        ),
                      ),
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

  Widget ProfileImage() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        _imagePicker.showImageDialog(context);
      },
      child: Stack(
        children: [
          _imagePicker.image != null
              ? CircleAvatar(
                  backgroundColor: ConstantManager.secondaryClr,
                  radius: SizeConfig.blockSizeVertical * 12.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    radius: SizeConfig.blockSizeVertical * 11.5,
                    backgroundImage: FileImage(
                      _imagePicker.image,
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: ConstantManager.secondaryClr,
                  radius: SizeConfig.blockSizeVertical * 12.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    radius: SizeConfig.blockSizeVertical * 11.5,
                    backgroundImage: widget.userData['imgUrl'] == null
                        ? NetworkImage(widget.userData['gender'] == "Female"
                            ? ConstantManager.femaleChefAvatar
                            : ConstantManager.maleChefAvatar)
                        : NetworkImage(widget.userData['imgUrl']),
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
}
