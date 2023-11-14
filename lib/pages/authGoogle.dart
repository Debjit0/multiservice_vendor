

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get/route_manager.dart';
import 'package:multiservice_vendor/pages/rootapp.dart';
import 'package:multiservice_vendor/services/services.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //UserCredential userObj = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text("Sign in with Google"),
        onPressed: () {
          Services().signInWithGoogle().then((value) {
            Services().addUserDetailsToFB();
            Get.offAll(RootApp());
          }).catchError((e) {
            Get.snackbar("Error", e);
          });
        },
      )),
    );
  }
}