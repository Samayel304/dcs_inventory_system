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
      type: BottomNavigationBarType.fixed,
      currentIndex: index,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withAlpha(100),
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/');
            },
            icon: const Icon(Icons.dashboard_rounded),
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
          label: 'Supplies',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/order');
            },
            icon: const Icon(Icons.pending_actions),
          ),
          label: 'Requested Orders',
        ),
      ],
    );
  }
}
