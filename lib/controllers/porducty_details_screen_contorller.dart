import 'package:flutter/material.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/apis/product_details_screen_service.dart';

class ProductDetailsScreencontroller with ChangeNotifier {
  bool isLoading = false;
  Product? productDetails;

  Future<void> fetchProductdetails({required String productId}) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ProductDetailsScreenService()
          .fetchProductDetails(id: productId);
      if (res != null) {
        productDetails = res;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
    }
    isLoading = false;
    notifyListeners();
  }
}
