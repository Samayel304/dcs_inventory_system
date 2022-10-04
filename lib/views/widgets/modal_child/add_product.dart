import 'package:dcs_inventory_system/views/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({
    Key? key,
  }) : super(key: key);

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Product", style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 20),
            const CustomTextField(
              hintText: "Product Name",
            ),
            const SizedBox(height: 15),
            const CustomTextField(hintText: "Price"),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {},
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
