import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'constant_manager.dart';

enum IMAGE_PICKER_OPTION {
  CAMERA,
  GALLERY,
}

class MyImagePicker {
   File? _image;
   final _picker = ImagePicker();
   var _selected;


   dynamic get image => _image == null? null: _image;

   showImageDialog(context) {
    SizeConfig().init(context);

    Widget dialogItem({icon, text, onClick}) {
      return InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FaIcon(icon),
              SizedBox(height: SizeConfig.blockSizeVertical),
              Text(text, style: ConstantManager.ktextStyle),
            ],
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (_) => new Dialog(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Upload Image',
                  textAlign: TextAlign.center,
                  style: ConstantManager.ktextStyle.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.2),
                Text(
                  'Please select from the following options',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    dialogItem(
                        icon: FontAwesomeIcons.camera,
                        text: 'Camera',
                        onClick: () {
                          _selected = IMAGE_PICKER_OPTION.CAMERA;
                          _getImage(context);
                        }),
                    dialogItem(
                      icon: FontAwesomeIcons.images,
                      text: 'Gallery',
                      onClick: () {
                        _selected = IMAGE_PICKER_OPTION.GALLERY;
                        _getImage(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

    _getImage(context) async {
    final pickedFile = await _picker.getImage(
      source: _selected == IMAGE_PICKER_OPTION.GALLERY
          ? ImageSource.gallery
          : ImageSource.camera,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      ConstantManager.showtoast('Image selected');
      Navigator.pop(context);
    } else {
      ConstantManager.showtoast('No image selected.');
    }
  }
}
