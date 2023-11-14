// ignore: unused_import
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Services {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //signout user
  Future<String> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn(scopes: <String>['email']).signOut();
    return 'Successfully Signed Out';
  }

  //signIn User
  Future<UserCredential> signInWithGoogle() async {
    //start the authentication flow
    //shows list of available google accounts
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //obtain auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    //create new Credentials
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  

//add user details to sf
  addUserDetailsToFB() {
    final data = {
      "name": FirebaseAuth.instance.currentUser!.displayName,
      "email": FirebaseAuth.instance.currentUser!.email,
      "profilepic": FirebaseAuth.instance.currentUser!.photoURL,
      "phone": FirebaseAuth.instance.currentUser!.phoneNumber,
      "favourites": [],
    };
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(data);
    //print(user.)
  }

  Future sendMessage(Map<String, dynamic> chatMessageData, String recieverName,
      String senderName, String recieverUid, String senderUid) async {
    List uids = [senderUid, recieverUid];
    uids.sort((a, b) =>
        a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));

    print(uids);
    /*await FirebaseFirestore.instance
        .collection("Chats")
        .doc("Admin_${FirebaseAuth.instance.currentUser!.uid}")
        .update({
      "participants": [uid, "Admin"]
    });*/
    //String firstname = "";
    //getNameStatus().then((value) => firstname = value);
    //print(name);
    //print(senderName);
    await FirebaseFirestore.instance
        .collection("Chats")
        .doc("${uids[0]}_${uids[1]}")
        .collection("Messages")
        .add(chatMessageData);
    await FirebaseFirestore.instance
        .collection("Chats")
        .doc("${uids[0]}_${uids[1]}")
        .set({
      "recentmessage": chatMessageData['message'],
      "recentmessagesender": "${senderName}_${senderUid}",
      "recentmessagetime": chatMessageData['time'].toString(),
      "participants": [
        "${recieverName}_$recieverUid",
        "${senderName}_$senderUid"
      ]
    });
  }
}
