import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daprot_seller/config/routes/routes_manager.dart';
import 'package:daprot_seller/config/theme/theme_manager.dart';
import 'package:daprot_seller/features/screens/orders_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

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

  // String _appBadgeSupported = 'Unknown';
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    print("Handling a background message: ${message.messageId}");

    // Use this method to automatically convert the push data, in case you gonna use our data standard
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    FirebaseMessaging.instance.getToken().then((token) {
      print('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notificationCount++;
      });
      updateBadgeCount(1);

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
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
