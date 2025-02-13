// lib/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:assign/firbase_notifi.dart';
import 'package:assign/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseNotificationService notificationService =
      FirebaseNotificationService();
  SplashService splashService = SplashService();
  @override
  void initState() {
    super.initState();
    splashService.isLogin(context);
    notificationService.requestNotificationPermission();
    notificationService.initializeFCM();
    notificationService.getDeviceToken().then(
      (value) {
        print('device token');
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://res.cloudinary.com/dphtfwnx4/image/upload/e_improve,w_300,h_600,c_thumb,g_auto/v1739391173/fer7_szikdh.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'Welcome to MyApp',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
