import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/order_model.dart';
import 'package:dcs_inventory_system/utils/constant.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/views/widgets/order_modals/add_order_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../models/product_model.dart';
import '../../utils/methods.dart';
import '../widgets/widgets.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  static const routeName = "/order";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _onTop = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
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
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ["All", "Pending", "Received", "Cancelled"];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const CustomAppBar(),
          drawer: const SafeArea(child: CustomNavigationDrawer()),
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
                      _TabBarViewChild(
                          orderStatus: OrderStatus.all,
                          scrollController: _scrollController),
                      _TabBarViewChild(
                          orderStatus: OrderStatus.pending,
                          scrollController: _scrollController),
                      _TabBarViewChild(
                          orderStatus: OrderStatus.received,
                          scrollController: _scrollController),
                      _TabBarViewChild(
                          orderStatus: OrderStatus.cancelled,
                          scrollController: _scrollController)
                    ],
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: _onTop,
            child: CustomFloatingActionButton(children: [
              SpeedDialChild(
                child: const Icon(Icons.file_download),
                label: "Export",
                onTap: () => {},
              ),
              SpeedDialChild(
                child: const Icon(Icons.add),
                label: "Add",
                onTap: () => {showBottomModal(context, const AddOrderModal())},
              )
            ]),
          )),
    );
  }
}

class _TabBarViewChild extends StatelessWidget {
  const _TabBarViewChild({
    Key? key,
    required this.orderStatus,
    required this.scrollController,
  }) : super(key: key);
  final OrderStatus orderStatus;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrdersLoaded) {
          List<Order> orders = orderStatus == OrderStatus.all
              ? state.orders
              : state.orders
                  .where((order) => order.status == orderStatus.name)
                  .toList();
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
                controller: scrollController,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  Order order = orders[index];
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color(0xEEEBE6E6),
                    ),
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        _OrderDetailContainer(
                            title: "ID", text: order.orderId.toString()),
                        _OrderDetailContainer(
                            title: "Product Name",
                            text: order.product.productName),
                        _OrderDetailContainer(
                            title: "Quantity", text: order.quantity.toString()),
                        _OrderDetailContainer(
                            text: order.supplier.supplierName,
                            title: "SupplierName"),
                        _OrderDetailContainer(
                            title: "Ordered Date",
                            text: order.orderedDate.formatDate()),
                        order.status == OrderStatus.received.name
                            ? _OrderDetailContainer(
                                title: "Date Received",
                                text: order.dateReceived.formatDate())
                            : const SizedBox.shrink(),
                        order.status == OrderStatus.cancelled.name
                            ? _OrderDetailContainer(
                                title: "Date Cancelled",
                                text: order.dateCancelled.formatDate())
                            : const SizedBox.shrink(),
                        _OrderDetailContainer(
                          title: "Status",
                          text: order.status.toTitleCase(),
                          color: statusFormatColor(order.status),
                        ),
                        order.status == OrderStatus.pending.name
                            ? Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                          text: "Receive",
                                          fontColor: Colors.white,
                                          backgroundColor: Colors.black,
                                          onPressed: () {
                                            Order editedOrder = order.copyWith(
                                                dateReceived:
                                                    Timestamp.now().toDate(),
                                                status:
                                                    OrderStatus.received.name);
                                            int addedQuantity = order.quantity;
                                            Product product = order.product
                                                .copyWith(
                                                    quantity:
                                                        order.product.quantity +
                                                            addedQuantity,
                                                    isNew: false);

                                            BlocProvider.of<OrderBloc>(context)
                                                .add(ReceiveOrder(
                                                    product, editedOrder));
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
                                                          .cancelled.name,
                                                      dateCancelled:
                                                          Timestamp.now()
                                                              .toDate());
                                              BlocProvider.of<OrderBloc>(
                                                      context)
                                                  .add(CancelOrder(order));
                                            }))
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                }),
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
        Text("$title :", style: Theme.of(context).textTheme.headline5),
        const SizedBox(
          width: 5,
        ),
        Text(text,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: color, fontWeight: FontWeight.normal))
      ],
    );
  }
}
