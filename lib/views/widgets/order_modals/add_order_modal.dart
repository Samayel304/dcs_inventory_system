import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/enums.dart';
import 'package:dcs_inventory_system/utils/utils.dart';

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
              Text("Request Supply",
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Loader();
                  }
                  if (state is ProductsLoaded) {
                    return CustomDropdown(
                      hint: "Select Product",
                      itemAsString: (product) {
                        return product.productName.toString().toTitleCase();
                      },
                      items: state.products,
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                        });
                        setCanSave();
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
                      hint: "Select Supplier",
                      itemAsString: (supplier) {
                        return supplier.supplierName;
                      },
                      items: state.suppliers,
                      onChanged: (value) {
                        setState(() {
                          selectedSupplier = value;
                        });
                        setCanSave();
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
                onChange: (_) {
                  setCanSave();
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
                  isDisable: !_canSave,
                  text: "Order",
                  fontColor: Colors.white,
                  backgroundColor: Colors.black,
                  onPressed: () {
                    addOrder(context);
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
