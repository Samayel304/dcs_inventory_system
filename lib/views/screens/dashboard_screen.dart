import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    final user = context.select((AuthBloc authBloc) => authBloc.state);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      drawer: const SafeArea(child: CustomNavigationDrawer()),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Greetings(
              currentDate: currentDate,
              userFirstName: user.status == AuthStatus.authenticated
                  ? user.user!.firstName.toTitleCase()
                  : '',
            ),
            const _Cards(),
            const _TodaysOrderListView()
          ],
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
            'Today\'s Order',
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const CustomCircularProgress();
                }
                if (state is OrdersLoaded) {
                  final List<Order> todaysOrders = state.orders
                      .where((order) =>
                          order.orderedDate.isSameDate(DateTime.now()))
                      .toList();
                  return todaysOrders.isEmpty
                      ? Center(
                          child: Text(
                          'No requested order today!',
                          style: Theme.of(context).textTheme.headline5,
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: todaysOrders.length,
                          itemBuilder: (context, index) {
                            final Order order = todaysOrders[index];
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
                                  _generateOrderDetails(
                                      context, order.product.productName,
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
                      const CustomCircularProgress(),
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
                        ));
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
                  return _generateCard(context, 'Out of Stock Products',
                      const CustomCircularProgress());
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
                      ));
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
                    return _generateCard(context, 'Number of Suppliers',
                        const CustomCircularProgress());
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
                        ));
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
                      const CustomCircularProgress(),
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
                        ));
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

  Card _generateCard(BuildContext context, String title, Widget value) {
    double width = MediaQuery.of(context).size.width - 56;
    return Card(
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
    );
  }
}

class Greetings extends StatelessWidget {
  const Greetings({
    Key? key,
    required this.currentDate,
    required this.userFirstName,
  }) : super(key: key);

  final DateTime currentDate;
  final String userFirstName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello $userFirstName',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          currentDate.formatGreetingsDate(),
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
