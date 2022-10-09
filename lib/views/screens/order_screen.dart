import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_app_bar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_floating_action_button.dart';
import 'package:dcs_inventory_system/views/widgets/textfield/custom_textfield.dart';
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
          itemCount: 1,
          itemBuilder: (context, index) => Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color(0xEEEBE6E6),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [Text("ID :"), Text("1")],
                    ),
                  ],
                ),
              )),
    );
  }
}
