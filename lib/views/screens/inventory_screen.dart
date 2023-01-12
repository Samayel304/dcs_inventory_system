import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/enums.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import '../../utils/utils.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _onTop = true;
  int _tabLength = 0;

  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    /* final category = context
        .select((CategoryBloc category) => category.state as CategoryLoaded); */
    //BlocProvider.of<ProductSearchBloc>(context).add(const SearchProduct(''));
    _tabController = TabController(length: _tabLength, vsync: this);
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
    super.initState();
  }

  @override
  void deactivate() {
    resetProduct();
    super.deactivate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void resetProduct() {
    BlocProvider.of<ProductSearchBloc>(context).add(const SearchProduct(''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Scaffold(
            appBar: CustomAppBar(),
            body: Loader(),
            bottomNavigationBar: BottomNavBar(index: 1),
          );
        } else if (state is CategoryLoaded) {
          int length = state.categories.length;
          bool isTabBarEmpty = length == 0;
          List<String> tabs = state.categories
              .map((category) => category.categoryName)
              .toList();

          _tabLength = length;

          _tabController = TabController(
              length: length,
              vsync: this,
              initialIndex: _currentTabIndex >= length ? 0 : _currentTabIndex);
          _tabController.addListener(() {
            setState(() {
              _currentTabIndex = _tabController.index;
              _onTop = true;
            });
          });

          final currentUser = context
              .select((ProfileBloc profileBloc) => profileBloc.state.user);
          bool isAdmin = currentUser?.role == UserRole.admin.name;

          return DefaultTabController(
              initialIndex: 0,
              length: length,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: const CustomAppBar(),
                drawer: const SafeArea(child: NavigationDrawer()),
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
                        onChange: (value) {
                          BlocProvider.of<ProductSearchBloc>(context)
                              .add(SearchProduct(value));
                        },
                      ),
                      Expanded(
                        child: isTabBarEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Category!',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    CustomElevatedButton(
                                      text: 'Add Category',
                                      backgroundColor: Colors.black,
                                      fontColor: Colors.white,
                                      onPressed: () {
                                        GoRouter.of(context).push('/category');
                                      },
                                    )
                                  ],
                                ),
                              )
                            : CustomTabBar(
                                tabs: tabs,
                                tabBarController: _tabController,
                                tabBarViewChild: tabs.map(
                                  (tab) {
                                    return SizedBox(
                                        child: _TabBarViewChild(
                                      headers: Header.headers,
                                      category: tab,
                                      scrollController: _scrollController,
                                    ));
                                  },
                                ).toList()),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Visibility(
                    visible: _onTop && length > 0,
                    child: isAdmin
                        ? CustomFloatingActionButton(
                            children: [
                              SpeedDialChild(
                                child: const Icon(Icons.file_download),
                                label: "Export",
                                onTap: () => {
                                  BlocProvider.of<ProductBloc>(context)
                                      .add(ExportItems(context))
                                },
                              ),
                              SpeedDialChild(
                                child: const Icon(Icons.category),
                                label: "Manage Category",
                                onTap: () {
                                  GoRouter.of(context).push('/category');
                                },
                              ),
                              SpeedDialChild(
                                child: const Icon(Icons.add),
                                label: "Add Item",
                                onTap: () => {
                                  showBottomModal(
                                      context,
                                      AddProductModal(
                                          category: tabs[_currentTabIndex]))
                                },
                              ),
                            ],
                          )
                        : FloatingActionButton(
                            onPressed: () {
                              showBottomModal(
                                  context,
                                  AddProductModal(
                                      category: tabs[_currentTabIndex]));
                            },
                            backgroundColor: Colors.black,
                            child: const Icon(Icons.add),
                          )),
                bottomNavigationBar: const BottomNavBar(index: 1),
              ));
        } else {
          return const ErrorScreen();
        }
      },
    );
  }
}

class _TabBarViewChild extends StatelessWidget {
  const _TabBarViewChild({
    Key? key,
    required this.headers,
    required this.category,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;
  final List<Header> headers;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
            builder: (context, state) {
              if (state is ProductSearchLoading) {
                return const Loader();
              }
              if (state is ProductSearchLoaded) {
                List<Product> products = state.products
                    .where((product) => product.category == category)
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product product = products[index];
                    bool isOutOfStock =
                        product.isNew == false && product.quantity == 0;
                    bool isNew = product.isNew == true;
                    bool isDeductMenuVisible = product.quantity == 0;
                    bool isQuantityZero = product.quantity == 0;
                    return Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        padding: const EdgeInsets.only(
                            right: 15.0, left: 15, bottom: 10, top: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xEEEBE6E6),
                        ),
                        child: Stack(children: [
                          Row(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: CircleAvatar(
                                      radius: (30),
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.network(
                                            product.productImageUrl),
                                      ))),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      buildDetailText(context, 'Item Name',
                                          product.productName.toTitleCase()),
                                      buildDetailText(
                                          context,
                                          'Product Quantity',
                                          product.quantity.toString()),
                                      buildDetailText(context, 'Life Span',
                                          product.lifeSpan),
                                      buildDetailText(context, 'Unit Price',
                                          formatCurrency(product.unitPrice)),
                                      buildDetailText(context, 'Total Expenses',
                                          formatCurrency(product.totalExpenses))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
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
                                                  .add(DeleteProduct(
                                                      product, context));
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
                                        PopupMenuItem(
                                          enabled: !isDeductMenuVisible,
                                          value: 1,
                                          child: const Text("Deduct"),
                                        ),
                                        PopupMenuItem(
                                          enabled: isQuantityZero,
                                          value: 2,
                                          child: const Text("Delete"),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color:
                                    isOutOfStock ? Colors.orange : Colors.green,
                              ),
                              child: Text(isOutOfStock ? 'Out of Stock' : 'New',
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
        )
      ],
    );
  }

  Widget buildDetailText(BuildContext context, String title, String text) {
    return Row(
      children: [
        Text("$title :", style: Theme.of(context).textTheme.headline5),
        const SizedBox(
          width: 5,
        ),
        Text(text,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.black, fontWeight: FontWeight.normal))
      ],
    );
  }
}
