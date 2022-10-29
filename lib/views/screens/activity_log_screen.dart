import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(),
        body: Column(
          children: [
            Expanded(
              child: GroupedListView(
                elements: ActivityLog.logs,
                groupBy: (activity) => activity.dateCreated,
                groupHeaderBuilder: (activity) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(activity.dateCreated.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.black))),
                itemBuilder: (context, activity) {
                  return _Item(
                    text: activity.activity,
                  );
                },
                shrinkWrap: true,
                //floatingHeader: true,
                useStickyGroupSeparators: true,
              ),
            )
          ],
        ));
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
