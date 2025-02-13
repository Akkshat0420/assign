import 'package:flutter/material.dart';
import 'package:assign/firbase_notifi.dart';
//import 'package:flutter_assignment/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:assign/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await  Firebase.initializeApp();

  
  FirebaseNotificationService().requestNotificationPermission();
  FirebaseNotificationService().initializeFCM();
  setupFirebaseMessaging();
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repair Store',
      home: SplashScreen(),
    );
  }
}

class MyFirebaseMessagingService {
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    print("Background Notification: ${message.notification?.title}");
  }
}

void setupFirebaseMessaging() {
  FirebaseMessaging.onBackgroundMessage(
      MyFirebaseMessagingService.onBackgroundMessageHandler);
}
