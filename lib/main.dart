import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/screens/auth/splash_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Diary',
      theme: ThemeData(
        primaryColor: ConstantManager.primaryClr,
        accentColor: ConstantManager.secondaryClr,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
