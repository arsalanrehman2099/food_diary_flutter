import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_diary/models/user.dart';
import 'package:food_diary/screens/auth/login_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';

class UserHelper {
  static const collectionName = 'Users';

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String myId() => _auth.currentUser!.uid.toString();

  bool isLoggedIn() {
    if (_auth.currentUser == null)
      return false;
    else
      return true;
  }

  userSignup(User? user) async {
    var response = {};
    await _auth
        .createUserWithEmailAndPassword(
            email: user!.email!, password: user.password!)
        .then((value) {
      response['error'] = 0;
      user.id = _auth.currentUser?.uid.toString();

      _firestore.collection(collectionName).doc(user.id).set(user.toMap());
    }).catchError(
      (err) {
        response['error'] = 1;
        response['message'] = err.toString();
      },
    );

    return response;
  }

  userLogin(User? user) async {
    var response = {};
    await _auth
        .signInWithEmailAndPassword(
            email: user!.email!, password: user.password!)
        .then((value) {
      response['error'] = 0;
    }).catchError((err) {
      response['error'] = 1;
      response['message'] = err.toString();
    });
    return response;
  }

  userLogout(context) {
    _auth.signOut();
    ConstantManager.screenNavWithClear(
      context,
      LoginScreen(),
    );
  }

  getUserInfo(id) async {
    var response = {};
    await _firestore.collection(collectionName).doc(id).get().then((event) {
      response['error'] = 0;
      response['data'] = event.data();
    }).catchError((err) {
      response['error'] = 1;
      response['message'] = err.toString();
    });
    return response;
  }

  updateUser(data) async {
    var response = {};
    await _firestore
        .collection(collectionName)
        .doc(myId())
        .update(data)
        .then((value) {
      response['error'] = 0;
    }).catchError((err) {
      response['error'] = 1;
      response['message'] = err.toString();
    });
    return response;
  }

  updateUserImage(image) async {
    var response = {};

    await _storage
        .ref()
        .child("profile_images/" + myId())
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

  listOfUsers() async {
    var response = {};
    List<User> userData = [];

    await _firestore
        .collection(collectionName)
        .where('id', isNotEqualTo: myId())
        .get()
        .then((value) {
      response['error'] = 0;

      for (int i = 0; i < value.docs.length; i++) {
        User user = User().fromMap(value.docs[i].data());
        userData.add(user);
      }
      response['data'] = userData;
    }).catchError((err) {
      response['error'] = 1;
      response['error_message'] = err.toString();
    });
    return response;
  }

 checkFollowing(userId) async{
    bool? value;

    await _firestore
        .collection(collectionName)
        .doc(myId())
        .get()
        .then((event) {
      List followers = event.data()?['followers'] ?? [];

      if (followers == []) {
        value = false;
      } else {
        if (followers.contains(userId)) {
          value = true;
        } else {
          value = false;
        }
      }
    });
    return value;
  }

  follow(user_id) {
    _firestore.collection(collectionName).doc(myId()).update({
      'followers': FieldValue.arrayUnion([user_id])
    });
  }

  unfollow(user_id) {
    _firestore.collection(collectionName).doc(myId()).update({
      'followers': FieldValue.arrayRemove([user_id])
    });
  }
}
