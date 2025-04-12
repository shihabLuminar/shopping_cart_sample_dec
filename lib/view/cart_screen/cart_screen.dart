import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/controllers/cart_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';
import 'package:shopping_cart_may/view/home_screen/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<CartScreenController>().getData();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartScreenController = context.watch<CartScreenController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          title: cartScreenController.cartItems[index]
                              [AppConfig.itemTitle],
                          desc: cartScreenController.cartItems[index]
                                  [AppConfig.itemPrice]
                              .toString(),
                          qty: cartScreenController.cartItems[index]
                                  [AppConfig.itemQty]
                              .toString(),
                          image: cartScreenController.cartItems[index]
                              [AppConfig.itemImage],
                          onIncrement: () {
                            int qty = cartScreenController.cartItems[index]
                                [AppConfig.itemQty];
                            int id = cartScreenController.cartItems[index]
                                [AppConfig.primaryKey];

                            qty++;
                            context
                                .read<CartScreenController>()
                                .updateData(qty: qty, id: id);
                          },
                          onDecrement: () {
                            int qty = cartScreenController.cartItems[index]
                                [AppConfig.itemQty];
                            int id = cartScreenController.cartItems[index]
                                [AppConfig.primaryKey];

                            if (qty >= 2) {
                              qty--;
                              context
                                  .read<CartScreenController>()
                                  .updateData(qty: qty, id: id);
                            }
                          },
                          onRemove: () {
                            context.read<CartScreenController>().deleteData(
                                  id: cartScreenController.cartItems[index]
                                      [AppConfig.primaryKey],
                                );
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: cartScreenController.cartItems.length),
                ),
                InkWell(
                  onTap: () {
                    Razorpay razorpay = Razorpay();
                    var options = {
                      'key': 'rzp_test_1DP5mmOlF5G5ag',
                      'amount': cartScreenController.totalAmount * 100,
                      'name': 'Luminar technolab',
                      'description': 'Fine T-Shirt',
                      'timeout': 300, // timeout in seconds (5 minutes)
                      'retry': {
                        'enabled': true,
                        'max_count': 1,
                      },
                      'send_sms_hash': true,
                      'prefill': {
                        'contact': '8888888888',
                        'email': 'test@razorpay.com'
                      },
                      'theme': {
                        'color':
                            '#F37254' // Replace with your desired hex color
                      },
                      'external': {
                        'wallets': ['paytm']
                      }
                    };
                    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                        handlePaymentErrorResponse);
                    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                        handlePaymentSuccessResponse);
                    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                        handleExternalWalletSelected);
                    razorpay.open(options);
                  },
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(4, 6),
                              color: Colors.black26,
                              blurRadius: 15)
                        ],
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "${cartScreenController.totalAmount.toStringAsFixed(2)} rs",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 50,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false,
    );

    context.read<CartScreenController>().deleteAllData();

    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
