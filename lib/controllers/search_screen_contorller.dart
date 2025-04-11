import 'package:flutter/material.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/apis/search_screen_service.dart';

class SearchScreenContorller with ChangeNotifier {
  bool isSearching = false;
  bool isMoreLoading = false;

  List<Product> productsList = [];
  Future<void> onSearch(
      {required String searchQ, required BuildContext context}) async {
    isSearching = true;
    notifyListeners();
    try {
      final res = await SearchScreenService()
          .onSerach(query: searchQ, skipLength: productsList.length);
      if (res != null) {
        ProductsResModel resModel = res;

// Check if the response is not null and assign the products to the list
        productsList = resModel.products ?? [];

        if (resModel.products!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("No products found"),
            duration: Duration(seconds: 2),
          ));
        }
      }
    } catch (e) {
      isSearching = false;
      notifyListeners();
    }
    isSearching = false;
    notifyListeners();
  }

  Future<void> loadMore(
      {required String searchQ, required BuildContext context}) async {
    isMoreLoading = true;
    notifyListeners();
    try {
      final res = await SearchScreenService()
          .onSerach(query: searchQ, skipLength: productsList.length);
      if (res != null) {
        ProductsResModel resModel = res;
// Check if the response is not null and assign the products to the list

        productsList.addAll(resModel.products ?? []);

        if (resModel.products!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("No more products found"),
            duration: Duration(seconds: 2),
          ));
        }
      }
    } catch (e) {
      isMoreLoading = false;
      notifyListeners();
    }
    isMoreLoading = false;
    notifyListeners();
  }
}
