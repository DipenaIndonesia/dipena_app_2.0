import 'package:dipena/inside_app/anotherUserProfileFromHome.dart';
import 'package:dipena/inside_app/commentFromHome.dart';
import 'package:dipena/inside_app/deal.dart';
import 'package:dipena/inside_app/edit_profileFromHome.dart';
import 'package:dipena/inside_app/makedeal.dart';
import 'package:dipena/inside_app/navbar.dart';
import 'package:dipena/inside_app/seeDealsFromHome.dart';
import 'package:dipena/inside_app/testRealTimeChat.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/model/selectPostFollow.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'list_chat.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  int selectedIndex = 0;
  bool followed_status = false;
  String user_id,
      valuee,
      follow_user_one,
      user_username,
      location_country,
      location_city;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      user_username = preferences.getString("user_username");
      follow_user_one = preferences.getString("user_id");
    });
  }

  var loadingg = false;
  final listLokasi = new List<LocationModel>();
  Future<void> _lihatDataLocation() async {
    await getPref();
    listLokasi.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(EditProfileUrl.selectUserLocation, body: {
      "user_id": user_id,
    });
    if (response.contentLength == 2) {
      //   await getPref();
      // final response =
      //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
      //   "user_id": user_id,
      //   "location_country": location_country,
      //   "location_city": location_city,
      //   "location_user_id": user_id
      // });

      // final data = jsonDecode(response.body);
      // int value = data['value'];
      // String message = data['message'];
      // String changeProf = data['changeProf'];
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab =
            new LocationModel(api['location_country'], api['location_city']);
        listLokasi.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  // String show_cat;
  var loading = false;
  final list = new List<PostFollow>();
  Future<void> _lihatDataPostFollow() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.selectPostFollow, body: {
      'user_id': user_id,
    });
    if (response.contentLength == 2) {
      //   await getPref();
      // final response =
      //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
      //   "user_id": user_id,
      //   "location_country": location_country,
      //   "location_city": location_city,
      //   "location_user_id": user_id
      // });

      // final data = jsonDecode(response.body);
      // int value = data['value'];
      // String message = data['message'];
      // String changeProf = data['changeProf'];
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new PostFollow(
          api['post_id'],
          api['post_user_id'],
          api['post_cat_id'],
          api['post_sub_cat_id'],
          api['post_title'],
          api['post_location'],
          api['post_offer'],
          api['post_description'],
          api['post_comment_id'],
          api['post_like_id'],
          api['post_img'],
          api['post_time'],
          api['user_username'],
          api['user_img'],
          api['like_status'],
          api['jumlahKomen'],
          api['jumlahLike'],
          api['block_status'],
        );
        list.add(ab);
      });
      setState(() {
        // for (var i = 0; i < list.length; i++) {
        //   if (list[i].post_cat_id == "1") {
        //     show_cat = "Painter";
        //   } else if (list[i].post_cat_id == "2") {
        //     show_cat = "Designer";
        //   } else if (list[i].post_cat_id == "3") {
        //     show_cat = "Photographer";
        //   } else if (list[i].post_cat_id == "4") {
        //     show_cat = "Others";
        //   }
        // }
        loading = false;
      });
    }
  }

  show_cat(String show_cat) {
    if (show_cat == "1") {
      return "Painter";
    } else if (show_cat == "2") {
      return "Designer";
    } else if (show_cat == "3") {
      return "Photographer";
    } else {
      return "Others";
    }
  }

  // follow() async {
  //   await getPref();
  //   final response = await http
  //       .post("http://dipena.com/flutter/api/following/follow.php", body: {
  //     // "post_cat_id" : post_cat_id,
  //     "user_id": user_id,
  //     "follow_user_one": user_id,
  //     "valuee": valuee,
  //     "follow_user_two": valuee,
  //     // "follow_status": followed,
  //   });
  //   final data = jsonDecode(response.body);
  //   int value = data['value'];
  //   String pesan = data['message'];
  //   if (value == 1) {
  //     print(pesan);
  //     setState(() {
  //       followed = !followed;
  //     });
  //   } else {
  //     print(pesan);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatDataPostFollow();
    _lihatDataLocation();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          // Color.fromRGBO(244, 217, 66, 1),
          child: Icon(Icons.add),
          onPressed: () async {
            var navigationResult = await Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => MakeDeal(),
              ),
            );
          }),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _lihatDataPostFollow,
        key: _refresh,
        child: ListView(
          primary: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                  ),
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal * 395,
                    height: SizeConfig.safeBlockVertical * 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border(
                      //   bottom: BorderSide(
                      //     width: 3,
                      //     color: Color.fromRGBO(244, 217, 66, 1),
                      //   ),
                      // ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 1,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Dipena',
                            style: TextStyle(
                              color: Colors.black,
                              //  Color.fromRGBO(244, 217, 66, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 1,
                              vertical: 5,
                            ),
                            child: IconButton(
                              color: Colors.black,
                              // Color.fromRGBO(244, 217, 66, 1),
                              iconSize: 25,
                              icon: Icon(
                                Icons.message,
                              ),
                              onPressed: () async {
                                var navigationResult = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => ChatList(),
                                  ),
                                );
                                if (navigationResult == true) {
                                  MaterialPageRoute(
                                    builder: (context) => ChatList(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // loading
                //       ? Center(child: CircularProgressIndicator())
                //       :
                list.isEmpty
                    ?
                    //  Center(child: Text("KOSONG"))
                    // Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Container(
                    //         width: MediaQuery.of(context).size.width * 0.8,
                    //         // color: Colors.blue,
                    //         child: Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(top: 15.0),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: <Widget>[
                    //                 // for(var i = 0; i < listLokasi.length; i++)
                    //                 Text(
                    //                     "Dear the one who will\nchange the world",
                    //                     textAlign: TextAlign.center,
                    //                     style: new TextStyle(
                    //                         fontSize: 16.0,
                    //                         color: Colors.black,
                    //                         fontWeight: FontWeight.bold)),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 8.0),
                    //                   child: Text(
                    //                       "Share deals (Designer, Photographer, Painter), or Take deals (whoever you are).",
                    //                       textAlign: TextAlign.center,
                    //                       style: new TextStyle(
                    //                           color: Colors.grey[600])),
                    //                 ),
                    //                 Text(
                    //                     "We need each other in this era where beautiful things will win",
                    //                     textAlign: TextAlign.center,
                    //                     style: new TextStyle(
                    //                         color: Colors.grey[600])),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 3.0),
                    //                   child: Text(
                    //                     "We Believe You",
                    //                     textAlign: TextAlign.center,
                    //                     style: new TextStyle(
                    //                         color: Colors.grey[600],
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: <Widget>[
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           right: 20.0, top: 8.0),
                    //                       child: FlatButton(
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius:
                    //                               new BorderRadius.circular(
                    //                                   18.0),
                    //                           // side: BorderSide(color: Colors.blu)
                    //                         ),
                    //                         color: Colors.black,
                    //                         onPressed: () async {
                    //                           var navigationResult =
                    //                               await Navigator.push(
                    //                             context,
                    //                             new MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   MakeDeal(),
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: Text("Share Deals",
                    //                             style: new TextStyle(
                    //                                 color: Colors.white)),
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding:
                    //                           const EdgeInsets.only(top: 8.0),
                    //                       child: FlatButton(
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius:
                    //                               new BorderRadius.circular(
                    //                                   18.0),
                    //                           // side: BorderSide(color: Colors.blu)
                    //                         ),
                    //                         color: Colors.black,
                    //                         onPressed: () async {
                    //                           var navigationResult =
                    //                               await Navigator.push(
                    //                             context,
                    //                             new MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   NavToProfile(),
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: Text("Take Deals",
                    //                             style: new TextStyle(
                    //                                 color: Colors.white)),
                    //                       ),
                    //                     )
                    //                   ],
                    //                 )
                    //                 // Padding(
                    //                 //   padding: const EdgeInsets.only(top: 8.0),
                    //                 //   child: listLokasi.isEmpty
                    //                 //       ? ListView.builder(
                    //                 //           shrinkWrap: true,
                    //                 //           itemCount: listLokasi.length,
                    //                 //           itemBuilder: (context, i) {
                    //                 //             final b = listLokasi[i];
                    //                 //             return ButtonTheme(
                    //                 //               child: FlatButton(
                    //                 //                 shape: RoundedRectangleBorder(
                    //                 //                   borderRadius:
                    //                 //                       new BorderRadius.circular(
                    //                 //                           18.0),
                    //                 //                   // side: BorderSide(color: Colors.blu)
                    //                 //                 ),
                    //                 //                 color: Colors.black,
                    //                 //                 //  Color.fromRGBO(
                    //                 //                 //     244, 217, 66, 1),
                    //                 //                 onPressed: () {
                    //                 //                   Navigator.of(context).push(
                    //                 //                       MaterialPageRoute(
                    //                 //                           builder: (context) =>
                    //                 //                               EditFromHome(
                    //                 //                                   LocationModel(
                    //                 //                                       location_country,
                    //                 //                                       location_city))));
                    //                 //                 },
                    //                 //                 child: Text("Get Started",
                    //                 //                     style: new TextStyle(
                    //                 //                         color: Colors.white)),
                    //                 //               ),
                    //                 //             );
                    //                 //           },
                    //                 //         )
                    //                 //       : loadingg
                    //                 //           ? Center(
                    //                 //               child:
                    //                 //                   CircularProgressIndicator())
                    //                 //           : ListView.builder(
                    //                 //               shrinkWrap: true,
                    //                 //               itemCount: listLokasi.length,
                    //                 //               itemBuilder: (context, i) {
                    //                 //                 final b = listLokasi[i];
                    //                 //                 return ButtonTheme(
                    //                 //                   child: FlatButton(
                    //                 //                     shape:
                    //                 //                         RoundedRectangleBorder(
                    //                 //                       borderRadius:
                    //                 //                           new BorderRadius
                    //                 //                               .circular(18.0),
                    //                 //                       // side: BorderSide(color: Colors.blu)
                    //                 //                     ),
                    //                 //                     color: Colors.black,
                    //                 //                     //  Color.fromRGBO(
                    //                 //                     //     244, 217, 66, 1),
                    //                 //                     onPressed: () {
                    //                 //                       Navigator.of(context).push(
                    //                 //                           MaterialPageRoute(
                    //                 //                               builder: (context) =>
                    //                 //                                   EditFromHome(
                    //                 //                                       b)));
                    //                 //                     },
                    //                 //                     child: Text("Get Started",
                    //                 //                         style: new TextStyle(
                    //                 //                             color:
                    //                 //                                 Colors.white)),
                    //                 //                   ),
                    //                 //                 );
                    //                 //               },
                    //                 //             ),
                    //                 // ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   )
                    ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // itemCount: list.length,
                        // itemBuilder: (context, i) {
                        // final x = list[i];
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                ),
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 100,
                                  height: SizeConfig.safeBlockVertical * 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CircleAvatar(
                                                  child: ClipOval(
                                                    child: Image(
                                                      width: 50,
                                                      height: 50,
                                                      image: AssetImage(
                                                          "assets/images/Logo_Circle.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // title: InkWell(
                                              // child:
                                              title: Text(
                                                "Dipena",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // onTap: () async {
                                              //   var navigationResult =
                                              //       await Navigator.push(
                                              //     context,
                                              //     new MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           AnotherProfileFromHome(
                                              //               x),
                                              //     ),
                                              //   );
                                              // },
                                              // ),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey[600],
                                                    size: 11,
                                                  ),
                                                  Text(
                                                    // x.post_location,
                                                    "Indonesia",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              width: double.infinity,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/HOW.png"),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment
                                            //           .spaceBetween,
                                            //   children: <Widget>[
                                            //     Row(
                                            //       children: <Widget>[
                                            //         Row(
                                            //           children: <Widget>[
                                            //             // IconButton(
                                            //             //   icon: Icon(
                                            //             //     x.like_status ==
                                            //             //             null
                                            //             //         ? Icons
                                            //             //             .favorite_border
                                            //             //         : Icons
                                            //             //             .favorite,
                                            //             //     color: x.like_status ==
                                            //             //             null
                                            //             //         ? Colors
                                            //             //             .black
                                            //             //         : Color
                                            //             //             .fromRGBO(
                                            //             //                 244,
                                            //             //                 217,
                                            //             //                 66,
                                            //             //                 1),
                                            //             //   ),
                                            //             //   iconSize: 30,
                                            //             //   onPressed:
                                            //             //       () async {
                                            //             //     await getPref();
                                            //             //     final response =
                                            //             //         await http.post(
                                            //             //             LikeUrl
                                            //             //                 .addLike,
                                            //             //             body: {
                                            //             //           // "post_cat_id" : post_cat_id,
                                            //             //           "user_id":
                                            //             //               user_id,
                                            //             //           "post_id":
                                            //             //               x.post_id,
                                            //             //           // "follow_status": followed,
                                            //             //         });
                                            //             //     final data =
                                            //             //         jsonDecode(
                                            //             //             response
                                            //             //                 .body);
                                            //             //     int value = data[
                                            //             //         'value'];
                                            //             //     String pesan =
                                            //             //         data[
                                            //             //             'message'];
                                            //             //     if (value ==
                                            //             //         1) {
                                            //             //       print(pesan);
                                            //             //       setState(() {
                                            //             //         x.like_status !=
                                            //             //             null;
                                            //             //       });
                                            //             //     } else {
                                            //             //       print(pesan);
                                            //             //     }
                                            //             //     // follow();
                                            //             //   },
                                            //             // ),
                                            //             // Text(
                                            //             //   x.jumlahLike ??
                                            //             //       '0',
                                            //             //   style: TextStyle(
                                            //             //     fontSize: 14,
                                            //             //     fontWeight:
                                            //             //         FontWeight
                                            //             //             .w600,
                                            //             //   ),
                                            //             // ),
                                            //           ],
                                            //         ),
                                            //         // SizedBox(
                                            //         //   width: 10,
                                            //         // ),
                                            //         Row(
                                            //           children: <Widget>[
                                            //             IconButton(
                                            //               iconSize: 25,
                                            //               icon: Icon(
                                            //                 FontAwesomeIcons
                                            //                     .comment,
                                            //               ),
                                            //               onPressed:
                                            //                   () async {
                                            //                 var navigationResult =
                                            //                     await Navigator
                                            //                         .push(
                                            //                   context,
                                            //                   new MaterialPageRoute(
                                            //                     builder: (context) =>
                                            //                         CommentFromHome(
                                            //                             x),
                                            //                   ),
                                            //                 );
                                            //               },
                                            //             ),
                                            //             Text(
                                            //               x.jumlahKomen ??
                                            //                   '0',
                                            //               style: TextStyle(
                                            //                 fontSize: 14,
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .w600,
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                            // Row(
                                            //   children: <Widget>[
                                            //     Container(
                                            //       margin: EdgeInsets.only(
                                            //         left: 15,
                                            //         right: 30,
                                            //       ),
                                            //       child: Text(
                                            //         // x.post_cat_id,
                                            //         show_cat(x.post_cat_id),
                                            //         // show_cat,
                                            //         style: TextStyle(
                                            //           fontSize: 18,
                                            //           fontWeight:
                                            //               FontWeight.w700,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 30,
                                                    ),
                                                    child: Text(
                                                      // x.post_title,
                                                      "Painter.Designer.Photographer",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 30,
                                                    ),
                                                    child: Text(
                                                      // x.post_description,
                                                      "Share an oppurtunities here by showing your art and service deals in one post.",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                right: 260,
                                              ),
                                              child: RaisedButton(
                                                splashColor:
                                                    Colors.purpleAccent,
                                                elevation: 2,
                                                padding: EdgeInsets.all(12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                color:
                                                    // Colors.black,
                                                    Color.fromRGBO(
                                                        250, 185, 32, 1),
                                                // Color.fromRGBO(
                                                //     244, 217, 66, 1),
                                                child: Text(
                                                  'See Deals',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // var navigationResult =
                                                  //     await Navigator.push(
                                                  //   context,
                                                  //   new MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         SeeDealsFromHome(
                                                  //             x),
                                                  //   ),
                                                  // );
                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            How()),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 100,
                                  height: SizeConfig.safeBlockVertical * 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CircleAvatar(
                                                  child: ClipOval(
                                                    child: Image(
                                                      width: 50,
                                                      height: 50,
                                                      image: AssetImage(
                                                          "assets/images/Logo_Circle.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // title: InkWell(
                                              // child:
                                              title: Text(
                                                "Dipena",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // onTap: () async {
                                              //   var navigationResult =
                                              //       await Navigator.push(
                                              //     context,
                                              //     new MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           AnotherProfileFromHome(
                                              //               x),
                                              //     ),
                                              //   );
                                              // },
                                              // ),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey[600],
                                                    size: 11,
                                                  ),
                                                  Text(
                                                    // x.post_location,
                                                    "Indonesia",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              width: double.infinity,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/WELCOME.png"),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment
                                            //           .spaceBetween,
                                            //   children: <Widget>[
                                            //     Row(
                                            //       children: <Widget>[
                                            //         Row(
                                            //           children: <Widget>[
                                            //             // IconButton(
                                            //             //   icon: Icon(
                                            //             //     x.like_status ==
                                            //             //             null
                                            //             //         ? Icons
                                            //             //             .favorite_border
                                            //             //         : Icons
                                            //             //             .favorite,
                                            //             //     color: x.like_status ==
                                            //             //             null
                                            //             //         ? Colors
                                            //             //             .black
                                            //             //         : Color
                                            //             //             .fromRGBO(
                                            //             //                 244,
                                            //             //                 217,
                                            //             //                 66,
                                            //             //                 1),
                                            //             //   ),
                                            //             //   iconSize: 30,
                                            //             //   onPressed:
                                            //             //       () async {
                                            //             //     await getPref();
                                            //             //     final response =
                                            //             //         await http.post(
                                            //             //             LikeUrl
                                            //             //                 .addLike,
                                            //             //             body: {
                                            //             //           // "post_cat_id" : post_cat_id,
                                            //             //           "user_id":
                                            //             //               user_id,
                                            //             //           "post_id":
                                            //             //               x.post_id,
                                            //             //           // "follow_status": followed,
                                            //             //         });
                                            //             //     final data =
                                            //             //         jsonDecode(
                                            //             //             response
                                            //             //                 .body);
                                            //             //     int value = data[
                                            //             //         'value'];
                                            //             //     String pesan =
                                            //             //         data[
                                            //             //             'message'];
                                            //             //     if (value ==
                                            //             //         1) {
                                            //             //       print(pesan);
                                            //             //       setState(() {
                                            //             //         x.like_status !=
                                            //             //             null;
                                            //             //       });
                                            //             //     } else {
                                            //             //       print(pesan);
                                            //             //     }
                                            //             //     // follow();
                                            //             //   },
                                            //             // ),
                                            //             // Text(
                                            //             //   x.jumlahLike ??
                                            //             //       '0',
                                            //             //   style: TextStyle(
                                            //             //     fontSize: 14,
                                            //             //     fontWeight:
                                            //             //         FontWeight
                                            //             //             .w600,
                                            //             //   ),
                                            //             // ),
                                            //           ],
                                            //         ),
                                            //         // SizedBox(
                                            //         //   width: 10,
                                            //         // ),
                                            //         Row(
                                            //           children: <Widget>[
                                            //             IconButton(
                                            //               iconSize: 25,
                                            //               icon: Icon(
                                            //                 FontAwesomeIcons
                                            //                     .comment,
                                            //               ),
                                            //               onPressed:
                                            //                   () async {
                                            //                 var navigationResult =
                                            //                     await Navigator
                                            //                         .push(
                                            //                   context,
                                            //                   new MaterialPageRoute(
                                            //                     builder: (context) =>
                                            //                         CommentFromHome(
                                            //                             x),
                                            //                   ),
                                            //                 );
                                            //               },
                                            //             ),
                                            //             Text(
                                            //               x.jumlahKomen ??
                                            //                   '0',
                                            //               style: TextStyle(
                                            //                 fontSize: 14,
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .w600,
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                            // Row(
                                            //   children: <Widget>[
                                            //     Container(
                                            //       margin: EdgeInsets.only(
                                            //         left: 15,
                                            //         right: 30,
                                            //       ),
                                            //       child: Text(
                                            //         // x.post_cat_id,
                                            //         show_cat(x.post_cat_id),
                                            //         // show_cat,
                                            //         style: TextStyle(
                                            //           fontSize: 18,
                                            //           fontWeight:
                                            //               FontWeight.w700,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 30,
                                                    ),
                                                    child: Text(
                                                      // x.post_title,
                                                      "Whoever you are",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                      right: 30,
                                                    ),
                                                    child: Text(
                                                      // x.post_description,
                                                      "Share what you could or Take what you should and change the world",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                right: 260,
                                              ),
                                              child: RaisedButton(
                                                splashColor:
                                                    Colors.purpleAccent,
                                                elevation: 2,
                                                padding: EdgeInsets.all(12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                color:
                                                    //  Colors.black,
                                                    Color.fromRGBO(
                                                        250, 185, 32, 1),
                                                // Color.fromRGBO(
                                                //     244, 217, 66, 1),
                                                child: Text(
                                                  'See Deals',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // var navigationResult =
                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            Welcome()),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final x = list[i];
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Container(
                                      width:
                                          SizeConfig.safeBlockHorizontal * 100,
                                      height:
                                          SizeConfig.safeBlockVertical * 110,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: x.user_img == null
                                                        ? InkWell(
                                                            onTap: () async {
                                                              var navigationResult =
                                                                  await Navigator
                                                                      .push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AnotherProfileFromHome(
                                                                          x),
                                                                ),
                                                              );
                                                            },
                                                            child: placeholder)
                                                        : InkWell(
                                                            onTap: () async {
                                                              var navigationResult =
                                                                  await Navigator
                                                                      .push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AnotherProfileFromHome(
                                                                          x),
                                                                ),
                                                              );
                                                            },
                                                            child: CircleAvatar(
                                                              child: ClipOval(
                                                                child: Image(
                                                                  width: 50,
                                                                  height: 50,
                                                                  image: NetworkImage(
                                                                      ImageUrl.imageProfile +
                                                                          x.user_img),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  title: InkWell(
                                                    child: Text(
                                                      x.user_username,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      var navigationResult =
                                                          await Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (context) =>
                                                              AnotherProfileFromHome(
                                                                  x),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  subtitle: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.grey[600],
                                                        size: 11,
                                                      ),
                                                      Text(
                                                        x.post_location,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  width: double.infinity,
                                                  height: 350,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          ImageUrl.imageContent +
                                                              x.post_img),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            // IconButton(
                                                            //   icon: Icon(
                                                            //     x.like_status ==
                                                            //             null
                                                            //         ? Icons
                                                            //             .favorite_border
                                                            //         : Icons
                                                            //             .favorite,
                                                            //     color: x.like_status ==
                                                            //             null
                                                            //         ? Colors
                                                            //             .black
                                                            //         : Color
                                                            //             .fromRGBO(
                                                            //                 244,
                                                            //                 217,
                                                            //                 66,
                                                            //                 1),
                                                            //   ),
                                                            //   iconSize: 30,
                                                            //   onPressed:
                                                            //       () async {
                                                            //     await getPref();
                                                            //     final response =
                                                            //         await http.post(
                                                            //             LikeUrl
                                                            //                 .addLike,
                                                            //             body: {
                                                            //           // "post_cat_id" : post_cat_id,
                                                            //           "user_id":
                                                            //               user_id,
                                                            //           "post_id":
                                                            //               x.post_id,
                                                            //           // "follow_status": followed,
                                                            //         });
                                                            //     final data =
                                                            //         jsonDecode(
                                                            //             response
                                                            //                 .body);
                                                            //     int value = data[
                                                            //         'value'];
                                                            //     String pesan =
                                                            //         data[
                                                            //             'message'];
                                                            //     if (value ==
                                                            //         1) {
                                                            //       print(pesan);
                                                            //       setState(() {
                                                            //         x.like_status !=
                                                            //             null;
                                                            //       });
                                                            //     } else {
                                                            //       print(pesan);
                                                            //     }
                                                            //     // follow();
                                                            //   },
                                                            // ),
                                                            // Text(
                                                            //   x.jumlahLike ??
                                                            //       '0',
                                                            //   style: TextStyle(
                                                            //     fontSize: 14,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w600,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                        // SizedBox(
                                                        //   width: 10,
                                                        // ),
                                                        Row(
                                                          children: <Widget>[
                                                            IconButton(
                                                              iconSize: 25,
                                                              icon: Icon(
                                                                FontAwesomeIcons
                                                                    .comment,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                var navigationResult =
                                                                    await Navigator
                                                                        .push(
                                                                  context,
                                                                  new MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        CommentFromHome(
                                                                            x),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            Text(
                                                              x.jumlahKomen ??
                                                                  '0',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 30,
                                                      ),
                                                      child: Text(
                                                        // x.post_cat_id,
                                                        show_cat(x.post_cat_id),
                                                        // show_cat,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 30,
                                                        ),
                                                        child: Text(
                                                          x.post_title,
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        margin: EdgeInsets.only(
                                                          left: 15,
                                                          right: 30,
                                                        ),
                                                        child: Text(
                                                          x.post_description,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10,
                                                    right: 260,
                                                  ),
                                                  child: RaisedButton(
                                                    splashColor:
                                                        Colors.purpleAccent,
                                                    elevation: 2,
                                                    padding: EdgeInsets.all(12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    color:
                                                        // Colors.black,
                                                        Color.fromRGBO(
                                                            250, 185, 32, 1),
                                                    // Color.fromRGBO(
                                                    //     244, 217, 66, 1),
                                                    child: Text(
                                                      'SEE DEAL',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      var navigationResult =
                                                          await Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (context) =>
                                                              SeeDealsFromHome(
                                                                  x),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                // new HomeData(
                //   icon: 'assets/images/Profile_Icon_1.png',
                //   username: '$user_username',
                //   post: 'assets/images/Post_1.jpg',
                //   likes: '2,756',
                //   comments: '400',
                //   cat: 'Photography',
                //   title: 'Summer Breeze',
                //   desc: 'A breeze is a light, cool wind. One of the best \n'
                //       'things about being at the beach on a hot \n'
                //       'summer day is feeling the gentle breeze.',
                // ),
                // new HomeData(
                //   icon: 'assets/images/Profile_Icon_2.jpg',
                //   username: '$user_username',
                //   post: 'assets/images/Post_4.jpg',
                //   likes: '1,789',
                //   comments: '231',
                //   cat: 'Design',
                //   title: 'Los Angeles',
                //   desc: 'An avant-garde movement music characterized\n'
                //       'by the repetition of very short phrases which\n'
                //       'change gradually, producing a hypnotic effect.',
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class HomeData extends StatelessWidget {
//   HomeData({
//     this.icon,
//     this.username,
//     this.post,
//     this.likes,
//     this.comments,
//     this.title,
//     this.desc,
//     this.cat,
//   });

//   final String icon;
//   final String username;
//   final String post;
//   final String likes;
//   final String comments;
//   final String title;
//   final String desc;
//   final String cat;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 10,
//           ),
//           child: Container(
//             width: SizeConfig.safeBlockHorizontal * 100,
//             height: SizeConfig.safeBlockVertical * 105,
//             decoration: BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 2,
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       ListTile(
//                         leading: Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                           ),
//                           child: CircleAvatar(
//                             child: ClipOval(
//                               child: Image(
//                                 width: 50,
//                                 height: 50,
//                                 image: AssetImage(
//                                   icon,
//                                 ),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           username,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.all(10),
//                         width: double.infinity,
//                         height: 350,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(
//                               post,
//                             ),
//                             fit: BoxFit.fitWidth,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Row(
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   LikeTwo(),
//                                   Text(
//                                     likes,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Row(
//                                 children: <Widget>[
//                                   IconButton(
//                                     iconSize: 25,
//                                     icon: Icon(
//                                       FontAwesomeIcons.comment,
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                   Text(
//                                     comments,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.only(
//                               left: 15,
//                               right: 30,
//                             ),
//                             child: Text(
//                               cat,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           top: 10,
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(
//                                 left: 15,
//                                 right: 30,
//                               ),
//                               child: Text(
//                                 title,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           top: 10,
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.only(
//                                 left: 15,
//                                 right: 30,
//                               ),
//                               child: Text(
//                                 desc,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           top: 10,
//                           right: 260,
//                         ),
//                         child: RaisedButton(
//                           splashColor: Colors.purpleAccent,
//                           elevation: 2,
//                           padding: EdgeInsets.all(12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           color: Color.fromRGBO(244, 217, 66, 1),
//                           child: Text(
//                             'SEE DEAL',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           onPressed: () {},
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class LikeTwo extends StatefulWidget {
  @override
  _LikeTwoState createState() => _LikeTwoState();
}

class _LikeTwoState extends State<LikeTwo> {
  bool liked = false;

  _pressed() {
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Color.fromRGBO(244, 217, 66, 1) : Colors.black,
            ),
            iconSize: 30,
            onPressed: () => _pressed(),
          ),
        ],
      ),
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemCount: list.length,
                // itemBuilder: (context, i) {
                //   final x = list[i];
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                          width: SizeConfig.safeBlockHorizontal * 100,
                          height: SizeConfig.safeBlockVertical * 36,
                          child: Image.asset("assets/images/WELCOME.png")),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: ClipOval(
                          child: Material(
                            color: Colors.white,
                            // Color.fromRGBO(244, 217, 66, 1),
                            child: InkWell(
                              splashColor: Colors.purpleAccent,
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  color: Colors.black,
                                  icon: Icon(
                                    Icons.arrow_back,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 230,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 30,
                                  right: 30,
                                  left: 20,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            child: ClipOval(
                                              child: Image(
                                                  width: 50,
                                                  height: 50,
                                                  image: AssetImage(
                                                      "assets/images/Logo_Circle.png")),
                                            ),
                                          )),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            // x.user_username,
                                            "Dipena",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 25,
                                        left: 10,
                                      ),
                                      child: Container(
                                        width: 450,
                                        height: 2,
                                        color: Color.fromRGBO(244, 217, 66, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        // x.post_title,
                                        "Whoever you are",
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        // x.post_description,
                                        "Share what you could or Take what you should and change the world",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  right: 285,
                                ),
                                child: Container(
                                  color: Color.fromRGBO(244, 217, 66, 1),
                                  width: 50,
                                  height: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Service Deals',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        // x.post_offer,
                                        "This post will be gone once your following user has posted. Go find something here!",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     top: 10,
                              //     left: 30,
                              //   ),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Text(
                              //         '• Currently available for projects, \n'
                              //         'not contracts',
                              //         style: TextStyle(
                              //           fontSize: 18,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     top: 10,
                              //     left: 30,
                              //   ),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Text(
                              //         '• Have 4 people as my art team for you',
                              //         style: TextStyle(
                              //           fontSize: 18,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                ),
                                child: SizedBox(
                                  width: 350,
                                  height: 50,
                                  child: RaisedButton(
                                    splashColor: Colors.purpleAccent,
                                    elevation: 2,
                                    padding: EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Color.fromRGBO(250, 185, 32, 1),
                                    // Color.fromRGBO(
                                    //     244, 217, 66, 1),
                                    child: Text(
                                      'Take Deals',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      // submit();
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => ChatHome()
                                            // NavToProfile(),
                                            ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class How extends StatefulWidget {
  @override
  _HowState createState() => _HowState();
}

class _HowState extends State<How> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemCount: list.length,
                // itemBuilder: (context, i) {
                //   final x = list[i];
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                          width: SizeConfig.safeBlockHorizontal * 100,
                          height: SizeConfig.safeBlockVertical * 36,
                          child: Image.asset("assets/images/HOW.png")),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: ClipOval(
                          child: Material(
                            color: Colors.white,
                            // Color.fromRGBO(244, 217, 66, 1),
                            child: InkWell(
                              splashColor: Colors.purpleAccent,
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  color: Colors.black,
                                  icon: Icon(
                                    Icons.arrow_back,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 230,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 30,
                                  right: 30,
                                  left: 20,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            child: ClipOval(
                                              child: Image(
                                                  width: 50,
                                                  height: 50,
                                                  image: AssetImage(
                                                      "assets/images/Logo_Circle.png")),
                                            ),
                                          )),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            // x.user_username,
                                            "Dipena",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 25,
                                        left: 10,
                                      ),
                                      child: Container(
                                        width: 450,
                                        height: 2,
                                        color: Color.fromRGBO(244, 217, 66, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        // x.post_title,
                                        "Painter.Designer.Photographer",
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        // x.post_description,
                                        "Share an oppurtunities here by showing your art and service deals in one post.",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  right: 285,
                                ),
                                child: Container(
                                  color: Color.fromRGBO(244, 217, 66, 1),
                                  width: 50,
                                  height: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Service Deals :',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        // x.post_offer,
                                        // "Put your service here. Millions of people need you but they don't see you.",
                                        // "Your services/skills are matter for everyone. Let other knows about your service here so everyone can take deals on you and work for something big!.",
                                        "Let others know about your service here so everyone can take deals on you and work for something big!",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     top: 10,
                              //     left: 30,
                              //   ),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Text(
                              //         '• Currently available for projects, \n'
                              //         'not contracts',
                              //         style: TextStyle(
                              //           fontSize: 18,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     top: 10,
                              //     left: 30,
                              //   ),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Text(
                              //         '• Have 4 people as my art team for you',
                              //         style: TextStyle(
                              //           fontSize: 18,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                ),
                                child: SizedBox(
                                  width: 350,
                                  height: 50,
                                  child: RaisedButton(
                                    splashColor: Colors.purpleAccent,
                                    elevation: 2,
                                    padding: EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Color.fromRGBO(250, 185, 32, 1),
                                    // Color.fromRGBO(
                                    //     244, 217, 66, 1),
                                    child: Text(
                                      'Take Deals',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      // submit();
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => ChatHome(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshChat =
      GlobalKey<RefreshIndicatorState>();

  final _key = new GlobalKey<FormState>();

  TextEditingController txtChat = TextEditingController();

  String user_id, chat_content;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
    });
  }

  // submit() async {
  //   if (_imageFile == null) {
  //     await getPref();
  //     final response = await http
  //         .post("https://dipena.com/flutter/api/chat/sendMessage.php", body: {
  //       "user_id": user_id,
  //       "post_user_id": widget.model.post_user_id,
  //       "chat_content": chat_content,
  //     });
  //     final data = jsonDecode(response.body);
  //     int value = data['value'];
  //     String pesan = data['message'];
  //     if (value == 1) {
  //       print(pesan);
  //       setState(() {
  //         txtChat.clear();
  //       });
  //     } else {
  //       print(pesan);
  //     }
  //   }
  //   try {
  //     var stream =
  //         http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
  //     var length = await _imageFile.length();
  //     var uri = Uri.parse(
  //         "https://dipena.com/flutter/api/chat/sendMessageWithImage.php");
  //     final request = http.MultipartRequest("POST", uri);
  //     request.fields['user_id'] = user_id;
  //     request.fields['post_user_id'] = widget.model.post_user_id;
  //     request.fields['chat_content'] = chat_content;

  //     request.files.add(http.MultipartFile("chat_img", stream, length,
  //         filename: path.basename(_imageFile.path)));
  //     var response = await request.send();
  //     final respStr = await response.stream.bytesToString();
  //     if (response.statusCode > 2) {
  //       final data = jsonDecode(respStr);
  //       String img = data['img'];
  //       print("Image uploaded");
  //       print(img);
  //       setState(() {
  //         txtChat.clear();
  //         _imageFile = null;
  //       });
  //     } else {
  //       print("Image failed to be upload");
  //     }
  //   } catch (e) {
  //     debugPrint("Error $e");
  //   }
  // }

  // var loading = false;
  // final list = new List<ChatContent>();
  // Future<void> _chatContent() async {
  //   await getPref();
  //   list.clear();
  //   setState(() {
  //     _messages.clear();
  //     loading = true;
  //   });
  //   final response = await http
  //       .post("https://dipena.com/flutter/api/chat/selectChatOne.php", body: {
  //     "user_id": user_id,
  //     "post_user_id": widget.model.post_user_id,
  //   });

  //   if (response.contentLength == 2) {
  //     //   await getPref();
  //     // final response =
  //     //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
  //     //   "user_id": user_id,
  //     //   "location_country": location_country,
  //     //   "location_city": location_city,
  //     //   "location_user_id": user_id
  //     // });

  //     // final data = jsonDecode(response.body);
  //     // int value = data['value'];
  //     // String message = data['message'];
  //     // String changeProf = data['changeProf'];
  //   } else {
  //     final data = jsonDecode(response.body);
  //     data.forEach((api) {
  //       final ab = new ChatContent(
  //           api['chat_id'],
  //           api['chat_user_one'],
  //           api['chat_user_two'],
  //           api['chat_content'],
  //           api['user_username'],
  //           api['user_img']);
  //       list.add(ab);
  //     });
  //     setState(() {
  //       _messages.clear();
  //       loading = false;
  //     });
  //   }
  // }

  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmit(String text) {
    txtChat.clear();
    ChatMessage message = new ChatMessage(text: text);
    setState(() {
      _messages.insert(0, message);
    });
  }

  // check() {
  //   final form = _key.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     submit();
  //   }
  // }

  void addValue() {
    // if(list.insert == true){
    setState(() {
      // counter++;
      //  print("nambah");
      // list[i]
      _refresh.currentState.show();
      // _messages.clear();
    });
    // }
  }

  // Timer timer;
  // int counter = 0;

  // TapGestureRecognizer _tapGallery;
  // TapGestureRecognizer _tapCamera;

  @override
  void initState() {
    // setState(() {
    //
    //   new Timer.periodic(oneSecond, (Timer t) => setState(() {}));
    // });
    // const oneSecond = const Duration(seconds: 1);
    // new Timer.periodic(oneSecond, (Timer t) => setState((){}));
    // TODO: implement initState
    // timer =
    //     Timer.periodic(Duration(milliseconds: 250), (Timer t) => addValue());
    // super.initState();
    // _tapGallery = new TapGestureRecognizer()..onTap = () => _pilihCamera();
    // _tapCamera = new TapGestureRecognizer()..onTap = () => _pilihGallery();
    getPref();
    // _postsController = new StreamController();
    // loadPosts();
    // _chatContent();
    // _chatContentTwo();
  }

  @override
  void dispose() {
    // _tapGallery.dispose();
    // _tapCamera.dispose();
    // timer?.cancel();
    super.dispose();
  }

  // File _imageFile;

  // _pilihGallery() async {
  //   var image = await ImagePicker.pickImage(
  //       source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

  // _pilihCamera() async {
  //   var image = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

  // Widget _popUpGallery(BuildContext context) {
  //   return new AlertDialog(
  //     title: Text("Choose Method"),
  //     actions: <Widget>[
  //       FlatButton(
  //           onPressed: () {
  //             _pilihGallery();
  //           },
  //           child: Text("Gallery")),
  //       FlatButton(
  //           onPressed: () {
  //             _pilihCamera();
  //           },
  //           child: Text("Camera")),
  //     ],
  //   );
  // }

  Widget _chatfield() {
    var placeholder = Container(
      width: 20,
      height: 20,
      child: Image.asset('./img/placeholder.png'),
    );
    return Form(
      key: _key,
      // child: Positioned(
      //   bottom: 0,
      //   left: 0,
      //   width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(-2, 0),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.black,
              ),
              onPressed: () {},
            ),

            // InkWell(
            //   onTap: () {
            //     AlertDialog(
            //       title: Text("Choose Method"),
            //       actions: <Widget>[
            //         FlatButton(
            //             onPressed: () {
            //               _pilihGallery();
            //             },
            //             child: Text("Gallery")),
            //         FlatButton(
            //             onPressed: () {
            //               _pilihCamera();
            //             },
            //             child: Text("Camera")),
            //       ],
            //     );
            //   },
            //   child: _imageFile == null
            //         ? Icon(
            //             Icons.image,
            //             color: Colors.black,
            //           )
            //         : Image.file(_imageFile),
            //   ),
            Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
            ),
            Flexible(
              child: TextFormField(
                controller: txtChat,
                onFieldSubmitted: _handleSubmit,
                keyboardType: TextInputType.text,
                onSaved: (e) => chat_content = e,
                decoration: InputDecoration(
                  hintText: 'Enter Message',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                // check();
                _handleSubmit(txtChat.text);
              },
            ),
          ],
        ),
      ),
    );
    // );
  }

  // StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  // int count = 1;

  // Future fetchPost() async {
  //   await getPref();
  //   final response = await http
  //       .post('https://dipena.com/flutter/api/chat/selectChatOne.php', body: {
  //     "user_id": user_id,
  //     "post_user_id": widget.model.post_user_id,
  //   });

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load post');
  //   }
  // }

  // loadPosts() async {
  //   fetchPost().then((res) async {
  //     _postsController.add(res);
  //     return res;
  //   });
  // }

  // Future<Null> _handleRefresh() async {
  //   count++;
  //   print(count);
  //   fetchPost().then((res) async {
  //     _postsController.add(res);
  //     // showSnack();
  //     return null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          centerTitle: true,
          elevation: 3,
          backgroundColor: Color.fromRGBO(244, 217, 66, 1),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/Logo_Circle.png"),
                  backgroundColor: Colors.grey[200],
                  minRadius: 30,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Dipena",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body:
          // Visibility(
          //    visible: visible,
          //     child:
          Container(
        // color: Colors.white,
        // backgroundColor: Colors.white,
        // Function(ScrollNotification:)
        // notificationPredicate: Notification,
        // onRefresh: _handleRefresh,
        // key: _refresh,
        child: Column(
          children: <Widget>[
            // Flexible(
            //   child: ListView.builder(
            //     itemBuilder: (BuildContext context, int index) => _makeElement(index),
            //     )
            // ),
            // Container(
            // color: Colors.white,
            // Flexible(
            //   // children: <Widget>[
            //   child:
            //       //  loading
            //       //     ? Center(child: CircularProgressIndicator())
            //       //     :
            //       list.isEmpty
            //           ? Center(
            //               child: Text("CHAT KOSONG"),
            //             )
            //           :
            //           // : listTwo.isEmpty ?

            //           // Center(child: Text("CHAT KOSONG"),) :
            //           ListView.builder(
            //               reverse: true,
            //               //  primary: true,
            //               //     shrinkWrap: true,
            //               //     physics: const NeverScrollableScrollPhysics(),
            //               itemCount: list.length,
            //               itemBuilder: (context, i) {
            //                 final x = list[i];
            //                 // final b = listTwo[i];
            //                 return Container(
            //                   // onRefresh: _chatContent,
            //                   // key: _refreshChat,
            //                   child: loading
            //                       ? Center(child: CircularProgressIndicator())
            //                       : Padding(
            //                           padding:
            //                               EdgeInsets.only(left: 10, right: 10),
            //                           child: Column(
            //                             //           shrinkWrap: true,
            //                             // physics: const NeverScrollableScrollPhysics(),
            //                             children: <Widget>[
            //                               // for (var i = 0; i < list.length; i++)

            //                               // Text(
            //                               //   'Today',
            //                               //   style: TextStyle(
            //                               //     color: Colors.grey,
            //                               //     fontSize: 12,
            //                               //   ),
            //                               // ),
            //                               // list[i].chat_user_one == user_id
            //                               //     ? Bubble(
            //                               //         message:
            //                               //             list[i].chat_content,
            //                               //         isMe: true,
            //                               //       )
            //                               //     : Bubble(
            //                               //         message:
            //                               //             list[i].chat_content,
            //                               //         isMe: false,
            //                               //       )
            //                               x.chat_user_one == user_id
            //                                   ? Bubble(
            //                                       message: x.chat_content,
            //                                       isMe: true,
            //                                     )
            //                                   : Bubble(
            //                                       message: x.chat_content,
            //                                       isMe: false,
            //                                     ),
            //                               // for(var u = 0; u < listTwo.length; u++)
            //                               // Bubble(
            //                               //   message: 'Apakah lukisan ini di jual?',
            //                               //   isMe: true,
            //                               // ),
            //                               // Text(
            //                               //   'Dec 15, 2019',
            //                               //   style: TextStyle(
            //                               //     color: Colors.grey,
            //                               //     fontSize: 12,
            //                               //   ),
            //                               // ),
            //                               // Bubble(
            //                               //   message: listTwo[u].chat_content,
            //                               //   isMe: false,
            //                               // ),
            //                               // Bubble(
            //                               //   message: 'Iya, kami menjualnya',
            //                               //   isMe: false,
            //                               // ),
            //                             ],
            //                           ),
            //                         ),
            //                   // )
            //                 );
            //               }),
            // ),
            // Flexible(
            //  Visibility(
            //    visible: true,
            //               child:
            // RefreshIndicator(
            //   onRefresh: _handleRefresh,
            //   key: _refresh,
            //   child: Container(),
            // ),
            Flexible(
              child: ListView(
                reverse: true,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        // post["chat_user_one"] == user_id
                        //     ? Bubble(
                        //         message: post["chat_content"],
                        //         isMe: true,
                        //       )
                        //     : Bubble(
                        //         message: post["chat_content"],
                        //         isMe: false,
                        //       ),
                        Bubble(
                          message: "Hay! Love what you’re doing and i want to talk further more about the deal.",
                          isMe: true,
                        ),
                        Bubble(
                          message: "This is what happen when press the “Take Deal” button. We bring you closer to every opportunity.",
                          isMe: false,
                        )
                        // Text("Gk ada gambar ")
                        //                     Bubble(
                        //                       message: post[
                        //                           "chat_content"],
                        //                       isMe: true,
                        //                     )
                        //                   ],
                        //                 )
                        //               : Column(
                        //                   children: <Widget>[
                        //                     Image.network(ImageUrl
                        //                             .imageChat+
                        //                         post[
                        //                             'chat_img']),
                        //                     Bubble(
                        //                       message: post[
                        //                           "chat_content"],
                        //                       isMe: false,
                        //                     ),
                        //                   ],
                        //                 )
                        //         ],
                        //       )

                        //  Bubble(
                        //             message:
                        //                 post["chat_content"],
                        //             isMe: false,
                        //           )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //  ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
            // Text(counter.toString()),

            // ),
            Container(child: _chatfield())
          ],
        ),
      ),
      // ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return ListView(
      // primary: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          padding: isMe
              ? EdgeInsets.only(
                  left: 40,
                )
              : EdgeInsets.only(
                  right: 40,
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Color.fromRGBO(244, 217, 66, 1)
                          : Colors.grey[300],
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(0),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message,
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ChatContent {
  final String chat_id;
  final String chat_user_one;
  final String chat_user_two;
  final String chat_content;
  final String user_username;
  final String user_img;

  ChatContent.fromJsonMap(Map map)
      : chat_id = map['chat_id'],
        chat_user_one = map['chat_user_one'],
        chat_user_two = map['chat_user_two'],
        chat_content = map['chat_content'],
        user_username = map['user_username'],
        user_img = map['user_img'];
}
