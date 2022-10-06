import 'package:dcs_inventory_system/models/header_model.dart';
import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/modal_child/add_product.dart';
import 'package:dcs_inventory_system/views/widgets/modal_child/deduct_quantity.dart';
import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../widgets/modal_child/edit_product.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  static const routeName = '/inventory';

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int defaultQuantity = 0;

  TextEditingController productNameAddController = TextEditingController();
  TextEditingController productPriceAddController = TextEditingController();

  TextEditingController productNameEditController = TextEditingController();
  TextEditingController productPriceEditController = TextEditingController();

  TextEditingController productQuantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    InventoryViewModel inventoryViewModel = context.watch<InventoryViewModel>();

    List<String> tabs = ['Coffee', 'Milktea', 'Dimsum'];
    List<Widget> tabBarView = [
      SizedBox(
        child: _Table(
          productNameEditController: productNameEditController,
          productPriceEditController: productPriceEditController,
          headers: Header.headers,
          products: Product.coffee,
        ),
      ),
      SizedBox(
        child: _Table(
          productNameEditController: productNameEditController,
          productPriceEditController: productPriceEditController,
          headers: Header.headers,
          products: Product.milktea,
        ),
      ),
      SizedBox(
        child: _Table(
          productNameEditController: productNameEditController,
          productPriceEditController: productPriceEditController,
          headers: Header.headers,
          products: Product.dimsum,
        ),
      ),
    ];

    return DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {},
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
                    child: SizedBox(
                      child: TabBarView(
                          children: tabBarView.map((view) => view).toList()),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: _FloatingActionButton(
              productNameAddController: productNameAddController,
              productPriceAddController: productPriceEditController,
            )));
  }
}

class _Table extends StatelessWidget {
  const _Table({
    Key? key,
    required this.headers,
    required this.products,
    required this.productNameEditController,
    required this.productPriceEditController,
  }) : super(key: key);

  final List<Header> headers;
  final List<Product> products;

  final TextEditingController productNameEditController;
  final TextEditingController productPriceEditController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: headers
                .map(
                  (header) => Expanded(
                      flex: header.flex,
                      child: Text(
                        header.title,
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
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
                  Expanded(
                      flex: 1,
                      child: _ListText(text: products[index].productId)),
                  Expanded(
                      flex: 3,
                      child: _ListText(text: products[index].productName)),
                  Expanded(
                      flex: 2,
                      child: _ListText(
                          text: formatCurrency(products[index].unitPrice))),
                  Expanded(
                      flex: 2,
                      child:
                          _ListText(text: products[index].quantity.toString())),
                  Expanded(
                      flex: 1,
                      child: PopupMenuButton(
                          onSelected: (value) {
                            switch (value) {
                              case 0:
                                showBottomModal(
                                    context,
                                    EditProduct(
                                        productNameController:
                                            productNameEditController,
                                        productPriceController:
                                            productPriceEditController));
                                break;
                              default:
                                showBottomModal(
                                    context, const DeductQuantity());
                                break;
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

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton(
      {Key? key,
      required this.productNameAddController,
      required this.productPriceAddController})
      : super(key: key);

  final TextEditingController productNameAddController;
  final TextEditingController productPriceAddController;

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
            showBottomModal(
                context,
                AddProduct(
                    productNameController: productNameAddController,
                    productPriceController: productPriceAddController))
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
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          indicatorColor: Colors.black,
          labelStyle: Theme.of(context).textTheme.headline3,
          tabs: tabs
              .map(
                (tab) => Tab(
                  text: tab,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
