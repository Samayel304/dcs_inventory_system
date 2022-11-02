import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/utils/methods.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/model.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomModal(context, const AddAccountModal());
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
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
                  Expanded(child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const CustomCircularProgress();
                      }
                      if (state is UserLoaded) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.users.length,
                            itemBuilder: ((context, index) {
                              User user = state.users[index];
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xEEEBE6E6),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: CircleAvatar(
                                                radius: (20),
                                                backgroundColor: Colors.white,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                      user.avatarUrl),
                                                )))),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${user.firstName} ${user.middleName} ${user.lastName}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Text(user.email,
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
                            }));
                      } else {
                        return const Center(
                          child: Text("Something went wrong."),
                        );
                      }
                    },
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
