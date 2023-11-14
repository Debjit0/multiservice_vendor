import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:multiservice_vendor/pages/authGoogle.dart';

import 'package:multiservice_vendor/pages/rootapp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //show screen for 2 secs
    Future.delayed(const Duration(seconds: 2), () {
      if (auth.currentUser == null) {
        Get.to(AuthScreen());
      } else {
        //print(auth.currentUser);
        Get.offAll(RootApp());
      }
    });

    return Scaffold(
      body: Center(
          child: FlutterLogo(
        size: 200,
      )),
    );
  }
}
