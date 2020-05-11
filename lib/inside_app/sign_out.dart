// import 'package:flutter/material.dart';
// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainMenu extends StatefulWidget {
//   final VoidCallback signOut;

//   MainMenu(this.signOut);
          
//   @override
//   _MainMenuState createState() => _MainMenuState();
// }

// class _MainMenuState extends State<MainMenu> {
//   signOut() {
//     setState(() {
//       widget.signOut();
//     });
//   }

//   int currentIndex = 0;
//   String selectedIndex = 'TAB: 0';

//   String email = "", name = "", id = "";
//   TabController tabController;

//   getPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       id = preferences.getString("id");
//       email = preferences.getString("email");
//       name = preferences.getString("name");
//     });
//     print("id" + id);
//     print("user" + email);
//     print("name" + name);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getPref();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var bottomNavyBar = BottomNavyBar(
//         backgroundColor: Colors.black,
//         iconSize: 30.0,
// //        iconSize: MediaQuery.of(context).size.height * .60,
//         selectedIndex: currentIndex,
//         onItemSelected: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//           selectedIndex = 'TAB: $currentIndex';
// //            print(selectedIndex);
//           reds(selectedIndex);
//         },

//         items: [
//           BottomNavyBarItem(
//               icon: Icon(Icons.home),
//               title: Text('Home'),
//               activeColor: Color(0xFFf7d426)),
//           BottomNavyBarItem(
//               icon: Icon(Icons.view_list),
//               title: Text('List'),
//               activeColor: Color(0xFFf7d426)),
//           BottomNavyBarItem(
//               icon: Icon(Icons.person),
//               title: Text('Profile'),
//               activeColor: Color(0xFFf7d426)),
//         ],
//       );
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               signOut();
//             },
//             icon: Icon(Icons.lock_open),
//           )
//         ],
//       ),
//       body: Center(
//         child: Text(
//           "WelCome",
//           style: TextStyle(fontSize: 30.0, color: Colors.blue),
//         ),
//       ),
//       bottomNavigationBar: bottomNavyBar,
//     );
//   }

//   //  Action on Bottom Bar Press
//   void reds(selectedIndex) {
// //    print(selectedIndex);

//     switch (selectedIndex) {
//       case "TAB: 0":
//         {
//           callToast("Tab 0");
//         }
//         break;

//       case "TAB: 1":
//         {
//           callToast("Tab 1");
//         }
//         break;

//       case "TAB: 2":
//         {
//           callToast("Tab 2");
//         }
//         break;
//     }
//   }

//   // callToast(String msg) {
//   //   Fluttertoast.showToast(
//   //       msg: "$msg",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       gravity: ToastGravity.BOTTOM,
//   //       timeInSecForIos: 1,
//   //       backgroundColor: Colors.red,
//   //       textColor: Colors.white,
//   //       fontSize: 16.0);
//   // }
// }