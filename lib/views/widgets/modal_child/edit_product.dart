import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget {
  const EditProduct({
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
            Text("Edit Product", style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Product Name",
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Price",
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
