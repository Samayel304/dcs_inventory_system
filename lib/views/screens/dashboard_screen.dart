import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/utils/enums.dart';
import 'package:dcs_inventory_system/utils/fcm_helper.dart';

import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../models/model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      FcmHelper.initialize(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      drawer: const SafeArea(child: NavigationDrawer()),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Greetings(), _Cards(), _TodaysOrderListView()],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }
}

class _TodaysOrderListView extends StatelessWidget {
  const _TodaysOrderListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Requested Supplies',
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Loader();
                }
                if (state is OrdersLoaded) {
                  final List<OrderModel> todaysOrders = state.orders
                      .where((order) =>
                          order.orderedDate.isSameDate(DateTime.now()))
                      .toList();
                  return todaysOrders.isEmpty
                      ? Center(
                          child: Text(
                          'No requested supply today!',
                          style: Theme.of(context).textTheme.headline5,
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: todaysOrders.length,
                          itemBuilder: (context, index) {
                            final OrderModel order = todaysOrders[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 20, bottom: 20),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xEEEBE6E6),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _generateOrderDetails(
                                      context, order.orderId!),
                                  _generateOrderDetails(context,
                                      order.product.productName.toTitleCase(),
                                      flex: 2),
                                  _generateOrderDetails(
                                      context, 'x${order.quantity}'),
                                  _generateOrderDetails(
                                      context, order.status.toTitleCase(),
                                      color: statusFormatColor(order.status)),
                                ],
                              ),
                            );
                          },
                        );
                } else {
                  return const ErrorScreen();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Expanded _generateOrderDetails(BuildContext context, String text,
      {Color? color = Colors.black, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text,
        style: Theme.of(context).textTheme.headline5!.copyWith(color: color),
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select((AuthBloc authBloc) => authBloc.state.user);

    bool isAdmin = currentUser?.role == UserRole.admin.name;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return _generateCard(
                      context,
                      'Number of Products',
                      const Loader(),
                    );
                  }
                  if (state is ProductsLoaded) {
                    final String totalProductCount =
                        state.products.length.toString();
                    return _generateCard(
                        context,
                        'Number of Products',
                        Text(
                          totalProductCount,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Colors.white),
                        ), onTap: () {
                      GoRouter.of(context).go('/inventory');
                    });
                  } else {
                    return _generateCard(
                      context,
                      'Number of Products',
                      const ErrorScreen(),
                    );
                  }
                },
              ),
              BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
                if (state is ProductsLoading) {
                  return _generateCard(
                      context, 'Out of Stock Products', const Loader());
                }
                if (state is ProductsLoaded) {
                  final String outOfStockProduct = state.products
                      .where((product) =>
                          product.quantity == 0 && product.isNew == false)
                      .length
                      .toString();
                  return _generateCard(
                      context,
                      'Out of Stock Products',
                      Text(
                        outOfStockProduct,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Colors.white),
                      ), onTap: () {
                    BlocProvider.of<ProductSearchBloc>(context)
                        .add(GetAllOutOfStock());
                    GoRouter.of(context).push('/out_of_stock');
                  });
                } else {
                  return _generateCard(
                      context, 'Out of Stock Products', const ErrorScreen());
                }
              }),
            ],
          ),
          Row(
            children: [
              BlocBuilder<SupplierBloc, SupplierState>(
                builder: (context, state) {
                  if (state is SupplierLoading) {
                    return _generateCard(
                        context, 'Number of Suppliers', const Loader());
                  }
                  if (state is SupplierLoaded) {
                    final String totalSupplier =
                        state.suppliers.length.toString();
                    return _generateCard(
                        context,
                        'Number of Suppliers',
                        Text(
                          totalSupplier,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Colors.white),
                        ),
                        onTap: isAdmin
                            ? () {
                                GoRouter.of(context).push('/supplier');
                              }
                            : null);
                  } else {
                    return _generateCard(
                        context, 'Number of Suppliers', const ErrorScreen());
                  }
                },
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return _generateCard(
                      context,
                      'Number of Users',
                      const Loader(),
                    );
                  }
                  if (state is UserLoaded) {
                    final String totalUser = state.users.length.toString();
                    return _generateCard(
                        context,
                        'Number of Users',
                        Text(
                          totalUser,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Colors.white),
                        ),
                        onTap: isAdmin
                            ? () {
                                GoRouter.of(context).push('/manage_account');
                              }
                            : null);
                  } else {
                    return _generateCard(
                        context, 'Number of Users', const ErrorScreen());
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _generateCard(BuildContext context, String title, Widget value,
      {void Function()? onTap}) {
    double width = MediaQuery.of(context).size.width - 56;
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Container(
          width: width / 2,
          color: Colors.black,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              value,
              const SizedBox(height: 10),
              Text(title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}

class Greetings extends StatelessWidget {
  const Greetings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoading) {
        return const Loader();
      }
      if (state is UserLoaded) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        UserModel user = state.users.where((user) => user.id == uid).first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${user.firstName}',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              DateTime.now().formatGreetingsDate(),
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        );
      } else {
        return const ErrorScreen();
      }
    });
  }
}
