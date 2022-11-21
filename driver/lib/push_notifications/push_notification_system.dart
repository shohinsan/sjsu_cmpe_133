import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async {
    // Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("Initial Message: ${remoteMessage.data}");
      }
    });
    // Foreground
    FirebaseMessaging.onMessage.listen((event) {
      print("Message: ${event.data}");
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Message: ${event.data}");
    });
  }
}
