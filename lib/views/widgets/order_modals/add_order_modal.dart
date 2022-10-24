import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/constant.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  Widget build(BuildContext context) {
    void success() {
      productQuantityController.clear();

      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 12.0);
      Navigator.pop(context);
    }

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
                    return const CustomCircularProgress();
                  }
                  if (state is ProductsLoaded) {
                    selectedProduct = state.products.first;

                    return CustomDropdown(
                      value: selectedProduct,
                      hint: const Text("Select product."),
                      validator: (value) {
                        if (value == null) {
                          return "Please Select product.";
                        }
                        return null;
                      },
                      onChange: (value) {
                        setState(() {
                          selectedProduct = value!;
                        });
                      },
                      listItem: state.products
                          .map<DropdownMenuItem<Product>>((Product value) {
                        return DropdownMenuItem<Product>(
                          value: value,
                          child: Text(value.productName),
                        );
                      }).toList(),
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
                    return const CustomCircularProgress();
                  }
                  if (state is SupplierLoaded) {
                    selectedSupplier = state.suppliers.first;

                    return CustomDropdown(
                      value: selectedProduct,
                      hint: const Text("Select supplier."),
                      validator: (value) {
                        if (value == null) {
                          return "Please Select supplier.";
                        }
                        return null;
                      },
                      onChange: (value) {
                        setState(() {
                          selectedSupplier = value!;
                        });
                      },
                      listItem: state.suppliers
                          .map<DropdownMenuItem<Supplier>>((Supplier value) {
                        return DropdownMenuItem<Supplier>(
                          value: value,
                          child: Text(value.supplierName),
                        );
                      }).toList(),
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
                      Order order = Order(
                          dateReceived: Timestamp.now().toDate(),
                          product: selectedProduct!,
                          orderedDate: Timestamp.now().toDate(),
                          quantity: int.parse(productQuantityController.text),
                          status: OrderStatus.pending.name,
                          supplier: selectedSupplier!);
                      BlocProvider.of<OrderBloc>(context).add(AddOrder(order));

                      success();
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

/* class _ProductDropdownList extends StatefulWidget {
  const _ProductDropdownList({Key? key, this.selectedProduct}) : super(key: key);
  final Product? selectedProduct;
  @override
  State<_ProductDropdownList> createState() => _ProductDropdownListState();
}

class _ProductDropdownListState extends State<_ProductDropdownList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const CustomCircularProgress();
        }
        if (state is ProductsLoaded) {
          widget.selectedProduct = state.products.first;
          return CustomDropdown(
            value: selectedProduct,
            hint: const Text("Select product."),
            validator: (value) {
              if (value == null) {
                return "Please Select product.";
              }
              return null;
            },
            onChange: (value) {
              setState(() {
                selectedProduct = value!;
              });
            },
            listItem:
                state.products.map<DropdownMenuItem<Product>>((Product value) {
              return DropdownMenuItem<Product>(
                value: value,
                child: Text(value.productName),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text("Something went wrong."));
        }
      },
    );
  }
} */
