import 'package:dcs_inventory_system/bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/views/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Loader();
            } else if (state is NotificationLoaded) {
              var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
              List<NotificationModel> notSeenNotifications = state.notifications
                  .where((notification) =>
                      !notification.seenBy.contains(currentUserUid))
                  .toList();
              int notificationCount = notSeenNotifications.length;

              return NotificationBadge(
                notificationCount: notificationCount,
                text: "Notification",
                iconData: Icons.notifications,
                onTap: () {
                  GoRouter.of(context).push('/notification');
                  if (notificationCount != 0) {
                    BlocProvider.of<NotificationBloc>(context)
                        .add(SeenNotification(notSeenNotifications));
                  }
                },
              );
            } else {
              return NotificationBadge(
                text: "Notification",
                iconData: Icons.notifications,
                onTap: () {
                  GoRouter.of(context).push('/notification');
                },
              );
            }
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
