import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/models/recipe.dart';
import 'package:food_diary/utils/constant_manager.dart';

class RecipeHelper {
  static const collectionName = 'Recipes';

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  insertRecipe(Recipe recipe) async {
    var response = {};

    await _firestore
        .collection(collectionName)
        .doc(recipe.id)
        .set(recipe.toMap())
        .then((value) {
      response['error'] = 0;
    }).catchError((err) {
      response['error'] = 1;
      response['message'] = err.toString();
    });
    return await response;
  }

  uploadImage(image) async {
    var response = {};

    await _storage
        .ref()
        .child("recipes/" + ConstantManager.generateRandomString(30))
        .putFile(image)
        .then((snap) async {
      response['error'] = 0;
      response['url'] = await snap.ref.getDownloadURL();
    }).catchError((err) {
      response['error'] = 1;
      response['error_message'] = err.toString();
    });

    return response;
  }

  getRecipesWithUser() async {
    var response = {};
    var data = [];

    await _firestore.collection(collectionName).get().then((value) async {
      for (var i = 0; i < value.docs.length; i++) {
        await _firestore
            .collection(UserHelper.collectionName)
            .doc(value.docs[i].data()['user_id'])
            .get()
            .then((user) {
          var item = {'user': user.data(), 'recipe': value.docs[i].data()};
          data.add(item);
        });
      }
      response['response'] = data;
      response['error'] = 0;
    }).catchError((err) {
      response['error'] = 1;
      response['error_message'] = err.toString();
    });

    return response;
  }

  getUserRecipes(id) async {
    var response = {};
    await _firestore
        .collection(collectionName)
        .where('user_id', isEqualTo: id)
        .get()
        .then((value) {
      response['error'] = 0;
      response['data'] = value.docs;
    }).catchError((err) {
      response['error'] = 1;
      response['error_message'] = err.toString();
    });
    return response;
  }

  getFavorite() async {
    var recipes = [];

    await _firestore
        .collection(UserHelper.collectionName)
        .doc(UserHelper().myId())
        .get()
        .then((event) async {
      List favorites = event.data()?['favorites'] ?? [];

      for (int i = 0; i < favorites.length; i++) {
        var data = {};
        await _firestore
            .collection(collectionName)
            .doc(favorites[i])
            .get()
            .then((recipe) async{
          data['recipe'] = recipe.data();

          await _firestore
              .collection(UserHelper.collectionName)
              .doc(recipe.data()?['user_id'])
              .get()
              .then((user) {
            data['user'] = user.data();
            recipes.add(data);
          });
        });
      }
    });

    return recipes;
  }

  isFavorite(recipeId) async {
    bool? value;

    await _firestore
        .collection(UserHelper.collectionName)
        .doc(UserHelper().myId())
        .get()
        .then((event) {
      List favorites = event.data()?['favorites'] ?? [];

      if (favorites == [])
        value = false;
      else {
        if (favorites.contains(recipeId))
          value = true;
        else
          value = false;
      }
    });
    return value;
  }

  addFavorite(recipeId) {
    _firestore
        .collection(UserHelper.collectionName)
        .doc(UserHelper().myId())
        .update({
      'favorites': FieldValue.arrayUnion([recipeId])
    });
  }

  removeFavorite(recipeId) {
    _firestore
        .collection(UserHelper.collectionName)
        .doc(UserHelper().myId())
        .update({
      'favorites': FieldValue.arrayRemove([recipeId])
    });
  }
}
