import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String? id;
  String? user_id;
  String? name;
  String? category;
  int? likes;
  int? dislikes;
  String? imgUrl;
  String? method;
  Map? ingredients;
  Timestamp? timestamp;

  Recipe({
    this.id,
    this.user_id,
    this.name,
    this.category,
    this.likes,
    this.dislikes,
    this.imgUrl,
    this.method,
    this.ingredients,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'user_id': user_id,
      'name': name,
      'category': category,
      'imgUrl': imgUrl,
      'likes': likes,
      'dislikes': dislikes,
      'method': method,
      'ingredients': ingredients,
      'timestamp': timestamp,
    };
  }

  Recipe fromMap(Map recipe){
    return Recipe(
      id:recipe['id'],
      user_id:recipe['user_id'],
      name:recipe['name'],
      category:recipe['category'],
      imgUrl:recipe['imgUrl'],
      likes:recipe['likes'],
      dislikes:recipe['dislikes'],
      method:recipe['method'],
      ingredients:recipe['ingredients'],
      timestamp:recipe['timestamp'],
    );
  }
}
