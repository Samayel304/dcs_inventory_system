import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/user/user_bloc.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      drawer: const SafeArea(child: CustomNavigationDrawer()),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Greetings(
              currentDate: currentDate,
              userFirstName: 'Samayel',
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          if (state is ProductsLoading) {
                            return const CustomCircularProgress();
                          }
                          if (state is ProductsLoaded) {
                            final String totalProductCount =
                                state.products.length.toString();
                            return _generateCard(context, 'Number of Products',
                                totalProductCount);
                          } else {
                            return const Center(
                              child: Text('Something went wrong'),
                            );
                          }
                        },
                      ),
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return const CustomCircularProgress();
                          }
                          if (state is UserLoaded) {
                            final String totalUser =
                                state.users.length.toString();
                            return _generateCard(
                                context, 'Number of Users', totalUser);
                          } else {
                            return const Center(
                              child: Text('Something went wrong'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      BlocBuilder<SupplierBloc, SupplierState>(
                        builder: (context, state) {
                          if (state is SupplierLoading) {
                            return const CustomCircularProgress();
                          }
                          if (state is SupplierLoaded) {
                            final String totalSupplier =
                                state.suppliers.length.toString();
                            return _generateCard(
                                context, 'Number of Suppliers', totalSupplier);
                          } else {
                            return const Center(
                              child: Text('Something went wrong'),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Order',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 20, bottom: 20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xEEEBE6E6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _generateOrderDetails(context, '001'),
                              _generateOrderDetails(context, 'Coffee'),
                              _generateOrderDetails(context, 'x10'),
                              _generateOrderDetails(context, 'Pending',
                                  color: Colors.orange),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }

  Text _generateOrderDetails(BuildContext context, String text,
      {Color? color = Colors.black}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline5!.copyWith(color: color),
    );
  }

  Card _generateCard(BuildContext context, String title, String value) {
    double width = MediaQuery.of(context).size.width - 56;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Container(
        width: width / 2,
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class Greetings extends StatelessWidget {
  const Greetings({
    Key? key,
    required this.currentDate,
    required this.userFirstName,
  }) : super(key: key);

  final DateTime currentDate;
  final String userFirstName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello $userFirstName',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          currentDate.formatGreetingsDate(),
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
