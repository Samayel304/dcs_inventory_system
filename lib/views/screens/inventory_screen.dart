import 'package:dcs_inventory_system/models/header_model.dart';
import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/view_models/inventory_view_model.dart';
import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/modal_child/add_product.dart';
import 'package:dcs_inventory_system/views/widgets/modal_child/deduct_quantity.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';

import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../utils/helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/modal_child/edit_product.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  static const routeName = '/inventory';

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;

  TextEditingController productNameEditController = TextEditingController();
  TextEditingController productPriceEditController = TextEditingController();

  TextEditingController productQuantityController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    InventoryViewModel inventoryViewModel = context.watch<InventoryViewModel>();

    List<String> tabs = ['Coffee', 'Milktea', 'Dimsum'];
    List<Widget> tabBarView = [
      SizedBox(
        child: _TabBarViewChild(
          category: _currentTabIndex,
          headers: Header.headers,
          products: inventoryViewModel.coffee,
        ),
      ),
      SizedBox(
        child: _TabBarViewChild(
          category: _currentTabIndex,
          headers: Header.headers,
          products: inventoryViewModel.milktea,
        ),
      ),
      SizedBox(
        child: _TabBarViewChild(
          category: _currentTabIndex,
          headers: Header.headers,
          products: inventoryViewModel.dimsum,
        ),
      ),
    ];

    return DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(),
            bottomNavigationBar: const BottomNavBar(index: 1),
            body: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  const CustomTextField(
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: CustomTabBar(
                      tabs: tabs,
                      tabBarController: _tabController,
                      tabBarViewChild: tabBarView,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: _FloatingActionButton(
              category: _currentTabIndex,
            )));
  }
}

class _TabBarViewChild extends StatelessWidget {
  const _TabBarViewChild({
    Key? key,
    required this.headers,
    required this.products,
    required this.category,
  }) : super(key: key);

  final List<Header> headers;
  final List<Product> products;

  final int category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
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
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xEEEBE6E6),
                ),
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Text(products[index].productId,
                          style: Theme.of(context).textTheme.headline3)),
                  Expanded(
                      flex: 3,
                      child: Text(products[index].productName,
                          style: Theme.of(context).textTheme.headline3)),
                  Expanded(
                      flex: 2,
                      child: Text(formatCurrency(products[index].unitPrice),
                          style: Theme.of(context).textTheme.headline3)),
                  Expanded(
                      flex: 2,
                      child: Text(products[index].quantity.toString(),
                          style: Theme.of(context).textTheme.headline3)),
                  Expanded(
                      flex: 1,
                      child: PopupMenuButton(
                          onSelected: (value) {
                            switch (value) {
                              case 0:
                                showBottomModal(
                                    context,
                                    EditProduct(
                                      selectedProduct: products[index],
                                      category: category,
                                    ));
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
  const _FloatingActionButton({Key? key, required this.category})
      : super(key: key);

  final int category;

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
          onTap: () =>
              {showBottomModal(context, AddProduct(category: category))},
        )
      ],
    );
  }
}
