import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';

import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Loader();
            } else if (state is NotificationLoaded) {
              List<NotificationModel> notifications = state.notifications;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  NotificationModel notification = notifications[index];
                  return _NotificationTile(
                    notificationModel: notification,
                  );
                },
              );
            } else {
              return const ErrorScreen();
            }
          },
        ));
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({Key? key, required this.notificationModel})
      : super(key: key);
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    var currentUSerUid = FirebaseAuth.instance.currentUser!.uid;
    bool isRead = notificationModel.readBy.contains(currentUSerUid);

    void readNotification(BuildContext context) {
      if (!isRead) {
        BlocProvider.of<NotificationBloc>(context)
            .add(ReadNotification(notificationModel, context));
      }
    }

    return ListTile(
      onTap: () {
        readNotification(context);
      },
      hoverColor: Colors.grey,
      leading: const Icon(
        Icons.warning_rounded,
        color: Colors.orange,
        size: 30,
      ),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          notificationModel.message,
          style: Theme.of(context).textTheme.headline4!.copyWith(
              fontWeight: FontWeight.normal,
              color: isRead ? Colors.grey : Colors.black),
        ),
        Text(
          timeago.format(notificationModel.dateCreated),
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color:
                  isRead ? Colors.grey : const Color.fromARGB(255, 4, 42, 107)),
        )
      ]),
      trailing: isRead
          ? null
          : const Icon(
              Icons.circle,
              color: Colors.blue,
              size: 13,
            ),
    );
  }
}
