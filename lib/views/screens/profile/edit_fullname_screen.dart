import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditFullNameScreen extends StatelessWidget {
  const EditFullNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const LabeledTextfield(
                  hintText: "FirstName",
                ),
                const LabeledTextfield(
                  hintText: "MiddleName",
                ),
                const LabeledTextfield(
                  hintText: "LastName",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomElevatedButton(
                      fontColor: Colors.white,
                      text: "Save Changes",
                      backgroundColor: Colors.black,
                      onPressed: () {}),
                )
              ],
            ),
          ),
        ));
  }
}
