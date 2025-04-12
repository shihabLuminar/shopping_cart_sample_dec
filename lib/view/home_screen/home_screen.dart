import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controllers/cart_screen_controller.dart';
import 'package:shopping_cart_may/controllers/home_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/cart_screen.dart';
import 'package:shopping_cart_may/view/product_details_screen/product_details_screen.dart';
import 'package:shopping_cart_may/view/search_screen/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<HomeScreenController>().fetchCategories();
        await context.read<HomeScreenController>().fetchProducts();
        await context.read<CartScreenController>().getData();
      },
    );
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedIndex(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final categoryWidth = screenWidth /
        3; // Adjust this width based on the item width (container + padding)
    final targetOffset =
        (index * categoryWidth) - (screenWidth / 2) + (categoryWidth / 2);

    _scrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenController = context.watch<HomeScreenController>();
    final homeScreenProvider = context.read<HomeScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ));
              },
              icon: Icon(Icons.shopping_bag)),
          Stack(
            children: [
              Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 40,
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.black,
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: homeScreenController.isCategoriesLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // #1
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(.2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Search anything",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(
                        homeScreenController.categoriesList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              homeScreenProvider.onCategorySelection(index);
                              _scrollToSelectedIndex(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: homeScreenController
                                              .selectedCaegoryIndex ==
                                          index
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                homeScreenController.categoriesList[index].name
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: homeScreenController
                                              .selectedCaegoryIndex ==
                                          index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: homeScreenController.isProductsLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          )
                        : GridView.builder(
                            itemCount: homeScreenController.productsList.length,
                            padding: EdgeInsets.all(20),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              mainAxisExtent: 250,
                            ),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                        productId: homeScreenController
                                            .productsList[index].id
                                            .toString(),
                                      ),
                                    ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.2),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              homeScreenController
                                                  .productsList[index].thumbnail
                                                  .toString(),
                                            ))),
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.7),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(
                                        Icons.favorite_outline,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    maxLines: 1,
                                    homeScreenController
                                        .productsList[index].title
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    homeScreenController
                                        .productsList[index].price
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                          ))
              ],
            ),
    );
  }
}
