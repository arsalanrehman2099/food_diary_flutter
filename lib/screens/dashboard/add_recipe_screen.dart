import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/image_picker.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/firebase/recipe_helper.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/models/recipe.dart';
import 'package:food_diary/widgets/back_button.dart';
import 'package:food_diary/widgets/header_logo.dart';
import 'package:food_diary/widgets/method_text_field.dart';
import 'package:food_diary/widgets/my_button.dart';
import 'package:food_diary/widgets/white_text_field.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddRecipePostScreen extends StatefulWidget {
  @override
  _AddRecipePostScreenState createState() => _AddRecipePostScreenState();
}

class _AddRecipePostScreenState extends State<AddRecipePostScreen> {
  int _ingredientCount = 1;
  bool _loading = false;

  List categories = [
    'Arabic',
    'Pakistani',
    'Italian',
    'Beverages',
    'Desserts',
    'Soups',
    'Salads'
  ];
  String? _selectedCategory;

  final _name = TextEditingController();
  final _method = TextEditingController();

  List<TextEditingController> _ingredientList = [];
  List<TextEditingController> _qtyList = [];

  String _imageUploadText = 'Upload an image';
  MyImagePicker _imagePicker = MyImagePicker();

  @override
  void initState() {
    _ingredientList.add(new TextEditingController());
    _qtyList.add(new TextEditingController());
  }

  _submitRecipe() async {
    if (_name.text == "") {
      ConstantManager.snackBar('Name is required', context);
    } else if (_selectedCategory == "") {
      ConstantManager.snackBar('Category is required', context);
    } else if (_ingredientList[0].text == "" || _qtyList[0].text == "") {
      ConstantManager.snackBar('No ingredient found', context);
    } else if (_method.text == "") {
      ConstantManager.snackBar('Method is required', context);
    } else if (_imagePicker.image == null) {
      ConstantManager.snackBar('Image is required', context);
    } else {
      setState(() => _loading = true);

      //  Create Model Class
      Recipe recipe = Recipe(
        id: ConstantManager.generateRandomString(25),
        name: _name.text,
        method: _method.text,
        likes: 0,
        dislikes: 0,
        user_id: UserHelper().myId(),
        category: _selectedCategory,
        timestamp: Timestamp.now(),
      );

      //  Convert ingredient+quantity list to Map
      var ingredients = {};
      for (int i = 0; i < _ingredientList.length; i++) {
        ingredients[_ingredientList[i].text] = _qtyList[i].text;
      }
      recipe.ingredients = ingredients;

      //  Upload Image
      final imageResponse =
          await RecipeHelper().uploadImage(_imagePicker.image);
      if (imageResponse['error'] == 1) {
        ConstantManager.snackBar(
            'Image Upload Error : ' + imageResponse['error_message'], context);
        setState(() => _loading = false);
        return;
      } else {
        setState(() => _imageUploadText = "Image has been selected");
        recipe.imgUrl = imageResponse['url'];
      }

      //  Add to db
      final response = await RecipeHelper().insertRecipe(recipe);
      setState(() => _loading = false);

      if (response['error'] == 1) {
        ConstantManager.snackBar(response['message'], context);
      } else {
        ConstantManager.snackBar('Recipe Added.', context);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        color: ConstantManager.primaryClr,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: ConstantManager.secondaryClr,
          color: ConstantManager.primaryClr,
        ),
        isLoading: _loading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                BackButton(color: Colors.black),
                RecipeForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RecipeForm() {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 6.0,
          horizontal: SizeConfig.blockSizeHorizontal * 3.2,
        ),
        child: Column(
          children: [
            HeaderLogo(text: 'Share', color: 'black'),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Divider(),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            WhiteTextField(
              hint: 'Recipe Name',
              controller: _name,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            CategoryDropdown(),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            IngredientListView(),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            IngredientCounter(),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            MethodTextField(
              hint: 'Method',
              controller: _method,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
            UploadImage(),
            SizedBox(height: SizeConfig.blockSizeVertical * 3.0),
            MyButton(text: 'Share', onClick: _submitRecipe),
          ],
        ),
      ),
    );
  }

  Widget CategoryDropdown() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Category',
            style: ConstantManager.ktextStyle
                .copyWith(color: ConstantManager.primaryClr.withOpacity(0.9)),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2.0),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              // labelText: label,
              fillColor: Colors.grey.withOpacity(0.2),
              labelStyle: ConstantManager.ktextStyle
                  .copyWith(color: ConstantManager.primaryClr.withOpacity(0.8)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            items: categories.map<DropdownMenuItem<Object>>((item) {
              return new DropdownMenuItem(
                child: new Text(
                  item,
                  style:
                      ConstantManager.ktextStyle.copyWith(color: Colors.black),
                ),
                value: item.toString(),
              );
            }).toList(),
            onChanged: (newVal) {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() => _selectedCategory = newVal.toString());
            },
          ),
        )
      ],
    );
  }

  Widget IngredientListView() {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemCount: _ingredientCount,
      separatorBuilder: (ctx, i) =>
          SizedBox(height: SizeConfig.blockSizeVertical * 2.0),
      itemBuilder: (ctx, i) {
        return IngredientItem(_ingredientList[i], _qtyList[i]);
      },
    );
  }

  Widget IngredientItem(ingredientCtrl, qtyCtrl) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: WhiteTextField(
            hint: 'Ingredient',
            controller: ingredientCtrl,
          ),
        ),
        SizedBox(width: SizeConfig.blockSizeVertical * 1.5),
        Expanded(
          flex: 4,
          child: WhiteTextField(
            hint: 'Quantity',
            controller: qtyCtrl,
          ),
        ),
      ],
    );
  }

  Widget IngredientCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CounterButton(
          icon: Icons.remove,
          onClick: () => setState(() {
            if (_ingredientCount != 1) {
              _ingredientCount--;
              _ingredientList.removeLast();
              _qtyList.removeLast();
            }
          }),
        ),
        SizedBox(width: 10.0),
        CounterButton(
          icon: Icons.add,
          onClick: () => setState(() {
            _ingredientCount++;
            _ingredientList.add(new TextEditingController());
            _qtyList.add(new TextEditingController());
          }),
        ),
      ],
    );
  }

  Widget CounterButton({onClick, icon}) {
    return GestureDetector(
      onTap: onClick,
      child: CircleAvatar(
        backgroundColor: ConstantManager.secondaryClr,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget UploadImage() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _imagePicker.showImageDialog(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical),
        child: Row(
          children: [
            Icon(Icons.add, color: ConstantManager.secondaryClr),
            SizedBox(width: 10.0),
            Text(
              _imageUploadText,
              style: ConstantManager.ktextStyle
                  .copyWith(color: ConstantManager.secondaryClr),
            )
          ],
        ),
      ),
    );
  }
}
