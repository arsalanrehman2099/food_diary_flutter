import 'dart:math';

import 'package:flutter/material.dart';

import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/models/user.dart';
import 'package:food_diary/screens/auth/register_screen.dart';
import 'package:food_diary/screens/dashboard/dashboard_screen.dart';
import 'package:food_diary/widgets/clip_part_widget.dart';
import 'package:food_diary/widgets/icon_text_field.dart';
import 'package:food_diary/widgets/logo_image.dart';
import 'package:food_diary/widgets/my_button.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _loading = false;

  _submit(context) async {
    if (_email.text == "") {
      ConstantManager.snackBar('Email is required', context);
    } else if (_pass.text == "") {
      ConstantManager.snackBar('Password is required', context);
    } else if (_pass.text.length < 6) {
      ConstantManager.snackBar(
          'Password must be minimum 6 characters', context);
    } else {
      setState(() => _loading = true);
      User user = User(
        email: _email.text,
        password: _pass.text,
      );
      final response = await UserHelper().userLogin(user);
      setState(() => _loading = false);
      if (response['error'] == 1) {
        ConstantManager.snackBar(response['message'], context);
      } else {
        ConstantManager.screenNavWithClear(context, DashboardScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: LoadingOverlay(
        color: ConstantManager.primaryClr,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: ConstantManager.secondaryClr,
          color: ConstantManager.primaryClr,
        ),
        isLoading: _loading,
        child: LoginBody(context),
      ),
    );
  }

  Widget LoginBody(context) {
    return Stack(
      children: [
        wavyBg(),
        SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 6.0,
                  vertical: SizeConfig.blockSizeVertical * 4.0,
                ),
                child: Column(
                  children: [
                    LogoImage(
                      h: SizeConfig.blockSizeVertical * 15.0,
                      w: SizeConfig.blockSizeVertical * 15.0,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 3.5),
                    AuthContainer(),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    ForgotPassword(context),
                    MyButton(text: 'Login', onClick: () => _submit(context)),
                    SizedBox(height: SizeConfig.blockSizeVertical),
                    SignupText(context),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget wavyBg() {
    return ClippedPartsWidget(
      top: Container(
        color: ConstantManager.primaryClr,
      ),
      bottom: Container(
        color: Colors.white,
      ),
      splitFunction: (Size size, double x) {
        // normalizing x to make it exactly one wave
        final normalizedX = x / size.width * 2 * pi;
        final waveHeight = size.height / 15;
        final y = size.height / 2 - sin(normalizedX) * waveHeight;

        return y;
      },
    );
  }

  Widget AuthContainer() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 3.0),
      decoration: ConstantManager.getBoxDecoration(),
      child: Column(
        children: [
          Text(
            'Welcome',
            style: ConstantManager.ktextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeHorizontal * 7.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Please Log in to continue',
            style: ConstantManager.ktextStyle.copyWith(
              fontSize: SizeConfig.blockSizeHorizontal * 3.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          Divider(),
          IconTextField(
            icon: Icons.email,
            hint: 'Email Address',
            inputType: TextInputType.emailAddress,
            controller: _email,
          ),
          Divider(),
          IconTextField(
            icon: Icons.lock,
            hint: 'Password',
            secureText: true,
            controller: _pass,
          ),
        ],
      ),
    );
  }

  Widget ForgotPassword(context) {
    return GestureDetector(
      // onTap: () => screenNavigation(context, ForgotPasswordScreen()),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 2.0,
          horizontal: SizeConfig.blockSizeHorizontal * 3.0,
        ),
        margin:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.2),
        child: Text(
          'Forgot Password ?',
          style: ConstantManager.ktextStyle
              .copyWith(color: ConstantManager.primaryClr),
        ),
      ),
    );
  }

  Widget SignupText(context) {
    return GestureDetector(
      onTap: () => ConstantManager.screenNavigation(context, RegisterScreen()),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 2.0,
          horizontal: SizeConfig.blockSizeHorizontal * 3.0,
        ),
        margin:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.2),
        child: Text(
          'Don\'t have an account ? Signup here',
          style: ConstantManager.ktextStyle.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
