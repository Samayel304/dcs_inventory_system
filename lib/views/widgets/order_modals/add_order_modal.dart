import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/enums.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddOrderModal extends StatefulWidget {
  const AddOrderModal({
    Key? key,
  }) : super(key: key);

  @override
  State<AddOrderModal> createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  TextEditingController productQuantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Product? selectedProduct;
  Supplier? selectedSupplier;

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
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Order", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Loader();
                  }
                  if (state is ProductsLoaded) {
                    return CustomDropdown(
                      validator: (value) {
                        if (value == null) {
                          return "Select Product";
                        }
                        return null;
                      },
                      hint: "Select Product",
                      itemAsString: (product) {
                        return product.productName;
                      },
                      items: state.products,
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                        });
                      },
                      selectedItem: selectedProduct,
                    );
                  } else {
                    return const Center(child: Text("Something went wrong."));
                  }
                },
              ),
              const SizedBox(height: 15),
              BlocBuilder<SupplierBloc, SupplierState>(
                builder: (context, state) {
                  if (state is SupplierLoading) {
                    return const Loader();
                  }
                  if (state is SupplierLoaded) {
                    return CustomDropdown(
                      validator: (value) {
                        if (value == null) {
                          return "Select Supplier";
                        }
                        return null;
                      },
                      hint: "Select Supplier",
                      itemAsString: (supplier) {
                        return supplier.supplierName;
                      },
                      items: state.suppliers,
                      onChanged: (value) {
                        setState(() {
                          selectedSupplier = value;
                        });
                      },
                      selectedItem: selectedSupplier,
                    );
                  } else {
                    return const Center(child: Text("Something went wrong."));
                  }
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Quantity";
                  }
                  return null;
                },
                controller: productQuantityController,
                hintText: "Quantity",
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(
                  text: "Order",
                  fontColor: Colors.white,
                  backgroundColor: Colors.black,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addOrder(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
