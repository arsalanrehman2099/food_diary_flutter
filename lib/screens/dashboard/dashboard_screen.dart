import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/screens/dashboard/favourites_screen.dart';
import 'package:food_diary/screens/dashboard/home_screen.dart';
import 'package:food_diary/screens/dashboard/profile_screen.dart';
import 'package:food_diary/screens/dashboard/search_screen.dart';

import 'add_recipe_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var _bottomNavIndex = 0;

  Animation<double>? animation;
  CurvedAnimation? curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.favorite,
    Icons.account_circle,
  ];

  var screens = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ]; //screens for each tab

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () =>
            ConstantManager.screenNavigation(context, AddRecipePostScreen()),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Colors.white,
        splashColor: Colors.white,
        inactiveColor: Colors.white,
        icons: iconList,
        backgroundColor: ConstantManager.primaryClr,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
      body: screens[_bottomNavIndex],
    );
  }
}
