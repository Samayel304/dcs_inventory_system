import 'dart:math';

import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  static const routeName = '/inventory';
  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['Coffee', 'Milktea', 'Dimsum'];
    List<String> headers = ['ID', 'Product Name', 'Quantity', ''];

    return DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          color: Colors.amber,
                        );
                      });
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
            ),
            bottomNavigationBar: const BottomNavBar(index: 1),
            body: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const _SearchBar(),
                  _Category(tabs: tabs),
                  Expanded(
                    child: _Table(
                      headers: headers,
                      products: Product.products,
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: const _FloatingActionButton()));
  }
}

class _Table extends StatelessWidget {
  const _Table({
    Key? key,
    required this.headers,
    required this.products,
  }) : super(key: key);

  final List<String> headers;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: headers
                .map(
                  (header) => header == "Product Name"
                      ? Expanded(flex: 3, child: Text(header))
                      : Expanded(child: Text(header)),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xEEEBE6E6),
                ),
                child: Row(children: [
                  Expanded(child: _ListText(text: products[index].productId)),
                  Expanded(
                      flex: 3,
                      child: _ListText(text: products[index].productName)),
                  Expanded(
                      child:
                          _ListText(text: products[index].quantity.toString())),
                  Expanded(
                      child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 0) {
                              showBottomModal(context, const _AddProduct());
                            }
                          },
                          icon: const Icon(Icons.more_horiz),
                          itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 0,
                                  child: Text("Edit"),
                                ),
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text("Deduct"),
                                )
                              ])),
                ]),
              );
            },
          ),
        )
      ],
    );
  }
}

class _ListText extends StatelessWidget {
  const _ListText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline3);
  }
}

Future<dynamic> showBottomModal(BuildContext context, Widget child) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return child;
      });
}

class _AddProduct extends StatelessWidget {
  const _AddProduct({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Product"),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Product Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Product Price",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {},
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.black,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          label: "Export",
          onTap: () => {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: "Add",
          onTap: () => {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    color: Colors.amber,
                  );
                })
          },
        )
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search',
        fillColor: Colors.grey.shade200,
        filled: true,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
