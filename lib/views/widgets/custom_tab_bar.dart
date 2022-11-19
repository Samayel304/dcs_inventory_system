import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.tabBarController,
    required this.tabBarViewChild,
  }) : super(key: key);

  final List<String> tabs;
  final TabController tabBarController;
  final List<Widget> tabBarViewChild;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabBarController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          indicatorColor: Colors.black,
          labelStyle: Theme.of(context).textTheme.headline3,
          tabs: tabs
              .map(
                (tab) => Tab(
                  text: tab.toTitleCase(),
                ),
              )
              .toList(),
        ),
        Expanded(
          child: SizedBox(
            child: TabBarView(
                controller: tabBarController,
                children: tabBarViewChild.map((view) => view).toList()),
          ),
        ),
      ],
    );
  }
}
