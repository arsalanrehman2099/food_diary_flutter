import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_diary/api/search_services.dart';
import 'package:food_diary/screens/search/ingredient_list.dart';
import 'package:food_diary/screens/search/search_recipe_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:food_diary/widgets/header_logo.dart';
import 'package:food_diary/widgets/my_button.dart';
import 'package:food_diary/widgets/white_text_field.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List _ingredients = [];
  List<bool>? _isChecked;

  List _selectedIngredients = [];

  final _scrollCtrl = ScrollController();

  bool _loading = true;

  final _searchTextCtrl = TextEditingController();
  var search = "";

  int currentIngredientLength = 10;
  int totalIngredients = IngredientList.INGREDIENTS.length;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(IngredientList.INGREDIENTS.length, false);
    // fetchIngredients();
  }

  fetchIngredients() async {
    final response = await SearchServices().fetchIngredients();
    final jsonResponse = jsonDecode(response.body);
    setState(() => _loading = false);

    if (jsonResponse['error'] == 0) {
      setState(() {
        _ingredients = jsonResponse['ingredients'];
        _isChecked = List<bool>.filled(_ingredients.length, false);
      });
    } else {
      ConstantManager.showtoast('Network Error. Please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(currentIngredientLength);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _searchTextField(),
            _ingredientListView(),
          ],
        ),
      ),
    );
  }

  Widget _submit() {
    return Stack(
      children: [
        ElevatedButton(
          onPressed: () {
            ConstantManager.screenNavigation(
              context,
              SearchRecipeScreen(_selectedIngredients),
            );
          },
          child: Text('Next'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              ConstantManager.secondaryClr,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: ConstantManager.primaryClr,
            child: Text(
              _selectedIngredients.length.toString(),
              style: ConstantManager.ktextStyle.copyWith(
                fontSize: SizeConfig.blockSizeHorizontal * 2.8,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 4.0,
        left: SizeConfig.blockSizeHorizontal * 4.0,
        right: SizeConfig.blockSizeHorizontal * 4.0,
      ),
      child: Stack(
        children: [
          _selectedIngredients.length != 0 ? _submit() : Container(),
          Column(
            children: [
              HeaderLogo(text: 'Search', color: 'black'),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.0,
                ),
                child: Divider(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical,
        horizontal: SizeConfig.blockSizeHorizontal * 4.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2.0),
        child: TextField(
          controller: _searchTextCtrl,
          onChanged: (val) {
            setState(() {
              search = val;
            });
          },
          decoration: new InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _ingredientListView() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.atEdge) {
          if (notification.metrics.pixels == 0) {
            print('At top');
          } else {
            print('At bottom');
            setState(() {
              currentIngredientLength = currentIngredientLength + 10;
            });
          }
        }
        return true;
      },
      child: Expanded(
        child: ListView.separated(
          controller: _scrollCtrl,
          itemCount: search == ""? currentIngredientLength : IngredientList.INGREDIENTS.length,
          separatorBuilder: (context, i) {
            if (IngredientList.INGREDIENTS[i]
                .toLowerCase()
                .contains(search.toLowerCase()))
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4.0,
                ),
                child: Divider(),
              );
            else
              return Container();
          },
          itemBuilder: (ctx, index) {
            if (IngredientList.INGREDIENTS[index]
                .toLowerCase()
                .contains(search.toLowerCase()))
              return Theme(
                data: ThemeData(
                  unselectedWidgetColor: ConstantManager.primaryClr,
                ),
                child: CheckboxListTile(
                  activeColor: ConstantManager.secondaryClr,
                  value: _isChecked?[index],
                  title: Text(
                    IngredientList.INGREDIENTS[index].capitalize(),
                    style: ConstantManager.ktextStyle,
                  ),
                  onChanged: (val) {
                    if (val!)
                      _selectedIngredients.add(IngredientList.INGREDIENTS[index]);
                    else
                      _selectedIngredients
                          .remove(IngredientList.INGREDIENTS[index]);
                    setState(() => _isChecked?[index] = val);
                  },
                ),
              );
            else
              return Container();
          },
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
