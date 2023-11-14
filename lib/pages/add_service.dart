import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_vendor/Widgets/custom_image_profile.dart';
import 'package:multiservice_vendor/Widgets/service_card.dart';
import 'package:multiservice_vendor/pages/authGoogle.dart';
import 'package:multiservice_vendor/theme/color.dart';
import 'package:multiservice_vendor/utils/data.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  var allResults = [];
  var isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    getAllServices().whenComplete(() => setState(
          () {
            isLoading = false;
          },
        ));
    super.initState();
  }

  Future getAllServices() async {
    var propDocuments =
        await FirebaseFirestore.instance.collection("Services").get();
    print("Services Length ${propDocuments.docs.length}");
    allResults = (List.from(propDocuments.docs));
    print(allResults[0]["Name"]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: AppColor.appBgColor,
          pinned: true,
          snap: true,
          floating: true,
          title: _buildHeader(),
        ),
        SliverToBoxAdapter(
            child: isLoading == true ? _buildBodyLoading() : _buildBody())
      ],
    );
  }

  _buildHeader() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello!",
                  style: TextStyle(
                    color: AppColor.darker,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                //name from Google
                Text(
                  FirebaseAuth.instance.currentUser!.displayName != null
                      ? FirebaseAuth.instance.currentUser!.displayName
                          .toString()
                      : "User",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(AuthScreen());
                },
                icon: Icon(Icons.exit_to_app)),
            GestureDetector(
              onTap: () {
                //Get.to(ProfileScreen());
              },
              child: CustomImageProfile(
                profile,
                width: 35,
                height: 35,
                trBackground: true,
                borderColor: AppColor.primary,
                radius: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildBodyLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Text("Select Services to provide"),
        ListView.builder(
          shrinkWrap: true,
          itemCount: allResults.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: ServiceCard(
                  name: allResults[index]["Name"],
                  rate: allResults[index]["Hourly Rates"]),
            );
          },
        ),
      ],
    );
  }
}
