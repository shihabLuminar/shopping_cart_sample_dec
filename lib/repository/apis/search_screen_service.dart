import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/api_helper/api_helper.dart';

class SearchScreenService {
  Future<ProductsResModel?> onSerach(
      {required String query, int skipLength = 0}) async {
    String url = "/products/search?q=$query&skip=$skipLength";

    final resBody = await ApiHelper.getData(endpoint: url);

    if (resBody != null) {
      ProductsResModel resModel = productsResModelFromJson(resBody);

      return resModel;
    } else {
      return null;
    }
  }
}
