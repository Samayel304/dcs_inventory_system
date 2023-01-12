import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/model.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  String keyword = '';
  @override
  Widget build(BuildContext context) {
    void changeProfilePicture(UserModel user) async {
      ImagePicker picker = ImagePicker();

      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        BlocProvider.of<UserBloc>(context)
            .add(ChangeProfilePicture(user, context, image));
      }
    }

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
            CustomTextField(
              hintText: "Search",
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              onChange: (value) {
                setState(() {
                  keyword = value;
                });
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Loader();
                      }
                      if (state is UserLoaded) {
                        List<UserModel> users = keyword.isEmpty
                            ? state.users
                                .where((user) => user.role != 'admin')
                                .toList()
                            : state.users
                                .where((user) => user.role != 'admin')
                                .where((user) {
                                String fullName =
                                    '${user.firstName} ${user.middleName} ${user.lastName}';
                                return fullName
                                    .toLowerCase()
                                    .contains(keyword.toLowerCase());
                              }).toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: ((context, index) {
                              UserModel user = users[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xEEEBE6E6),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Stack(children: [
                                  Row(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: CircleAvatar(
                                              radius: (30),
                                              backgroundColor: Colors.white,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                    user.avatarUrl),
                                              ))),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              buildDetailText(
                                                  context,
                                                  'FullName',
                                                  '${user.firstName} ${user.middleName} ${user.lastName}'),
                                              buildDetailText(
                                                  context, 'Email', user.email),
                                              buildDetailText(context,
                                                  'Position', user.position),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: PopupMenuButton(
                                          onSelected: (value) {
                                            switch (value) {
                                              case 0:
                                                showBottomModal(
                                                    context,
                                                    EditFullName(
                                                        selectedUser: user));
                                                break;
                                              case 1:
                                                showBottomModal(
                                                    context,
                                                    ChangePasswordModal(
                                                      selectedUser: user,
                                                    ));
                                                break;

                                              case 2:
                                                changeProfilePicture(user);
                                                break;
                                              default:
                                                showAlertDialog(
                                                    context: context,
                                                    title: "Delete Product",
                                                    content:
                                                        "Are you sure do you want to delete this user?",
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      BlocProvider.of<UserBloc>(
                                                              context)
                                                          .add(DeleteUser(
                                                              user, context));
                                                    });
                                                break;
                                            }
                                          },
                                          icon: const Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 0,
                                                  child: Text("Edit Full Name"),
                                                ),
                                                const PopupMenuItem(
                                                  value: 1,
                                                  child:
                                                      Text("Change Password"),
                                                ),
                                                const PopupMenuItem(
                                                  value: 2,
                                                  child: Text(
                                                      "Change Display Picture"),
                                                ),
                                                const PopupMenuItem(
                                                  value: 3,
                                                  child: Text("Delete"),
                                                )
                                              ])),
                                ]),
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

  Widget buildDetailText(BuildContext context, String title, String text) {
    return Row(
      children: [
        Text("$title :", style: Theme.of(context).textTheme.headline5),
        const SizedBox(
          width: 5,
        ),
        Text(text,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.black, fontWeight: FontWeight.normal))
      ],
    );
  }
}
