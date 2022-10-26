import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({super.key});

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
                  hintText: "OldPassword",
                ),
                const LabeledTextfield(
                  hintText: "NewPassword",
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
