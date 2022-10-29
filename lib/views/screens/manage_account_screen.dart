import 'package:dcs_inventory_system/models/header_model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
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
              child: Column(
                children: [
                  Row(
                      children: Header.manageAccountHeaders
                          .map((header) => Expanded(
                              flex: header.flex,
                              child: Text(
                                header.title,
                                style: Theme.of(context).textTheme.bodyText1,
                              )))
                          .toList()),
                  const SizedBox(height: 10),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: ((context, index) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xEEEBE6E6),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar()),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Samayel Ponce",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Text("sam@gmail.com",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)),
                                  Expanded(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.more_vert)))
                                ],
                              ),
                            );
                          })))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
