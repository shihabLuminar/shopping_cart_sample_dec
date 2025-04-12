import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/sqflite_helper/sqflite_helper.dart';

class CartScreenController with ChangeNotifier {
  List<Map> cartItems = [];
  double totalAmount = 0.00;

  Future<void> addData(Product product, BuildContext context) async {
    bool alreadyInCart = cartItems.any(
      (element) => element[AppConfig.productId] == product.id,
    );
    if (alreadyInCart == false) {
      await SqfliteHelper.addNewData(
          image: product.thumbnail ?? "",
          title: product.title.toString(),
          price: product.price,
          productId: product.id);

      getData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Item Already in cart"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> getData() async {
    cartItems = await SqfliteHelper.getAllData();
    calculateTotalAmount();
    notifyListeners();
  }

  Future<void> updateData({required int qty, required int id}) async {
    await SqfliteHelper.updateData(qty: qty, id: id);
    getData();
  }

  void deleteData({required int id}) {
    SqfliteHelper.delteData(id: id);
    getData();
  }

  void deleteAllData() {
    SqfliteHelper.delteAllData();
    getData();
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (var item in cartItems) {
      log(item[AppConfig.itemTitle].toString());

      double curretItemPrice =
          item[AppConfig.itemQty] * item[AppConfig.itemPrice];

      totalAmount = totalAmount + curretItemPrice;
      ;
    }
  }
}


// total = 100 +100+100