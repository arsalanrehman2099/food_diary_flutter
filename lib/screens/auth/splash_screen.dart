import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/screens/auth/login_screen.dart';
import 'package:food_diary/screens/dashboard/dashboard_screen.dart';
import 'package:food_diary/widgets/logo_image.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "";

  @override
  void initState() {
    super.initState();

    getVersionNumber();

    Timer(
      Duration(seconds: 2),
      () => ConstantManager.screenNavWithClear(
        context,
        UserHelper().isLoggedIn() ? DashboardScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: ConstantManager.primaryClr,
      body: SplashBody(),
    );
  }

  Widget SplashBody() {
    return Stack(
      children: [
        SplashLogo(),
        VersionText(),
      ],
    );
  }

  Widget SplashLogo() {
    return Center(
      child: LogoImage(
        h: SizeConfig.safeBlockVertical * 20.0,
        w: SizeConfig.safeBlockVertical * 20.0,
      ),
    );
  }

  Widget VersionText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          'Version ' + version.toString(),
          style: ConstantManager.ktextStyle.copyWith(
            color: Colors.white,
            letterSpacing: 1.0,
            fontSize: SizeConfig.blockSizeHorizontal * 3.5,
          ),
        ),
      ),
    );
  }

  getVersionNumber() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() => version = packageInfo.version);
    });
  }
}
