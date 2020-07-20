import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dipena/inside_app/add/add_post.dart';
import 'package:dipena/inside_app/explore/explore_page.dart';
import 'package:dipena/inside_app/home/homepage.dart';
import 'package:dipena/inside_app/notification/notif_page.dart';
import 'package:dipena/inside_app/profile/profile_page.dart';
import 'package:flutter/material.dart';

// void main() => runApp(NavBar());

class NavBar extends StatefulWidget {
  final VoidCallback signOut;
  // final String user_img;

  NavBar(this.signOut);
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ExplorePage(),
    AddPost(),
    Notifications(),
    Profile(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: buildCustomNavigationBar(),
      ),
    );
  }

  CustomNavigationBar buildCustomNavigationBar() {
    return CustomNavigationBar(
        scaleFactor: 0.4,
        backgroundColor: Colors.white,
        selectedColor: Colors.black,
        unSelectedColor: new Color(0xFF7F8C8D),
        strokeColor: new Color(0xFFF39C12),
        currentIndex: _currentIndex,
        onTap: onTappedBar,
        items: [
          CustomNavigationBarItem(icon: Icons.home),
          CustomNavigationBarItem(icon: Icons.explore),
          CustomNavigationBarItem(icon: Icons.add_circle),
          CustomNavigationBarItem(icon: Icons.notifications),
          CustomNavigationBarItem(icon: Icons.person),
        ]);
  }
}
