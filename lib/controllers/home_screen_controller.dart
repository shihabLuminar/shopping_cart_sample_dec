import 'package:flutter/material.dart';
import 'package:shopping_cart_may/models/home_screen_models/categries_res_model.dart';
import 'package:shopping_cart_may/repository/apis/home_screen_service.dart';

class HomeScreenController with ChangeNotifier {
  bool isCategoriesLoading = false;

  List<CategoriesResModel> categoriesList = [];
  // fetch all categories from the API
  Future<void> fetchCategories() async {
    isCategoriesLoading = true;
    notifyListeners();

    try {
      final res = await HomeScreenService().fetchCategories();
      if (res != null) {
        categoriesList = res ?? [];
        isCategoriesLoading = false;
        notifyListeners();
      } else {
        isCategoriesLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isCategoriesLoading = false;
      notifyListeners();
    }
  }
}
