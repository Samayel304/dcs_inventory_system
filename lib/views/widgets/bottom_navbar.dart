import 'package:dcs_inventory_system/views/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withAlpha(100),
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(left: 50),
            child: IconButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              icon: const Icon(Icons.dashboard_rounded),
            ),
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/inventory');
            },
            icon: const Icon(Icons.inventory),
          ),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(right: 50),
            child: IconButton(
              onPressed: () {
                GoRouter.of(context).go('/order');
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          label: 'Orders',
        ),
      ],
    );
  }
}
