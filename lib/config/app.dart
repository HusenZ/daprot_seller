import 'dart:math';

import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/theme_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal(); //private named constructor

  static MyApp instance =
      const MyApp._internal(); // single instance -- singleton

  @override
  State<MyApp> createState() => _MyAppState();

  factory MyApp() => instance; // factory for the class instance
}

class _MyAppState extends State<MyApp> {
  int notificationCount = 0;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotification(RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSetting =
        InitializationSettings(android: androidInitialization);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(1000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      ticker: 'ticker',
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    Future.delayed(
      Duration.zero,
      () => _flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      ),
    );
  }
  // String _appBadgeSupported = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getToken().then((token) {
      print('FCM Token:-->... $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      initLocalNotification(message);
      setState(() {
        notificationCount++;
      });
      showNotification(message);
      updateBadgeCount(1);
    });
  }

  void updateBadgeCount(int count) async {
    try {
      await FlutterAppBadger.updateBadgeCount(1);
    } catch (e) {
      print('Error updating badge count: $e');
    }
  }

  void remove() async {
    try {
      await FlutterAppBadger.removeBadge();
    } catch (e) {
      print('Error updating badge count: $e');
    }
  }

  initPlatformState() async {
    // Check if app badge is supported
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      appBadgeSupported = res ? 'Supported' : 'Not supported';
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }
    print("AppBadge: $appBadgeSupported");
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splashRoute,
          routes: routes,
          theme: getApplicationTheme(),
        );
      },
    );
  }
}
