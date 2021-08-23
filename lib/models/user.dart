class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? gender;
  String? imgUrl;
  List? followers;
  List? favorites;

  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.gender,
    this.imgUrl,
    this.followers,
    this.favorites,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'gender': gender,
      'imgUrl': imgUrl,
      'followers': followers,
      'favorites': favorites,
    };
  }

  User fromMap(Map user) {
    return User(
        id: user['id'],
        username: user['username'],
        email: user['email'],
        imgUrl: user['imgUrl'],
        gender: user['gender'],
        followers: user['followers'],
        favorites: user['favorites']);
  }
}
