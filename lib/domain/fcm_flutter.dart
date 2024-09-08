import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationApi {
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();
    fmessaging.getToken().then((value) => print('FCM---> Token---> $value'));
  }
}
