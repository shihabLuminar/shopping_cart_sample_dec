import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controllers/home_screen_controller.dart';
import 'package:shopping_cart_may/controllers/porducty_details_screen_contorller.dart';
import 'package:shopping_cart_may/controllers/search_screen_contorller.dart';
import 'package:shopping_cart_may/view/get_started_screen/get_started_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenController()),
        ChangeNotifierProvider(create: (context) => SearchScreenContorller()),
        ChangeNotifierProvider(
            create: (context) => ProductDetailsScreencontroller())
      ],
      child: MaterialApp(
        home: GetStartedScreen(),
      ),
    );
  }
}
