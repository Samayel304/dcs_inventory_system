import 'package:dcs_inventory_system/bloc/activity_log/activity_log_bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/helper.dart';
import 'package:dcs_inventory_system/views/widgets/back_app_bar.dart';
import 'package:dcs_inventory_system/views/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.filter))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ActivityLogBloc, ActivityLogState>(
                  builder: (context, state) {
                if (state is ActivityLogLoading) {
                  return const CustomCircularProgress();
                }
                if (state is ActivityLogLoaded) {
                  return GroupedListView(
                    elements: state.activityLogs,
                    groupBy: (activity) => activity.dateCreated,
                    groupHeaderBuilder: (activity) =>
                        _Header(dateCreated: activity.dateCreated.formatDate()),
                    itemBuilder: (context, activity) {
                      return _Item(
                        text: activity.activity,
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
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(text));
  }
}
