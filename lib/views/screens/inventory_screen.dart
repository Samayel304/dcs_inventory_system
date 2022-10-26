import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../utils/methods.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _onTop = true;

  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
        _onTop = true;
      });
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // if (_scrollController.position.atEdge) {
      setState(() {
        _onTop = _scrollController.position.pixels == 0;
      });
      //}
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['Coffee', 'Milktea', 'Dimsum'];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(scaffoldKey: scaffoldKey),
          drawer: const SafeArea(child: CustomNavigationDrawer()),
          body: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Search",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  onChange: (keyword) {
                    BlocProvider.of<ProductBloc>(context)
                        .add(SearchProducts(keyword));
                  },
                ),
                Expanded(
                  child: CustomTabBar(
                      tabs: tabs,
                      tabBarController: _tabController,
                      tabBarViewChild: [
                        SizedBox(
                            child: _TabBarViewChild(
                          headers: Header.headers,
                          productCategory: ProductCategory.coffee,
                          scrollController: _scrollController,
                        )),
                        SizedBox(
                            child: _TabBarViewChild(
                                headers: Header.headers,
                                productCategory: ProductCategory.milktea,
                                scrollController: _scrollController)),
                        SizedBox(
                            child: _TabBarViewChild(
                                headers: Header.headers,
                                productCategory: ProductCategory.dimsum,
                                scrollController: _scrollController)),
                      ]),
                ),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: _onTop,
            child: CustomFloatingActionButton(
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.file_download),
                  label: "Export",
                  onTap: () => {
                    BlocProvider.of<ProductBloc>(context).add(ExportToExcel())
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  label: "Add",
                  onTap: () => {
                    showBottomModal(
                        context, AddProductModal(category: _currentTabIndex))
                  },
                )
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavBar(index: 1),
        ));
  }
}

class _TabBarViewChild extends StatelessWidget {
  const _TabBarViewChild({
    Key? key,
    required this.headers,
    required this.productCategory,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;
  final List<Header> headers;
  final ProductCategory productCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 10),
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
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const CustomCircularProgress();
              }
              if (state is ProductsLoaded) {
                List<Product> products = state.products
                    .where(
                        (product) => product.category == productCategory.name)
                    .toList();
                return ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = products[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xEEEBE6E6),
                      ),
                      child: Row(children: [
                        Expanded(
                            flex: 1,
                            child: Text((index + 1).toString(),
                                style: Theme.of(context).textTheme.headline3)),
                        Expanded(
                            flex: 4,
                            child: Text(product.productName,
                                style: Theme.of(context).textTheme.headline3)),
                        Expanded(
                            flex: 2,
                            child: Text(product.quantity.toString(),
                                style: Theme.of(context).textTheme.headline3)),
                        Expanded(
                            flex: 1,
                            child: PopupMenuButton(
                                onSelected: (value) {
                                  switch (value) {
                                    case 0:
                                      showBottomModal(
                                          context,
                                          EditProductModal(
                                            selectedProduct: product,
                                          ));
                                      break;
                                    default:
                                      showBottomModal(
                                          context,
                                          DeductQuantityModal(
                                            selectedProduct: product,
                                          ));
                                      break;
                                  }
                                },
                                icon: const Icon(Icons.more_vert),
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
                );
              } else {
                return const Center(child: Text("Something went wrong."));
              }
            },
          ),
        )
      ],
    );
  }
}
