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

    return DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const CustomAppBar(),
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
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is Success) {
                showSuccessSnackBar(context, state.successMessage);
              }
              if (state is Error) {
                showErrorSnackBar(context, state.errorMessage);
              }
            },
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
                      bool isOutOfStock =
                          product.isNew == false && product.quantity == 0;
                      bool isNew = product.isNew == true;
                      return Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.only(
                              right: 15.0, left: 15, bottom: 10, top: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xEEEBE6E6),
                          ),
                          child: Row(children: [
                            Expanded(
                                flex: 1,
                                child: Text((index + 1).toString(),
                                    style:
                                        Theme.of(context).textTheme.headline5)),
                            Expanded(
                                flex: 4,
                                child: Text(product.productName,
                                    style:
                                        Theme.of(context).textTheme.headline5)),
                            Expanded(
                                flex: 2,
                                child: Text(product.quantity.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline5)),
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
                                        case 1:
                                          showBottomModal(
                                              context,
                                              DeductQuantityModal(
                                                selectedProduct: product,
                                              ));
                                          break;
                                        default:
                                          showAlertDialog(
                                              context: context,
                                              title: "Delete Product",
                                              content:
                                                  "Are you sure do you want to delete this product?",
                                              onPressed: () {
                                                Navigator.pop(context);
                                                BlocProvider.of<ProductBloc>(
                                                        context)
                                                    .add(
                                                        DeleteProduct(product));
                                              });
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
                                          ),
                                          const PopupMenuItem(
                                            value: 2,
                                            child: Text("Delete"),
                                          )
                                        ])),
                          ]),
                        ),
                        Visibility(
                          visible: isNew || isOutOfStock,
                          child: Positioned(
                              top: -1,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: isOutOfStock
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                child: Text(
                                    isOutOfStock ? 'Out of Stock' : 'New',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ]);
                    },
                  );
                } else {
                  return const Center(child: Text("Something went wrong."));
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
