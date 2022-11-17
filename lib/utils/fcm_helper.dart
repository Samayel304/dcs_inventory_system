import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/user_model.dart';

class FcmHelper {
  static initialize(UserRepository userRepository, User user) {
    _requestPermission();
    _getToken(userRepository, user);

    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".....onMessage......");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'androidChannel',
        'androidChannel',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  static _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permissions');
    }
  }

  static _getToken(UserRepository userRepository, User user) async {
    await FirebaseMessaging.instance.getToken().then((token) {
      userRepository.addDeviceToken(user, token!);
    });
  }
}
