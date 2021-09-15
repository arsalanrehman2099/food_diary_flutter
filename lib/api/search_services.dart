import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchServices {
  static const BASE_URL = "https://food-diary-fyp.herokuapp.com";

  static const INGREDIENT_ENDPOINT = "/ingredient";
  static const SEARCH_ENDPOINT = "/recipe-by-ingredient";
  static const SINGLE_SEARCH_ENDPOINT = "/recipe-by-single-ingredient";

  fetchIngredients() async {
    var url = Uri.parse(BASE_URL + INGREDIENT_ENDPOINT);
    return await http.get(url);
  }

  fetchRecipes(selectedIngredients) async {
    var url = Uri.parse(BASE_URL + SINGLE_SEARCH_ENDPOINT);
    return await http.post(
        url, headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({"ingredients":selectedIngredients}));
  }
}