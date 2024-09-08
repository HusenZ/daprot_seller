import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "daprot-bdd89",
      "private_key_id": "939063ce75b025290e12ab994bf65b7645301510",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCnv0pQRiSrSuFm\nhnczONY3AKOamzXr7vV6stRciJJmd+TYDszM4f+r50m0ine/lekhSUr0EbptjBEV\nxrg64uMtIaCXp7yWmGXXJGBMEYMRP08yc5um/aSo5SLG+H38CWlCSxcCAuYRpZAf\n1PXjDeup5QXj4YKDLgy189+pkUEkeeDCO3TMUmoBNIcikaNVvH3TUKqIxfVnbCjC\nYr1Rk8zLvkCJPJyIsyX29vWGNXQQv7fo3C2qvdF1mJ9/PjxaZUaSzwuBbamJ0BB9\nnwii35euRNpm/Y4RQLLC0XtBCB742+peaZSEnwiioJpUhHNZW6n8MbD5RdNRoEId\noL4kXMEbAgMBAAECggEARRCuYSSwHlKDQTolw9In6Jd7xMEYz14gdfdBFiQo2sWM\nVCSrz8NRCA7/OrU0Ho5zYQATOzA9aLMdqbCa06vsyv0oaKhoLjzq2Uyh1U/0fdpq\nGiSdNoECFYPZ8MAI5wdc7i2KeIqG/UcEcwa0glqN5/JinXOQz7/a/eM9+EvU3VYi\nNXUzMDNOe2pdG2kcS41hFilAN0XfyPs2w9tc7RnfmGeNK1injldxyjMwhCeac2M1\nrEAFkLPUH+w/toANHzcjug3xA77ryDIutkxy09OvQ3kF1X7uAwqQ6rf9/AUm2KoM\nCUd2T/dCUyyRgtXfCZIinWwCVU4nbhRmMvIC09dzwQKBgQDTdv00gOsI4ab3H3sT\nxZHHanyFJn0ScAvVr7Y6anxH5oxDNJ+AmSb2B1I6p7+YxrBQI/EE3/n8vQVl3GlP\nJOorAqwcJLXvN0jqDDlu6aa8K43dKOmZdcA3RlCRZB21Ct0Kk4CMuYHbbALYPa0s\ns24i2P174gb/QOzVzW4IjxWdoQKBgQDLE0qxS7svYhcH42EFaPe/1btjwkwB5ZPr\ncNha3HoxCHVwn3/270guD5teWBQ0ukWDANqO3FdrX+lKD6yPobE78R7RGaRZdFAm\n+qtZ3s55SRXVGJ0+X2ch3XnIIor2NoJdGY55/9SQ/SH84Q/5Zah+0jtpItDEVTOw\n21urNvhNOwKBgQC110h9ca6rAIA3WZbYtbhaJzPUu/gpdrh2lJa7PP6KRbKvx/yw\n9QIP5tPLJJ0ZnyHWiFGlw4SQ1Wpi4VqdeDz1p2KhAOCCSKQmv0RUIBAFF97yI1Bd\namhUH98AZ3s0R5c0lQqh+JO2P/diRAc6vUEkLjwr333s2cPPRswsB/6qgQKBgHZY\notHaMZc2kfdt4o/VkXSBqXhEtijw0xiFpgCltqw2osJkoZ2V6zm0rLX5nKTx3Sqw\nZ66T6HpR5dHcepMmBvTI202+pNHhAAkHUq7IMwnptsh+VL0Ruje5K4yf3N4J/EUn\nbKnaltV8P79wpe+Q9/YYrLjjqkiQ4tPxsmWAXoobAoGBAJbgQHfyugWO540sSGtT\neD74Fyrt7Gp58v47QHU6NgUjJqYSHF+wL4akLdP+fKWlFJP6qE2WRw9e7kAGeF6g\nKpvH3hGEXfm1RziaPNVxr5acpd1cVMR88RjutD9zCEZgfTtk/LrUneyahqODnVnl\npRBXwWYABcPAWA9lzD4JMfGx\n-----END PRIVATE KEY-----\n",
      "client_email": "gozipapphusenz@daprot-bdd89.iam.gserviceaccount.com",
      "client_id": "103752545807341267581",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/gozipapphusenz%40daprot-bdd89.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/userinfo.email",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
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
        'notification': {
          'title': title,
          'body': body,
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
