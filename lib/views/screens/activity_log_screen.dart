import 'package:dcs_inventory_system/bloc/activity_log/activity_log_bloc.dart';
import 'package:dcs_inventory_system/models/activity_log_model.dart';

import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:dcs_inventory_system/views/widgets/back_app_bar.dart';
import 'package:dcs_inventory_system/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
            /* actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt))
          ], */
            ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ActivityLogBloc, ActivityLogState>(
                  builder: (context, state) {
                if (state is ActivityLogLoading) {
                  return const Loader();
                }
                if (state is ActivityLogLoaded) {
                  return GroupedListView(
                    elements: state.activityLogs,
                    groupBy: (activity) => DateTime(activity.dateCreated.year,
                        activity.dateCreated.month, activity.dateCreated.day),
                    groupHeaderBuilder: (activity) =>
                        _Header(dateCreated: activity.dateCreated.formatDate()),
                    itemBuilder: (context, activityLog) {
                      return _Item(
                        activityLog: activityLog,
                      );
                    },
                    shrinkWrap: true,
                    //floatingHeader: true,
                    useStickyGroupSeparators: true,
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
