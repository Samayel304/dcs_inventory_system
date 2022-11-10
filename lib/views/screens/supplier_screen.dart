import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../models/model.dart';
import '../../utils/methods.dart';
import '../widgets/widgets.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  late ScrollController _scrollController;
  bool _onTop = true;

  @override
  void initState() {
    super.initState();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(),
        drawer: const SafeArea(child: CustomNavigationDrawer()),
        bottomNavigationBar: const BottomNavBar(index: 3),
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
              onTap: () => {showBottomModal(context, const AddSupplierModal())},
            )
          ]),
        ),
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
                const SizedBox(height: 15),
                Expanded(
                  child: BlocBuilder<SupplierBloc, SupplierState>(
                    builder: (context, state) {
                      if (state is SupplierLoading) {
                        return const CustomCircularProgress();
                      }
                      if (state is SupplierLoaded) {
                        return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: state.suppliers.length,
                            itemBuilder: ((context, index) {
                              Supplier supplier = state.suppliers[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xEEEBE6E6),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          _DetailText(
                                              text: supplier.supplierName,
                                              title: "Supplier Name"),
                                          _DetailText(
                                              text: supplier.contactPerson,
                                              title: "Contact Person"),
                                          _DetailText(
                                              text: supplier.address,
                                              title: "Address"),
                                          _DetailText(
                                              text: supplier.contactNumber,
                                              title: "Contact Number")
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: PopupMenuButton(
                                        onSelected: (value) {
                                          switch (value) {
                                            case 0:
                                              showBottomModal(
                                                  context,
                                                  EditSupplierModal(
                                                      selectedSupplier:
                                                          supplier));
                                              break;
                                            case 1:
                                              showAlertDialog(
                                                  context: context,
                                                  title: 'Delete Supplier',
                                                  content:
                                                      'Are you sure you to delete this supplier?',
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    BlocProvider.of<
                                                                SupplierBloc>(
                                                            context)
                                                        .add(DeleteSupplier(
                                                            supplier));
                                                  });
                                              break;
                                          }
                                        },
                                        icon: const Icon(Icons.more_vert),
                                        itemBuilder: (context) {
                                          return [
                                            const PopupMenuItem(
                                                value: 0, child: Text("Edit")),
                                            const PopupMenuItem(
                                                value: 1, child: Text("Delete"))
                                          ];
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }));
                      } else {
                        return const Text("Something went wrong.");
                      }
                    },
                  ),
                ),
              ],
            )));
  }
}

class _DetailText extends StatelessWidget {
  const _DetailText({
    Key? key,
    required this.text,
    required this.title,
  }) : super(key: key);
  final String text;
  final String title;

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
                .copyWith(color: Colors.black, fontWeight: FontWeight.normal))
      ],
    );
  }
}
