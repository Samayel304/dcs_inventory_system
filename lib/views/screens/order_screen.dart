import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/order/order_bloc.dart';
import 'package:dcs_inventory_system/models/order_model.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_app_bar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_floating_action_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:dcs_inventory_system/views/widgets/order_modals/add_order_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../models/product_model.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/show_modal.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  static const routeName = "/order";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ["All", "Pending", "Received", "Cancelled"];

    return BlocBuilder<OrderStatusBloc, OrderStatusState>(
      builder: (context, state) {
        return DefaultTabController(
          initialIndex: 0,
          length: tabs.length,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CustomAppBar(),
              bottomNavigationBar: const BottomNavBar(index: 2),
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
                        tabBarViewChild: [
                          _getOrderList(state, OrderStatus.all),
                          _getOrderList(state, OrderStatus.pending),
                          _getOrderList(state, OrderStatus.received),
                          _getOrderList(state, OrderStatus.cancelled)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: CustomFloatingActionButton(children: [
                SpeedDialChild(
                  child: const Icon(Icons.file_download),
                  label: "Export",
                  onTap: () => {},
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  label: "Add",
                  onTap: () =>
                      {showBottomModal(context, const ModalAddOrder())},
                )
              ])),
        );
      },
    );
  }
}

class ModalAddOrder extends StatelessWidget {
  const ModalAddOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return AddOrderModal(
            products: state.products,
          );
        } else {
          return const Text("Something went wrong.");
        }
      },
    );
  }
}

Widget _getOrderList(OrderStatusState state, OrderStatus status) {
  if (state is OrderStatusLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (state is OrderStatusLoaded) {
    List<Order> orders;
    switch (status) {
      case OrderStatus.all:
        orders = state.all;
        break;
      case OrderStatus.pending:
        orders = state.pendingOrders;
        break;
      case OrderStatus.received:
        orders = state.receivedOrders;
        break;
      case OrderStatus.cancelled:
        orders = state.cancelledOrders;
        break;
    }
    return _TabBarViewChild(orders: orders);
  }
  return const Center(child: Text("Something went wrong"));
}

class _TabBarViewChild extends StatelessWidget {
  const _TabBarViewChild({Key? key, required this.orders}) : super(key: key);
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductsLoaded) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) => Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xEEEBE6E6),
                      ),
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          _OrderDetailContainer(
                              title: "ID",
                              text: orders[index].orderId.toString()),
                          _OrderDetailContainer(
                              title: "Product Name",
                              text: orders[index].product.productName),
                          _OrderDetailContainer(
                              title: "Quantity",
                              text: orders[index].quantity.toString()),
                          _OrderDetailContainer(
                              title: "Ordered Date",
                              text: formatDateTime(orders[index].orderedDate)),
                          orders[index].status == OrderStatus.received.name
                              ? _OrderDetailContainer(
                                  title: "Date Received",
                                  text: formatDateTime(
                                      orders[index].dateReceived))
                              : const SizedBox.shrink(),
                          _OrderDetailContainer(
                            title: "Status",
                            text: orders[index].status,
                            color: statusFormatColor(orders[index].status),
                          ),
                          const SizedBox(height: 10),
                          orders[index].status == OrderStatus.pending.name
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                          text: "Receive",
                                          fontColor: Colors.white,
                                          backgroundColor: Colors.black,
                                          onPressed: () {
                                            Order order = orders[index]
                                                .copyWith(
                                                    dateReceived:
                                                        Timestamp.now()
                                                            .toDate(),
                                                    status: OrderStatus
                                                        .received.name);
                                            int addedQuantity =
                                                orders[index].quantity;
                                            Product product = state.products
                                                .firstWhere((product) =>
                                                    product.productId ==
                                                    orders[index]
                                                        .product
                                                        .productId);
                                            Product editedProduct =
                                                product.copyWith(
                                                    quantity: product.quantity +
                                                        addedQuantity);
                                            BlocProvider.of<OrderBloc>(context)
                                                .add(ReceiveOrder(
                                                    editedProduct, order));
                                          }),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                        child: CustomElevatedButton(
                                            text: "Cancel",
                                            backgroundColor: Colors.white,
                                            onPressed: () {
                                              Order order = orders[index]
                                                  .copyWith(
                                                      status: OrderStatus
                                                          .cancelled.name);
                                              BlocProvider.of<OrderBloc>(
                                                      context)
                                                  .add(CancelOrder(order));
                                            }))
                                  ],
                                )
                              : const SizedBox()
                        ],
                      ),
                    )),
          );
        } else {
          return const Text("Something went wrong.");
        }
      },
    );
  }
}

class _OrderDetailContainer extends StatelessWidget {
  const _OrderDetailContainer(
      {Key? key,
      required this.text,
      required this.title,
      this.color = Colors.black})
      : super(key: key);
  final String text;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title :", style: Theme.of(context).textTheme.headline3),
        const SizedBox(
          width: 5,
        ),
        Text(text,
            style:
                Theme.of(context).textTheme.headline6!.copyWith(color: color))
      ],
    );
  }
}
