import 'package:flutter/material.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/models/user.dart';
import 'package:food_diary/screens/dashboard/dashboard_screen.dart';
import 'package:food_diary/widgets/header_logo.dart';
import 'package:food_diary/widgets/my_button.dart';
import 'package:food_diary/widgets/my_text_field.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _selectedGender;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _cfmPass = TextEditingController();

  bool _loading = false;

  _submitForm() async {
    if (_name.text == "") {
      ConstantManager.snackBar('Name is required', context);
    } else if (_email.text == "") {
      ConstantManager.snackBar('Email is required', context);
    } else if (_pass.text == "") {
      ConstantManager.snackBar('Password is required', context);
    } else if (_pass.text.length < 6) {
      ConstantManager.snackBar(
          'Password must be minimum 6 characters', context);
    } else if (_cfmPass.text == "") {
      ConstantManager.snackBar('Confirm password is required', context);
    } else if (_pass.text != _cfmPass.text) {
      ConstantManager.snackBar('Password Does not match', context);
    } else if (_selectedGender == "" || _selectedGender == null) {
      ConstantManager.snackBar('Gender is required', context);
    } else {
      setState(() => _loading = true);
      User user = User(
        username: _name.text,
        email: _email.text,
        password: _pass.text,
        gender: _selectedGender,
      );

      final response = await UserHelper().userSignup(user);
      setState(() => _loading = false);
      if (response['error'] == 1) {
        ConstantManager.snackBar(response['message'], context);
      } else {
        ConstantManager.snackBar('Registration Successful', context);
        ConstantManager.screenNavWithClear(context, DashboardScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantManager.primaryClr,
      body: LoadingOverlay(
        color: ConstantManager.primaryClr,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: ConstantManager.secondaryClr,
          color: ConstantManager.primaryClr,
        ),
        isLoading: _loading,
        child: RegisterForm(),
      ),
    );
  }

  Widget RegisterForm() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            BackButton(color: Colors.white),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 5.0,
                horizontal: SizeConfig.blockSizeHorizontal * 4.5,
              ),
              child: Column(
                children: [
                  HeaderLogo(text: 'Sign up', color: 'white'),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3.5),
                  MyTextField(hint: 'Username', controller: _name),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.2),
                  MyTextField(
                    hint: 'Email',
                    controller: _email,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.2),
                  MyTextField(
                      hint: 'Password', hideText: true, controller: _pass),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.2),
                  MyTextField(
                      hint: 'Confirm Password',
                      hideText: true,
                      controller: _cfmPass),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.2),
                  GenderRadioList(),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3.0),
                  MyButton(text: 'Register', onClick: _submitForm)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget GenderRadioList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: ConstantManager.ktextStyle.copyWith(
            color: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [RadioButton('Male'), RadioButton('Female')],
        ),
      ],
    );
  }

  Widget RadioButton(text) {
    return Flexible(
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: text,
              groupValue: _selectedGender,
              onChanged: (String? value) =>
                  setState(() => _selectedGender = value),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal),
            Text(
              text.toString(),
              style: ConstantManager.ktextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
