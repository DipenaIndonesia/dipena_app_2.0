// import 'package:dipena_full/auth/login.dart';
// import 'package:dipena_full/auth/sign_up.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Intro extends StatefulWidget {

//   @override
//   _IntroState createState() => _IntroState();
// }

// class _IntroState extends State<Intro> {


//   PageController _pageController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();   
//      _pageController = PageController(initialPage: 0);
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                   'assets/images/Intro_Pic_2.jpg',
//                 ),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color.fromRGBO(244, 217, 66, 1).withOpacity(.4),
//                     Color.fromRGBO(244, 217, 66, 1).withOpacity(.4),
//                   ],
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(40),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 95,
//                         right: 95,
//                       ),
//                       child: Image.asset(
//                         'assets/images/Logo_Circle.png',
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'Dipena',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500,
//                             shadows: <Shadow>[
//                               Shadow(
//                                 offset: Offset(2, 2),
//                                 blurRadius: 3,
//                                 color: Colors.black,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         SizedBox(
//                           height: 80,
//                         ),
//                         Text(
//                           'Join With Others',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500,
//                             shadows: <Shadow>[
//                               Shadow(
//                                 offset: Offset(0.5, 0),
//                                 blurRadius: 2,
//                                 color: Color.fromRGBO(244, 217, 66, 1),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             shadows: <Shadow>[
//                               Shadow(
//                                 offset: Offset(1, 0.5),
//                                 blurRadius: 4,
//                                 color: Colors.yellow[800],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(
//                         top: 90,
//                       ),
//                       width: 250,
//                       child: RaisedButton(
//                         elevation: 5,
//                         splashColor: Colors.purpleAccent,
//                         padding: EdgeInsets.all(15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         color: Color.fromRGBO(244, 217, 66, 1),
//                         child: Text(
//                           'SIGN UP',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         onPressed: () async {
//                           var navigationResult = await Navigator.push(
//                             context,
//                             new MaterialPageRoute(
//                               builder: (context) => SignUp(),
//                             ),
//                           );
//                           if (navigationResult == true) {
//                             MaterialPageRoute(
//                               builder: (context) => SignUp(),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(
//                         top: 15,
//                       ),
//                       width: 250,
//                       child: OutlineButton(
//                         highlightElevation: 4,
//                         splashColor: Colors.purpleAccent,
//                         padding: EdgeInsets.all(15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         color: Color.fromRGBO(244, 217, 66, 1),
//                         child: Text(
//                           'LOG IN',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                         borderSide: BorderSide(
//                           color: Color.fromRGBO(244, 217, 66, 1),
//                           width: 4,
//                         ),
//                         onPressed: () async {
//                           var navigationResult = await Navigator.push(
//                             context,
//                             new MaterialPageRoute(
//                               builder: (context) => Login(),
//                             ),
//                           );
//                           if (navigationResult == true) {
//                             MaterialPageRoute(
//                               builder: (context) => Login(),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }