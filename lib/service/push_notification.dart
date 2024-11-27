import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging msg = FirebaseMessaging.instance;

  static Future<void> init() async {
    // Request notification permissions
    await msg.requestPermission();

    // Get the device token
    String? token = await msg.getToken();
    log(token ?? 'null');

    // Uncomment the following if you have a handler for background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  //Example handler for background messages
  static Future<void> handleBackgroundMessage(RemoteMessage msg) async {
    await Firebase.initializeApp();
    log(msg.notification?.title ?? 'null');
  }
}
