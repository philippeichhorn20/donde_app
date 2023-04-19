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


class Skeleton extends StatefulWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  static List<Widget> pages = [
    HomePage(),
    AddReview(),
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
        PersistentBottomNavBarItem(icon: Icon(Icons.home),activeColorSecondary: Colors.white, activeColorPrimary: Colors.white,inactiveColorSecondary: Colors.transparent, inactiveColorPrimary: Colors.grey,  ),
        PersistentBottomNavBarItem(icon: Icon(Icons.camera_alt, size: 35,),activeColorSecondary: Colors.white, activeColorPrimary: Colors.white,inactiveColorSecondary: Colors.transparent, inactiveColorPrimary: Colors.grey ,  ),
        PersistentBottomNavBarItem(icon: Icon(Icons.group),activeColorSecondary: Colors.white, activeColorPrimary: Colors.white,inactiveColorSecondary: Colors.transparent, inactiveColorPrimary: Colors.grey, ),
      ],
      navBarStyle: NavBarStyle.simple,
      backgroundColor: Colors.black,


      decoration: NavBarDecoration(
        border: Border.fromBorderSide(BorderSide.none),
        colorBehindNavBar: Colors.transparent,
      ),
      hideNavigationBarWhenKeyboardShows: true,
      bottomScreenMargin: 0,
    );
  }
}
