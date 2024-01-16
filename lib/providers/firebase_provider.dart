import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class FirebaseProvider extends ChangeNotifier {
  bool isInitialized = false;
  String? fcmToken;

  FirebaseProvider();

  Future<void> init() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token: $fcmToken");

    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("Missatge rebut");
      debugPrint("${event.data}");
      if (event.notification != null) {
        debugPrint("${event.notification!.title}");
      }
    });

    FirebaseMessaging.instance.subscribeToTopic('proves');
  }
}
