import 'package:dcs_inventory_system/models/order_model.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_app_bar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_elevated_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_floating_action_button.dart';
import 'package:dcs_inventory_system/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../widgets/custom_tab_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  static const routeName = "/order";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    List<SpeedDialChild> fabChildren = [
      SpeedDialChild(
        child: const Icon(Icons.file_download),
        label: "Export",
        onTap: () => {},
      ),
      SpeedDialChild(
        child: const Icon(Icons.add),
        label: "Add",
        onTap: () => {},
      )
    ];

    List<String> tabs = ["All", "Pending", "Received", "Cancelled"];

    List<Widget> tabBarViewChildren = [
      const _TabBarViewChild(),
      const _TabBarViewChild(),
      const _TabBarViewChild(),
      const _TabBarViewChild(),
    ];

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
                    tabBarViewChild: tabBarViewChildren,
                  ),
                )
              ],
            ),
          ),
          floatingActionButton:
              CustomFloatingActionButton(children: fabChildren)),
    );
  }
}

class _TabBarViewChild extends StatelessWidget {
  const _TabBarViewChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ListView.builder(
          itemCount: Order.orders.length,
          itemBuilder: (context, index) => Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xEEEBE6E6),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _OrderDetailContainer(
                        title: "ID", text: Order.orders[index].orderId),
                    _OrderDetailContainer(
                        title: "Product Name",
                        text: Order.orders[index].products.productName),
                    _OrderDetailContainer(
                        title: "Quantity",
                        text: Order.orders[index].quantity.toString()),
                    _OrderDetailContainer(
                        title: "Ordered Date",
                        text: formatDateTime(Order.orders[index].orderedDate)),
                    _OrderDetailContainer(
                      title: "Status",
                      text: Order.orders[index].status,
                      color: statusFormatColor(Order.orders[index].status),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                              text: "Receive",
                              fontColor: Colors.white,
                              backgroundColor: Colors.black,
                              onPressed: () {}),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: CustomElevatedButton(
                              text: "Cancel",
                              backgroundColor: Colors.white,
                              onPressed: () {}),
                        )
                      ],
                    )
                  ],
                ),
              )),
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
