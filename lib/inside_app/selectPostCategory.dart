import 'dart:convert';

import 'package:dipena/inside_app/anotherUserProfile.dart';
import 'package:dipena/inside_app/makedeal.dart';
import 'package:dipena/inside_app/profile.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/model/moreButton.dart';
import 'package:dipena/model/navigateCat.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/model/post_follow.dart';
import 'package:dipena/url.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'comment.dart';
import 'deal.dart';
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

class SelectPostCat extends StatefulWidget {
  final Category model;
  SelectPostCat(this.model);
  @override
  _SelectPostCatState createState() => _SelectPostCatState();
}

class _SelectPostCatState extends State<SelectPostCat> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  int selectedIndex = 0;
  bool followed_status = false;
  bool liked = false;
  String user_id, valuee, follow_user_one;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      follow_user_one = preferences.getString("user_id");
    });
  }

  final List<String> categories = [
    'Art',
    'Design',
    'Photography',
    'Others',
    // 'Brand',
  ];

  List<String> category = ['Art', 'Design', 'Photography', 'Brand'];
  String _category = 'Art';

  // static List<Category> getCategories() {
  //   return <Category>[
  //     Category(
  //       1,
  //       'Art',
  //     ),
  //     Category(
  //       2,
  //       'Design',
  //     ),
  //     Category(
  //       3,
  //       'Photography',
  //     ),
  //     Category(
  //       4,
  //       'Brand',
  //     ),
  //   ];
  // }
  List<Category> categori = [
    Category(
      '1',
      'Art',
    ),
    Category(
      '2',
      'Design',
    ),
    Category(
      '3',
      'Photography',
    ),
    Category(
      '4',
      'Brand',
    ),
  ];

  var loading = false;
  final list = new List<PostContent>();
  Future<void> _lihatDataPost() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.selectPostCat, body: {
      "user_id": user_id,
      "post_cat_id": widget.model.id,
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
        final ab = new PostContent(
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
          api['follow_status'],
          api['like_status'],
          api['jumlahKomen'],
          api['jumlahLike'],
          api['like_status_user'],
          api['follow_status_user'],
          api['block_status'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
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
    super.initState();
    getPref();
    _lihatDataPost();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    SizeConfig().init(context);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.black,
      //     // Color.fromRGBO(244, 217, 66, 1),
      //     child: Icon(Icons.add),
      //     onPressed: () async {
      //       var navigationResult = await Navigator.push(
      //         context,
      //         new MaterialPageRoute(
      //           builder: (context) => MakeDeal(),
      //         ),
      //       );
      //     }),
      //     appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(62),
      //   child: AppBar(
      //     centerTitle: true,
      //     elevation: 3,
      //     backgroundColor: Color.fromRGBO(244, 217, 66, 1),
      //     leading: IconButton(
      //       icon: Icon(
      //         Icons.arrow_back,
      //         size: 25,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context, true);
      //       },
      //     ),
      //     title: Row(
      //       children: <Widget>[
      //         // Container(
      //         //   width: 40,
      //         //   height: 40,
      //         //   margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
      //         //   child: widget.model.user_img == null ?
      //         //   placeholder :
      //         //    CircleAvatar(
      //         //     backgroundImage: NetworkImage(
      //         //         'https://dipena.com/flutter/image_profile/' +
      //         //             widget.model.user_img),
      //         //     backgroundColor: Colors.grey[200],
      //         //     minRadius: 30,
      //         //   ),
      //         // ),
      //         // Column(
      //         //   mainAxisAlignment: MainAxisAlignment.center,
      //         //   crossAxisAlignment: CrossAxisAlignment.start,
      //         //   children: <Widget>[
      //         //     Text(
      //         //       widget.model.user_username,
      //         //       style: TextStyle(
      //         //         color: Colors.white,
      //         //       ),
      //         //     ),
      //             Text(
      //               widget.model.name,
      //               style: TextStyle(
      //                 color: Colors.black,
      //                 fontSize: 13,
      //               ),
      //             ),
      //         //     )
      //         //   ],
      //         // )
      //       ],
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              title: new Text(
                widget.model.name,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: RefreshIndicator(
              onRefresh: _lihatDataPost,
              key: _refresh,
              child: ListView(
                primary: true,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                        ),
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 395,
                          height: SizeConfig.safeBlockVertical * 10,
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   border: Border(
                          //     bottom: BorderSide(
                          //       width: 3,
                          //       color: Color.fromRGBO(244, 217, 66, 1),
                          //     ),
                          //   ),
                          // ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: 1,
                              // left: 15,
                              right: 15,
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // IconButton(
                                //     color: Colors.black,
                                //     // Color.fromRGBO(244, 217, 66, 1),
                                //     iconSize: 25,
                                //     icon: Icon(
                                //       Icons.arrow_back,
                                //     ),
                                //     onPressed: () async {
                                //       Navigator.pop(context);
                                //     },
                                //   ),
                                // Text(widget.model.name, style: new TextStyle(color: Colors.black))
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 1,
                                //     vertical: 5,
                                //   ),
                                //   child: IconButton(
                                //     color: Colors.black,
                                //     // Color.fromRGBO(244, 217, 66, 1),
                                //     iconSize: 25,
                                //     icon: Icon(
                                //       Icons.message,
                                //     ),
                                //     onPressed: () async {
                                //       var navigationResult = await Navigator.push(
                                //         context,
                                //         new MaterialPageRoute(
                                //           builder: (context) => ChatList(),
                                //         ),
                                //       );
                                //       if (navigationResult == true) {
                                //         MaterialPageRoute(
                                //           builder: (context) => ChatList(),
                                //         );
                                //       }
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 88,
                    //   width: MediaQuery.of(context).size.width*0.9,
                    //   // width: 350,
                    //   color: Colors.white,
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(
                    //           vertical: 15,),
                    //     child: RaisedButton(
                    //                   splashColor: Colors.purple,
                    //                   elevation: 1,
                    //                   onPressed: () {
                    //                   },
                    //                   padding: EdgeInsets.all(12),
                    //                   shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(10),
                    //                   ),
                    //                   color: Colors.black,
                    //                   // Color.fromRGBO(244, 217, 66, 1),
                    //                   child: Text(
                    //                     widget.model.name,
                    //                     style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 20,
                    //                     ),
                    //                   ),
                    //     ),
                    //   )
                    // child: ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: categori.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     final x = categori[index];
                    //     return Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: 15,
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 5,
                    //         ),
                    //         child: Column(
                    //           children: <Widget>[
                    //             x.id == widget.model.id ?
                    //             RaisedButton(
                    //               splashColor: Colors.purple,
                    //               elevation: 1,
                    //               onPressed: () {
                    //               },
                    //               padding: EdgeInsets.all(12),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(10),
                    //               ),
                    //               color: Colors.blue,
                    //               child: Text(
                    //                 x.name,
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 15,
                    //                 ),
                    //               ),
                    //             )
                    //             :
                    //             RaisedButton(
                    //               splashColor: Colors.purple,
                    //               elevation: 1,
                    //               onPressed: () {
                    //               },
                    //               padding: EdgeInsets.all(12),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(10),
                    //               ),
                    //               color: Color.fromRGBO(244, 217, 66, 1),
                    //               child: Text(
                    //                 x.name,
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 15,
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // ),
                    Container(
                      child: list.isEmpty
                          ? Center(child: Text("Belum ada post"))
                          : loading
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: list.length,
                                  itemBuilder: (context, i) {
                                    final x = list[i];
                                    return x.block_status == null
                                        ? Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 1,
                                                ),
                                                child: Container(
                                                  width: SizeConfig
                                                          .safeBlockHorizontal *
                                                      100,
                                                  height: SizeConfig
                                                          .safeBlockVertical *
                                                      110,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 2,
                                                        ),
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              leading:
                                                                  Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: x.user_img ==
                                                                        null
                                                                    ? placeholder
                                                                    : CircleAvatar(
                                                                        radius:
                                                                            40,
                                                                        backgroundImage:
                                                                            NetworkImage(ImageUrl.imageProfile +
                                                                                x.user_img),
                                                                        // child: ClipOval(
                                                                        //   child: Image(
                                                                        //     width: 50,
                                                                        //     height: 50,
                                                                        //     image: AssetImage(
                                                                        //       widget.icon,
                                                                        //     ),
                                                                        //     fit: BoxFit.cover,
                                                                        //   ),
                                                                        // ),
                                                                      ),
                                                              ),
                                                              title: InkWell(
                                                                child: Text(
                                                                  x.user_username,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  var navigationResult =
                                                                      await Navigator
                                                                          .push(
                                                                    context,
                                                                    new MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AnotherProfile(
                                                                              x),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              trailing: user_id ==
                                                                      x
                                                                          .post_user_id
                                                                  ? PopupMenuButton<
                                                                          String>(
                                                                      onSelected:
                                                                          choiceAction,
                                                                      itemBuilder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return MoreButton
                                                                            .choices
                                                                            .map((String
                                                                                choice) {
                                                                          return PopupMenuItem<String>(
                                                                              value: choice,
                                                                              child: Text(choice));
                                                                        }).toList();
                                                                      })
                                                                  // ? IconButton(
                                                                  //     icon: Icon(Icons.more),
                                                                  //     onPressed: () {})
                                                                  : IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        x.follow_status_user ==
                                                                                null
                                                                            ? FontAwesomeIcons.userPlus
                                                                            : FontAwesomeIcons.userCheck,
                                                                        color: x.follow_status_user ==
                                                                                null
                                                                            ? Color.fromRGBO(
                                                                                244,
                                                                                217,
                                                                                66,
                                                                                1)
                                                                            : Colors.black,
                                                                      ),
                                                                      iconSize:
                                                                          25,
                                                                      onPressed:
                                                                          () async {
                                                                        await getPref();
                                                                        final response = await http.post(
                                                                            FollowUrl.follow,
                                                                            body: {
                                                                              // "post_cat_id" : post_cat_id,
                                                                              "user_id": user_id,
                                                                              "follow_user_one": user_id,
                                                                              "valuee": x.post_user_id,
                                                                              "follow_user_two": x.post_user_id,
                                                                              // "follow_status": followed,
                                                                            });
                                                                        final data =
                                                                            jsonDecode(response.body);
                                                                        int value =
                                                                            data['value'];
                                                                        String
                                                                            pesan =
                                                                            data['message'];
                                                                        if (value ==
                                                                            1) {
                                                                          print(
                                                                              pesan);
                                                                          setState(
                                                                              () {
                                                                            x.follow_status_user !=
                                                                                null;
                                                                          });
                                                                        } else {
                                                                          print(
                                                                              pesan);
                                                                        }
                                                                        // follow();
                                                                      },
                                                                    ),
                                                              subtitle:
                                                                  Container(
                                                                width: 165,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      size: 11,
                                                                    ),
                                                                    // Expanded(
                                                                    // child:
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          x.post_location,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          softWrap:
                                                                              false,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              width: double
                                                                  .infinity,
                                                              height: 350,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      ImageUrl.imageContent +
                                                                          x.post_img),
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    // Row(
                                                                    //   children: <
                                                                    //       Widget>[
                                                                    //     IconButton(
                                                                    //       icon: Icon(
                                                                    //         x.like_status_user ==
                                                                    //                 null
                                                                    //             ? Icons
                                                                    //                 .favorite_border
                                                                    //             : Icons
                                                                    //                 .favorite,
                                                                    //         color: x.like_status_user ==
                                                                    //                 null
                                                                    //             ? Colors
                                                                    //                 .black
                                                                    //             : Color.fromRGBO(
                                                                    //                 244,
                                                                    //                 217,
                                                                    //                 66,
                                                                    //                 1),
                                                                    //       ),
                                                                    //       // x.like_status == null
                                                                    //       //     ? IconButton(
                                                                    //       //     icon: Icon(
                                                                    //       //       liked
                                                                    //       //           ? Icons
                                                                    //       //               .favorite
                                                                    //       //           : Icons
                                                                    //       //               .favorite_border,
                                                                    //       //       color: liked
                                                                    //       //           ? Color.fromRGBO(
                                                                    //       //               244,
                                                                    //       //               217,
                                                                    //       //               66,
                                                                    //       //               1)
                                                                    //       //           : Colors
                                                                    //       //               .black,
                                                                    //       //     ),
                                                                    //       //     iconSize: 30,
                                                                    //       //     onPressed:
                                                                    //       //         () async {
                                                                    //       //       await getPref();
                                                                    //       //       final response =
                                                                    //       //           await http.post(
                                                                    //       //               "http://dipena.com/flutter/api/like/addLike.php",
                                                                    //       //               body: {
                                                                    //       //             // "post_cat_id" : post_cat_id,
                                                                    //       //             "user_id":
                                                                    //       //                 user_id,
                                                                    //       //             "post_id":
                                                                    //       //                 x.post_id,
                                                                    //       //             // "follow_status": followed,
                                                                    //       //           });
                                                                    //       //       final data =
                                                                    //       //           jsonDecode(
                                                                    //       //               response
                                                                    //       //                   .body);
                                                                    //       //       int value = data[
                                                                    //       //           'value'];
                                                                    //       //       String pesan =
                                                                    //       //           data[
                                                                    //       //               'message'];
                                                                    //       //       if (value ==
                                                                    //       //           1) {
                                                                    //       //         print(
                                                                    //       //             pesan);
                                                                    //       //         setState(
                                                                    //       //             () {
                                                                    //       //           liked =
                                                                    //       //               !liked;
                                                                    //       //           x.like_status !=
                                                                    //       //               null;
                                                                    //       //         });
                                                                    //       //       } else {
                                                                    //       //         print(
                                                                    //       //             pesan);
                                                                    //       //       }
                                                                    //       //       // follow();
                                                                    //       //     },
                                                                    //       //   )
                                                                    //       // : IconButton(
                                                                    //       //     icon: Icon(
                                                                    //       //       liked
                                                                    //       //           ? Icons
                                                                    //       //               .favorite_border
                                                                    //       //           : Icons
                                                                    //       //               .favorite,
                                                                    //       //       color: liked
                                                                    //       //           ? Colors
                                                                    //       //               .black
                                                                    //       //           : Color.fromRGBO(
                                                                    //       //               244,
                                                                    //       //               217,
                                                                    //       //               66,
                                                                    //       //               1),
                                                                    //       //     ),
                                                                    //       iconSize:
                                                                    //           30,
                                                                    //       onPressed:
                                                                    //           () async {
                                                                    //         await getPref();
                                                                    //         final response = await http.post(
                                                                    //             LikeUrl
                                                                    //                 .addLike,
                                                                    //             body: {
                                                                    //               // "post_cat_id" : post_cat_id,
                                                                    //               "user_id":
                                                                    //                   user_id,
                                                                    //               "post_id":
                                                                    //                   x.post_id,
                                                                    //               // "follow_status": followed,
                                                                    //             });
                                                                    //         final data =
                                                                    //             jsonDecode(
                                                                    //                 response.body);
                                                                    //         int value =
                                                                    //             data[
                                                                    //                 'value'];
                                                                    //         String
                                                                    //             pesan =
                                                                    //             data[
                                                                    //                 'message'];
                                                                    //         if (value ==
                                                                    //             1) {
                                                                    //           print(
                                                                    //               pesan);
                                                                    //           setState(
                                                                    //               () {
                                                                    //             liked =
                                                                    //                 !liked;
                                                                    //             x.like_status_user !=
                                                                    //                 null;
                                                                    //           });
                                                                    //         } else {
                                                                    //           print(
                                                                    //               pesan);
                                                                    //         }
                                                                    //         // follow();
                                                                    //       },
                                                                    //     ),
                                                                    //     Text(
                                                                    //       x.jumlahLike ??
                                                                    //           '0',
                                                                    //       style:
                                                                    //           TextStyle(
                                                                    //         fontSize:
                                                                    //             14,
                                                                    //         fontWeight:
                                                                    //             FontWeight
                                                                    //                 .w600,
                                                                    //       ),
                                                                    //     ),
                                                                    //     // LikeTwo(),
                                                                    //     // Text(
                                                                    //     //   x.post_like_id,
                                                                    //     //   style: TextStyle(
                                                                    //     //     fontSize: 14,
                                                                    //     //     fontWeight:
                                                                    //     //         FontWeight.w600,
                                                                    //     //   ),
                                                                    //     // ),
                                                                    //   ],
                                                                    // ),
                                                                    // SizedBox(
                                                                    //   width: 10,
                                                                    // ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        IconButton(
                                                                          iconSize:
                                                                              25,
                                                                          icon:
                                                                              Icon(
                                                                            FontAwesomeIcons.comment,
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            var navigationResult =
                                                                                await Navigator.push(
                                                                              context,
                                                                              new MaterialPageRoute(
                                                                                builder: (context) => Comment(x),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(
                                                                          x.jumlahKomen ??
                                                                              '0',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: 15,
                                                                    right: 30,
                                                                  ),
                                                                  child: Text(
                                                                    // x.post_sub_cat_id,
                                                                    widget.model
                                                                        .name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: 15,
                                                                      right: 30,
                                                                    ),
                                                                    child: Text(
                                                                      x.post_title,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            17,
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
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: 15,
                                                                      right: 30,
                                                                    ),
                                                                    child: Text(
                                                                      x.post_description ??
                                                                          'null',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                      maxLines:
                                                                          5,
                                                                      softWrap:
                                                                          false,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                                right: 260,
                                                              ),
                                                              child:
                                                                  RaisedButton(
                                                                splashColor: Colors
                                                                    .purpleAccent,
                                                                elevation: 2,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            12),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                color: Colors
                                                                    .black,
                                                                // Color.fromRGBO(
                                                                //     244, 217, 66, 1),
                                                                child: Text(
                                                                  'SEE DEAL',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  var navigationResult =
                                                                      await Navigator
                                                                          .push(
                                                                    context,
                                                                    new MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Deal(x),
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
                                          )
                                        // ;
                                        : Container();
                                  }),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class LikeTwo extends StatefulWidget {
//   @override
//   _LikeTwoState createState() => _LikeTwoState();
// }

// class _LikeTwoState extends State<LikeTwo> {
//   bool liked = false;

//   _pressed() {
//     setState(() {
//       liked = !liked;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               liked ? Icons.favorite : Icons.favorite_border,
//               color: liked ? Color.fromRGBO(244, 217, 66, 1) : Colors.black,
//             ),
//             iconSize: 30,
//             onPressed: () => _pressed(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Follow extends StatefulWidget {
//   @override
//   _FollowState createState() => _FollowState();
// }

// class _FollowState extends State<Follow> {
//   bool followed = false;

//   // String user_id, post_user_id;

//   // var loading = false;
//   // final list = new List<PostFollow>();
//   // Future<void> _lihatData() async {
//   //   await getPref();
//   //   list.clear();
//   //   setState(() {
//   //     loading = true;
//   //   });
//   //   final response = await http
//   //       .post("http://dipena.com/flutter/api/following/selectPostFollow.php");
//   //   if (response.contentLength == 2) {
//   //     //   await getPref();
//   //     // final response =
//   //     //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
//   //     //   "user_id": user_id,
//   //     //   "location_country": location_country,
//   //     //   "location_city": location_city,
//   //     //   "location_user_id": user_id
//   //     // });

//   //     // final data = jsonDecode(response.body);
//   //     // int value = data['value'];
//   //     // String message = data['message'];
//   //     // String changeProf = data['changeProf'];
//   //   } else {
//   //     final data = jsonDecode(response.body);
//   //     data.forEach((api) {
//   //       final ab = new PostFollow(api['post_user_id']);
//   //       list.add(ab);
//   //     });
//   //     setState(() {
//   //       loading = false;
//   //     });
//   //   }
//   // }

//   _pressed() {
//     setState(() {
//       followed = !followed;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: IconButton(
//         icon: Icon(
//           followed ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userPlus,
//           color: followed ? Color.fromRGBO(244, 217, 66, 1) : Colors.black,
//         ),
//         iconSize: 25,
//         onPressed: () => _pressed(),
//       ),
//     );
//   }
// }
// IconButton(
//                                                           icon: Icon(
//                                                             x.like_status ==
//                                                                     null
//                                                                 ?
//                                                                 Icons
//                                                                     .favorite_border
//                                                                 : Icons
//                                                                     .favorite,
//                                                             color:
//                                                                 x.like_status ==
//                                                                         null
//                                                                     ? Colors
//                                                                         .black
//                                                                     : Color
//                                                                         .fromRGBO(
//                                                                             244,
//                                                                             217,
//                                                                             66,
//                                                                             1),
//                                                           ),

void choiceAction(String choice) {
  if (choice == MoreButton.edit) {
    BuildContext context;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(),
        ));
  } else if (choice == MoreButton.hapus) {
    print("Hapus");
  }
}

// class Category {
//   int id;
//   String name;

//   Category(
//     this.id,
//     this.name,
//   );
// }
