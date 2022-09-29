import 'package:dcs_inventory_system/views/widgets/bottom_navbar.dart';
import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  static const routeName = '/inventory';
  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['Coffee', 'Milktea', 'Dimsum'];

    return DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
            ),
            bottomNavigationBar: const BottomNavBar(index: 1),
            body: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [const _SearchBar(), _Category(tabs: tabs)],
            ),
            floatingActionButton: SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: Colors.black,
              children: [
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
              ],
            )));
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search',
        fillColor: Colors.grey.shade200,
        filled: true,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
