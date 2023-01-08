import 'package:dcs_inventory_system/bloc/activity_log/activity_log_bloc.dart';
import 'package:dcs_inventory_system/bloc/activity_log_filter/activity_log_filter_bloc.dart';
import 'package:dcs_inventory_system/models/activity_log_model.dart';

import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:dcs_inventory_system/views/widgets/back_app_bar.dart';
import 'package:dcs_inventory_system/views/widgets/loader.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityFilter = context.select(
        (ActivityLogFilterBloc activityLogFilterBloc) =>
            (activityLogFilterBloc.state as ActivityLogFilterLoaded));
    return Scaffold(
        appBar: BackAppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showBottomModal(
                      context,
                      FilterActivityLog(
                          startDate: activityFilter.startDate,
                          endDate: activityFilter.endDate));
                },
                icon: const Icon(Icons.filter_alt))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ActivityLogFilterBloc, ActivityLogFilterState>(
                  builder: (context, state) {
                if (state is ActivityLogFilterLoading) {
                  return const Loader();
                }
                if (state is ActivityLogFilterLoaded) {
                  return ListView.builder(
                    itemCount: state.activityLogs.length,
                    itemBuilder: (context, index) {
                      ActivityLog activityLog = state.activityLogs[index];
                      return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xEEEBE6E6),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(activityLog.activity,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                    Text(
                                        activityLog.dateCreated
                                            .formatDateTime(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal))
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  );
                } else {
                  return const Center(child: Text("Something went wrong"));
                }
              }),
            )
          ],
        ));
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.dateCreated,
  }) : super(key: key);
  final String dateCreated;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(dateCreated,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.black)));
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.activityLog,
  }) : super(key: key);
  final ActivityLog activityLog;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: CircleAvatar(
                  radius: (20),
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(activityLog.user.avatarUrl),
                  ))),
          Expanded(
              flex: 3,
              child: Text(activityLog.activity,
                  style: Theme.of(context).textTheme.headline6)),
        ],
      ),
    ));
  }
}
