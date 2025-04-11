import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controllers/search_screen_contorller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController controller = ScrollController();
  TextEditingController searchQuery = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.addListener(
          () {
            final searchScreenController =
                context.read<SearchScreenContorller>();

            if (controller.position.pixels ==
                    controller.position.maxScrollExtent &&
                searchScreenController.isMoreLoading == false) {
              searchScreenController.loadMore(
                  searchQ: searchQuery.text.trim(), context: context);
            }
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchScreenController = context.watch<SearchScreenContorller>();
    final searchScreenprovider = context.read<SearchScreenContorller>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Search"),
              onChanged: (value) {
                ScaffoldMessenger.of(context).clearSnackBars();
                searchScreenprovider.onSearch(searchQ: value, context: context);
              },
            ),
            Expanded(
                child: searchScreenController.isSearching
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        controller: controller,
                        itemBuilder: (context, index) => ListTile(
                              leading: Image.network(
                                  width: 80,
                                  height: 80,
                                  searchScreenController
                                      .productsList[index].thumbnail
                                      .toString()),
                              title: Text(searchScreenController
                                  .productsList[index].title
                                  .toString()),
                              subtitle: Text("Price"),
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: searchScreenController.productsList.length)),
            if (searchScreenController.isMoreLoading)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
