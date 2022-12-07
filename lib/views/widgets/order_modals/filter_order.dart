import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/enums.dart';
import 'package:dcs_inventory_system/utils/utils.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterOrder extends StatefulWidget {
  const FilterOrder({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterOrder> createState() => _FilterOrderState();
}

class _FilterOrderState extends State<FilterOrder> {
  TextEditingController productQuantityController = TextEditingController();

  //final _formKey = GlobalKey<FormState>();
  Product? selectedProduct;
  Supplier? selectedSupplier;
  bool _canSave = false;

  @override
  void dispose() {
    productQuantityController.dispose();
    super.dispose();
  }

  void addOrder(BuildContext context) {
    OrderModel order = OrderModel(
        dateReceived: Timestamp.now().toDate(),
        dateCancelled: Timestamp.now().toDate(),
        product: selectedProduct!,
        orderedDate: Timestamp.now().toDate(),
        quantity: int.parse(productQuantityController.text),
        status: OrderStatus.pending.name,
        supplier: selectedSupplier!);
    BlocProvider.of<OrderBloc>(context).add(AddOrder(order, context));
  }

  void setCanSave() {
    if (selectedProduct != null &&
        selectedSupplier != null &&
        productQuantityController.text.isNotEmpty) {
      setState(() {
        _canSave = true;
      });
    } else {
      setState(() {
        _canSave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filter", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              BlocBuilder<OrderFilterBloc, OrderFilterState>(
                builder: (context, state) {
                  if (state is OrderFilterLoading) {
                    return const Loader();
                  }
                  if (state is OrderFilterLoaded) {
                    return Wrap(
                      spacing: 8,
                      children: List.generate(state.selectedSuppliers.length,
                          (index) {
                        return ChoiceChip(
                          labelPadding: EdgeInsets.all(2.0),
                          label: Text(
                            state.selectedSuppliers[index].supplierName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          selected: state.selectedSuppliers[index].isSelected,
                          selectedColor: Colors.deepPurple,
                          onSelected: (value) {},
                          // backgroundColor: color,
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                        );
                      }),
                    );
                  } else {
                    return const Center(child: Text("Something went wrong."));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
