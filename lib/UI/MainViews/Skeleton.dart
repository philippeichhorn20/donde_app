import 'dart:ui';

import 'package:donde/BackendFunctions/Linking.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/ReviewFlow/DoesSpotExistView.dart';
import 'package:donde/UI/ReviewFlow/AddReview.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/Settings/SearchUserView.dart';
import 'package:donde/UI/Settings/SettingsMain.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:volume_controller/volume_controller.dart';


class Skeleton extends StatefulWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  static List<Widget> pages = [
    HomePage(),
    const AddReview(),
    SearchUserView()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Store.pers_controller = PersistentTabController(initialIndex: 0);
    Linking.handlePotentialLinks(Store.snackbarKey);

  }

  PageController contoller = PageController();
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
      screens: pages,
      controller: Store.pers_controller,
      items: [
        PersistentBottomNavBarItem(icon: const Icon(Icons.home, size: 30),activeColorSecondary: Colors.white, activeColorPrimary: Colors.white,inactiveColorSecondary: Colors.transparent, inactiveColorPrimary: Colors.grey),
        PersistentBottomNavBarItem(icon: const Icon(Icons.add, size: 35,),activeColorSecondary: Colors.black, activeColorPrimary: Colors.white,inactiveColorSecondary: Colors.transparent, inactiveColorPrimary: Colors.grey ,  ),
        PersistentBottomNavBarItem(icon: Stack(
          fit: StackFit.passthrough,
          children: [
            const Icon(Icons.group, size: 30,),
            if(Store.openRequestsCount > 0)
              Positioned(top: 3, right: 0,child: Icon(Icons.circle_sharp, size: 15, color: Colors.red,),)
          ],
        ),activeColorSecondary: Colors.white, activeColorPrimary: Colors.white,inactiveColorSecondary: Colors.transparent, inactiveColorPrimary: Colors.grey, ),
      ],
resizeToAvoidBottomInset: false,
      navBarStyle: NavBarStyle.simple,
      backgroundColor: Colors.black,
      onItemSelected: (value) {
       if(value == 2){
         setState(() {
           Store.openRequestsCount = 0;
         });
       }
      },

      hideNavigationBarWhenKeyboardShows: true,
      bottomScreenMargin: 0,

    );
  }
}
