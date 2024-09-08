import 'dart:convert';
import 'package:gozip_seller/config/constants/private_constants.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/userinfo.email",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(
          serviceAccountJson), // use your token
      scopes,
    );

    /// get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    print("-----------token-> ${credentials.accessToken.data}");
    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedUser(
      String deviceToken, String orderId, String title, String body) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloundMessaging =
        'https://fcm.googleapis.com/v1/projects/daprot-bdd89/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'priority': 'high',
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
        },
        'data': {
          'orderId': orderId,
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloundMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("--------Notificaation Sent Successfully----------");
    } else {
      print(
          "-------Failed notification ${response.statusCode}  body ${response.body}---------");
    }
  }
}
