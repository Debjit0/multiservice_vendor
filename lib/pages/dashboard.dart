import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:multiservice_vendor/Widgets/custom_image_profile.dart';
import 'package:multiservice_vendor/Widgets/recommend_item.dart';
import 'package:multiservice_vendor/pages/authGoogle.dart';
import 'package:multiservice_vendor/theme/color.dart';
import 'package:multiservice_vendor/utils/data.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var profile = "https://avatars.githubusercontent.com/u/86506519?v=4";
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
        SliverToBoxAdapter(child: _buildBody())
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

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text("See All", style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
        SizedBox(height: 10,),
        _buildServices(),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Bookings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text("See All", style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
      ],
    );
  }




  Widget _buildServices() {
    List<Widget> lists = List.generate(recommended.length, (index) {
      //print(allResults[index].id);
      return RecommendItem(
        data: recommended[index],
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }
}
