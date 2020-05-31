import 'dart:convert';

import 'package:dipena/auth/login.dart';
import 'package:dipena/inside_app/searchPage.dart';
import 'package:dipena/model/post_follow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'profile.dart';
import 'peluang.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:http/http.dart' as http;

class SearchNav extends StatefulWidget {
  
  // final VoidCallback signOutProfile;

  @override
  _SearchNavState createState() => _SearchNavState();
}

class _SearchNavState extends State<SearchNav> {

  // signOutProfile() {
  //   setState(() {
  //     widget.signOutProfile();
  //   });
  // }


  String user_email = "", user_username = "", user_id, location_user_id, user_img;


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_email = preferences.getString("user_email");
      user_username = preferences.getString("user_username");
      location_user_id = preferences.getString("user_id");
      user_img = preferences.getString("user_img");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int _currentIndex = 1;
  final List<Widget> _children = [
    Home(),
    SearchPage(),
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
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //       onPressed: () {
      //         signOut();
      //       },
      //       icon: Icon(Icons.lock_open),
      //     )
      //   ],
      // ),
      // body:
      //  _children[_currentIndex],
      // bottomNavigationBar: TitledBottomNavigationBar(
      //   indicatorColor: Color.fromRGBO(244, 217, 66, 1),
      //   inactiveColor: Colors.black,
      //   activeColor: Color.fromRGBO(244, 217, 66, 1),
      //   onTap: onTappedBar,
      //   currentIndex: _currentIndex,
      //   items: [
          
      //     TitledNavigationBarItem(
      //       title: 'Home',
      //       icon: Icons.home,
      //     ),
      //     TitledNavigationBarItem(
      //       title: 'Peluang',
      //       icon: Icons.explore,
      //     ),
      //     TitledNavigationBarItem(
      //       title: 'Profile',
      //       icon: Icons.person_outline,
      //     ),
      //   ],
      // ),
       body:
       _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Color.fromRGBO(244, 217, 66, 1),
        // indicatorColor: Colors.black,
        // // Color.fromRGBO(244, 217, 66, 1),
        // inactiveColor: Colors.black,
        // activeColor: Colors.black,
        // //  Color.fromRGBO(244, 217, 66, 1),
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem> [
          
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
    ),
    );
  }
}

class NavToProfile extends StatefulWidget {
  @override
  NavToProfileState createState() => NavToProfileState();
}

class NavToProfileState extends State<NavToProfile> {

  String user_email = "", user_username = "", user_id, location_user_id, user_img;


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_email = preferences.getString("user_email");
      user_username = preferences.getString("user_username");
      location_user_id = preferences.getString("user_id");
      user_img = preferences.getString("user_img");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int _currentIndex = 1;
  final List<Widget> _children = [
    Home(),
    Peluang(),
    Profile(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Color.fromRGBO(244, 217, 66, 1),
        // indicatorColor: Colors.black,
        // // Color.fromRGBO(244, 217, 66, 1),
        // inactiveColor: Colors.black,
        // activeColor: Colors.black,
        // //  Color.fromRGBO(244, 217, 66, 1),
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem> [
          
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
    );
  }
}
