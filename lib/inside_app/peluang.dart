import 'dart:convert';

import 'package:dipena/inside_app/anotherUserProfile.dart';
import 'package:dipena/inside_app/makedeal.dart';
import 'package:dipena/inside_app/profile.dart';
import 'package:dipena/inside_app/searchNav.dart';
import 'package:dipena/inside_app/selectPostCategory.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/model/moreButton.dart';
import 'package:dipena/model/navigateCat.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/model/post_follow.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
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

class Peluang extends StatefulWidget {
  @override
  _PeluangState createState() => _PeluangState();
}

class _PeluangState extends State<Peluang> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshCat =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshLike =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshFollow =
      GlobalKey<RefreshIndicatorState>();
  int selectedIndex = 0;
  bool followed_status = false;
  bool liked = false;
  String user_id, valuee, follow_user_one, user_username, user_email;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      user_username = preferences.getString("user_username");
      user_email = preferences.getString("user_email");
      follow_user_one = preferences.getString("user_id");
    });
  }

  // final List<String> categories = [
  //   'Art',
  //   'Design',
  //   'Photography',
  //   'Others',
  //   // 'Brand',
  // ];

  // List<int> category = [1, 2, 3, 4];
  // String _category = 'Art';
  // final listt = new List<Category>();
  // List<Category> getCategories() {
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
      'Painter',
    ),
    Category(
      '2',
      'Designer',
    ),
    Category(
      '3',
      'Photographer',
    ),
    Category(
      '4',
      'Others',
    ),
  ];

  // var _lihatData = _lihatDataPost();
  // String show_cat;
  var loading = false;
  final list = new List<PostContent>();
  Future<void> _lihatDataPost() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.peluangPost, body: {
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
        // for(var i = 0; i < list.length; i++){
        //   if(list[i].post_cat_id == "1") {
        //     show_cat = "Painter";
        //   } else if(list[i].post_cat_id == "2") {
        //     show_cat = "Designer";
        //   } else if(list[i].post_cat_id == "3") {
        //     show_cat = "Photographer";
        //   } else if(list[i].post_cat_id == "4") {
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

  var follow_loading = false;
  String follow;
  final follow_status = new List<PostContent>();
  Future<void> _followStatus() async {
    await getPref();
    follow_status.clear();
    setState(() {
      follow_loading = true;
    });
    final response = await http.post(PostUrl.peluangPost, body: {
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
        follow_status.add(ab);
      });
      setState(() {
        for (var i = 0; i < follow_status.length; i++) {
          follow = follow_status[i].follow_status_user;
        }
        follow_loading = false;
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
  String dipencet = '1';
  var loadingg = false;
  final listt = new List<PostContent>();
  Future<void> _lihatDataPostCat() async {
    await getPref();
    await dipencet;
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.selectPostCat, body: {
      "user_id": user_id,
      "post_cat_id": dipencet,
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
        listt.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  var loadinggg = false;
  final listtt = new List<PostContent>();
  Future<void> _lihatDataPostUpdate() async {
    // await addLike();
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.peluangPost, body: {
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
        listtt.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _lihatDataPost();
    // _lihatData = _lihatDataPostUpdate();
    _lihatDataPostCat();

    _postsController = new StreamController();
    loadPosts();
    _followStatus();
    // likeStatus();
    // getCategories();
  }

  void refreshList() {
    // reload
    setState(() {
      // _lihatData = _lihatDataPostUpdate();
    });
  }

  // void likeStatus() async {
  //   for(var i = 0; i < list.length; i++)
  //   setState(() {
  //     list[i].like_status_user == !null;
  //   });
  // }

  bool category_selected = false;
  bool category_selected_color = false;

  StreamController<int> _controller = StreamController<int>.broadcast();

  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;
  var load_post = false;
  final lis = new List<PostContent>();
  Future fetchPost() async {
    await getPref();
    setState(() {
      load_post = true;
    });
    final response = await http.post(PostUrl.peluangPost, body: {
      "user_id": user_id,
      // "post_user_id": widget.model.post_user_id,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
      // final data = jsonDecode(response.body);
      // data.forEach((api) {
      //   final ab = new PostContent(
      //     api['post_id'],
      //     api['post_user_id'],
      //     api['post_cat_id'],
      //     api['post_sub_cat_id'],
      //     api['post_title'],
      //     api['post_location'],
      //     api['post_offer'],
      //     api['post_description'],
      //     api['post_comment_id'],
      //     api['post_like_id'],
      //     api['post_img'],
      //     api['post_time'],
      //     api['user_username'],
      //     api['user_img'],
      //     api['follow_status'],
      //     api['like_status'],
      //     api['jumlahKomen'],
      //     api['jumlahLike'],
      //     api['like_status_user'],
      //     api['follow_status_user'],
      //   );
      //   lis.add(ab);
      //   // fetchPost(ab);
      // });
      setState(() {
        load_post = false;
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadPosts() async {
    fetchPost().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  Future<Null> _handleRefresh() async {
    // count++;
    // print(count);
    fetchPost().then((res) async {
      _postsController.add(res);
      // showSnack();
      return Text("NULL");
    });
  }

  _showToastUnfoll(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.red,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.green,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

//     Widget _popUpGallery(BuildContext context) {
//     return new AlertDialog(
//       title: Text("HALLO"),
//       // ),
//       // actions: <Widget>[
// // player.play(alarmAudioPath);
//       // ],
//     );
  String report_post_id, report_post_img;
  report() async {
    await getPref();
    await report_post_id;
    await report_post_img;
    final response = await http
        .post("https://dipena.com/flutter/api/post/reportPost.php", body: {
      "user_username": user_username,
      // "user_password": user_password,
      "user_email": user_email,
      "post_id": report_post_id,
      "post_img": report_post_img
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    // String message = data['message'];
    String messageEnglish = data['messageEnglish'];
    // String changeProf = data['changeProf'];
    // String user_usernameAPI = data['user_username'];
    // String user_bioAPI = data['user_bio'];
    // String user_emailAPI = data['user_email'];
    // String user_id = data['user_id'];
    // String user_img = data['user_img'];

    if (value == 1) {
      Navigator.pop(context);
      print(report_post_id);
      _showToast(messageEnglish);
      // setState(() {
      //   _loginStatus = LoginStatus.signIn;
      //   savePref(value, user_id, user_username, user_emailAPI, user_bioAPI, user_img);
      // });
      // print(message);
      // _showToast(message);
    } else {
      print("fail");
      _showToast(messageEnglish);
      // print(message);
      // _showToast(messageEnglish);
    }
  }

  Widget _popUpGallery(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // final x = list[i];
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.all(0),
              onPressed: () {
                report();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Report",
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
            for (var i = 0; i < list.length; i++)
              list[i].post_id == report_post_id
                  ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        var navigationResult = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => AnotherProfile(list[i]),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("See Profile",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                      ),
                    )
                  : Container()
          ],
        )),
      ),
    );
  }

  // Widget _openCustomDialog() {
  //   showGeneralDialog(
  //       barrierColor: Colors.black.withOpacity(0.5),
  //       transitionBuilder: (BuildContext context, a1, a2, widget) {
  //         return Transform.scale(
  //           scale: a1.value,
  //           child: Opacity(
  //             opacity: a1.value,
  //             child: AlertDialog(
  //               shape: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(16.0)),
  //               title: Text('Hello!!'),
  //               content: Text('How are you?'),
  //             ),
  //           ),
  //         );
  //       },
  //       transitionDuration: Duration(milliseconds: 200),
  //       barrierDismissible: true,
  //       barrierLabel: '',
  //       context: context,
  //       pageBuilder: (context, animation1, animation2) {});
  // }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
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
        onRefresh: _lihatDataPost,
        key: _refresh,
        child: ListView(
          primary: true,
          children: <Widget>[
            Column(children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => SearchNav(),
                    ),
                  );
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
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
                      //       color: Colors.black,
                      //       // Color.fromRGBO(244, 217, 66, 1),
                      //     ),
                      //   ),
                      // ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 1,
                          // left: 10,
                          right: 15,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.search),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: () {
                                  // print("terpencet");
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => SearchNav(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Search",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    //  Color.fromRGBO(244, 217, 66, 1),
                                    fontSize: 20,
                                    // fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                            // Text(
                            //   'Dipena',
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     //  Color.fromRGBO(244, 217, 66, 1),
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w500,
                            //     fontFamily: 'Roboto',
                            //   ),
                            // ),
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
              ),
              RefreshIndicator(
                onRefresh: _lihatDataPostCat,
                key: _refreshCat,
                child: Container(),
              ),
              // RefreshIndicator(
              //   onRefresh: _lihatDataPost,
              //   key: _refreshLike,
              //   child: Container(),
              // ),
              Container(
                height: 60,
                width: 350,
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  //  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categori.length,
                  itemBuilder: (BuildContext context, int index) {
                    final x = categori[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 95),
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: MediaQuery.of(context).size.width ,
                        // ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // category_selected_color == true &&
                            // x.id == dipencet
                            //     ? RaisedButton(
                            //         splashColor: Colors.purple,
                            //         elevation: 1,
                            //         onPressed: () async {
                            //           setState(() {
                            //             dipencet = x.id;
                            //             print(dipencet);
                            //             category_selected = !category_selected;
                            //             category_selected_color =
                            //                 !category_selected_color;
                            //             // _refresh.currentState.show();
                            //             print(category_selected);
                            //           });
                            //           // var navigationResult = await Navigator.push(
                            //           //   context,
                            //           //   new MaterialPageRoute(
                            //           //     builder: (context) => SelectPostCat(x),
                            //           //   ),
                            //           // );
                            //         },
                            //         padding: EdgeInsets.all(12),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(10),
                            //         ),
                            //         color: Colors.blue,
                            //         child: Text(
                            //           x.name,
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 15,
                            //           ),
                            //         ),
                            //       )
                            // :
                            RaisedButton(
                              splashColor: Colors.purple,
                              elevation: 1,
                              onPressed: () async {
                                // setState(() {
                                //   dipencet = x.id;
                                //   print(dipencet);
                                //   category_selected = !category_selected;
                                //   // category_selected_color =
                                //   //     !category_selected_color;
                                //   // _refreshCat.currentState.show();
                                //   print(category_selected);
                                // });
                                var navigationResult = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => SelectPostCat(x),
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.black,
                              // Color.fromRGBO(244, 217, 66, 1),
                              child: Text(
                                x.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // category_selected == true
              //     ? Container(
              //         child: loading
              //             ? Center(child: CircularProgressIndicator())
              //             : ListView.builder(
              //                 shrinkWrap: true,
              //                 physics: const NeverScrollableScrollPhysics(),
              //                 itemCount: listt.length,
              //                 itemBuilder: (context, i) {
              //                   final xd = listt[i];
              //                   return Container(
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8),
              //                       child: Padding(
              //                         padding: const EdgeInsets.only(
              //                           top: 1,
              //                         ),
              //                         child: Container(
              //                           width: SizeConfig.safeBlockHorizontal *
              //                               100,
              //                           height:
              //                               SizeConfig.safeBlockVertical * 110,
              //                           decoration: BoxDecoration(
              //                             color: Colors.white,
              //                           ),
              //                           child: Column(
              //                             children: <Widget>[
              //                               Padding(
              //                                 padding:
              //                                     const EdgeInsets.symmetric(
              //                                   vertical: 2,
              //                                 ),
              //                                 child: Column(
              //                                   children: <Widget>[
              //                                     ListTile(
              //                                       leading: Container(
              //                                         width: 50,
              //                                         height: 50,
              //                                         decoration: BoxDecoration(
              //                                           shape: BoxShape.circle,
              //                                         ),
              //                                         child: xd.user_img == null
              //                                             ? placeholder
              //                                             : CircleAvatar(
              //                                                 radius: 40,
              //                                                 backgroundImage:
              //                                                     NetworkImage(ImageUrl
              //                                                             .imageProfile +
              //                                                         xd.user_img),
              //                                                 // child: ClipOval(
              //                                                 //   child: Image(
              //                                                 //     width: 50,
              //                                                 //     height: 50,
              //                                                 //     image: AssetImage(
              //                                                 //       widget.icon,
              //                                                 //     ),
              //                                                 //     fit: BoxFit.cover,
              //                                                 //   ),
              //                                                 // ),
              //                                               ),
              //                                       ),
              //                                       title: Text(
              //                                         xd.user_username,
              //                                         style: TextStyle(
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                         ),
              //                                       ),
              //                                       trailing: user_id ==
              //                                               xd.post_user_id
              //                                           ? PopupMenuButton<
              //                                                   String>(
              //                                               onSelected:
              //                                                   choiceAction,
              //                                               itemBuilder:
              //                                                   (BuildContext
              //                                                       context) {
              //                                                 return MoreButton
              //                                                     .choices
              //                                                     .map((String
              //                                                         choice) {
              //                                                   return PopupMenuItem<
              //                                                           String>(
              //                                                       value:
              //                                                           choice,
              //                                                       child: Text(
              //                                                           choice));
              //                                                 }).toList();
              //                                               })
              //                                           // ? IconButton(
              //                                           //     icon: Icon(Icons.more),
              //                                           //     onPressed: () {})
              //                                           : IconButton(
              //                                               icon: Icon(
              //                                                 xd.follow_status_user ==
              //                                                         null
              //                                                     ? FontAwesomeIcons
              //                                                         .userPlus
              //                                                     : FontAwesomeIcons
              //                                                         .userCheck,
              //                                                 color: xd.follow_status_user ==
              //                                                         null
              //                                                     ? Color
              //                                                         .fromRGBO(
              //                                                             244,
              //                                                             217,
              //                                                             66,
              //                                                             1)
              //                                                     : Colors
              //                                                         .black,
              //                                               ),
              //                                               iconSize: 25,
              //                                               onPressed:
              //                                                   () async {
              //                                                 await getPref();
              //                                                 final response =
              //                                                     await http.post(
              //                                                         FollowUrl
              //                                                             .follow,
              //                                                         body: {
              //                                                       // "post_cat_id" : post_cat_id,
              //                                                       "user_id":
              //                                                           user_id,
              //                                                       "follow_user_one":
              //                                                           user_id,
              //                                                       "valuee": xd
              //                                                           .post_user_id,
              //                                                       "follow_user_two":
              //                                                           xd.post_user_id,
              //                                                       // "follow_status": followed,
              //                                                     });
              //                                                 final data =
              //                                                     jsonDecode(
              //                                                         response
              //                                                             .body);
              //                                                 int value =
              //                                                     data['value'];
              //                                                 String pesan =
              //                                                     data[
              //                                                         'message'];
              //                                                 if (value == 1) {
              //                                                   print(pesan);
              //                                                   setState(() {
              //                                                     xd.follow_status_user !=
              //                                                         null;
              //                                                   });
              //                                                 } else {
              //                                                   print(pesan);
              //                                                 }
              //                                                 // follow();
              //                                               },
              //                                             ),
              //                                       subtitle: Row(
              //                                         children: <Widget>[
              //                                           Icon(
              //                                             Icons.location_on,
              //                                             color:
              //                                                 Colors.grey[600],
              //                                             size: 11,
              //                                           ),
              //                                           Text(
              //                                             xd.post_location,
              //                                             style: TextStyle(
              //                                               fontWeight:
              //                                                   FontWeight.bold,
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Container(
              //                                       margin: EdgeInsets.all(10),
              //                                       width: double.infinity,
              //                                       height: 350,
              //                                       decoration: BoxDecoration(
              //                                         image: DecorationImage(
              //                                           image: NetworkImage(
              //                                               ImageUrl.imageContent +
              //                                                   xd.post_img),
              //                                           fit: BoxFit.fitWidth,
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     Row(
              //                                       mainAxisAlignment:
              //                                           MainAxisAlignment
              //                                               .spaceBetween,
              //                                       children: <Widget>[
              //                                         Row(
              //                                           children: <Widget>[
              //                                             Row(
              //                                               children: <Widget>[
              //                                                 IconButton(
              //                                                   icon: Icon(
              //                                                     xd.like_status_user ==
              //                                                             null
              //                                                         ? Icons
              //                                                             .favorite_border
              //                                                         : Icons
              //                                                             .favorite,
              //                                                     color: xd.like_status_user ==
              //                                                             null
              //                                                         ? Colors
              //                                                             .black
              //                                                         : Color.fromRGBO(
              //                                                             244,
              //                                                             217,
              //                                                             66,
              //                                                             1),
              //                                                   ),
              //                                                   // x.like_status == null
              //                                                   //     ? IconButton(
              //                                                   //     icon: Icon(
              //                                                   //       liked
              //                                                   //           ? Icons
              //                                                   //               .favorite
              //                                                   //           : Icons
              //                                                   //               .favorite_border,
              //                                                   //       color: liked
              //                                                   //           ? Color.fromRGBO(
              //                                                   //               244,
              //                                                   //               217,
              //                                                   //               66,
              //                                                   //               1)
              //                                                   //           : Colors
              //                                                   //               .black,
              //                                                   //     ),
              //                                                   //     iconSize: 30,
              //                                                   //     onPressed:
              //                                                   //         () async {
              //                                                   //       await getPref();
              //                                                   //       final response =
              //                                                   //           await http.post(
              //                                                   //               "http://dipena.com/flutter/api/like/addLike.php",
              //                                                   //               body: {
              //                                                   //             // "post_cat_id" : post_cat_id,
              //                                                   //             "user_id":
              //                                                   //                 user_id,
              //                                                   //             "post_id":
              //                                                   //                 x.post_id,
              //                                                   //             // "follow_status": followed,
              //                                                   //           });
              //                                                   //       final data =
              //                                                   //           jsonDecode(
              //                                                   //               response
              //                                                   //                   .body);
              //                                                   //       int value = data[
              //                                                   //           'value'];
              //                                                   //       String pesan =
              //                                                   //           data[
              //                                                   //               'message'];
              //                                                   //       if (value ==
              //                                                   //           1) {
              //                                                   //         print(
              //                                                   //             pesan);
              //                                                   //         setState(
              //                                                   //             () {
              //                                                   //           liked =
              //                                                   //               !liked;
              //                                                   //           x.like_status !=
              //                                                   //               null;
              //                                                   //         });
              //                                                   //       } else {
              //                                                   //         print(
              //                                                   //             pesan);
              //                                                   //       }
              //                                                   //       // follow();
              //                                                   //     },
              //                                                   //   )
              //                                                   // : IconButton(
              //                                                   //     icon: Icon(
              //                                                   //       liked
              //                                                   //           ? Icons
              //                                                   //               .favorite_border
              //                                                   //           : Icons
              //                                                   //               .favorite,
              //                                                   //       color: liked
              //                                                   //           ? Colors
              //                                                   //               .black
              //                                                   //           : Color.fromRGBO(
              //                                                   //               244,
              //                                                   //               217,
              //                                                   //               66,
              //                                                   //               1),
              //                                                   //     ),
              //                                                   iconSize: 30,
              //                                                   onPressed:
              //                                                       () async {
              //                                                     await getPref();
              //                                                     final response =
              //                                                         await http.post(
              //                                                             LikeUrl
              //                                                                 .addLike,
              //                                                             body: {
              //                                                           // "post_cat_id" : post_cat_id,
              //                                                           "user_id":
              //                                                               user_id,
              //                                                           "post_id":
              //                                                               xd.post_id,
              //                                                           // "follow_status": followed,
              //                                                         });
              //                                                     final data =
              //                                                         jsonDecode(
              //                                                             response
              //                                                                 .body);
              //                                                     int value = data[
              //                                                         'value'];
              //                                                     String pesan =
              //                                                         data[
              //                                                             'message'];
              //                                                     if (value ==
              //                                                         1) {
              //                                                       print(
              //                                                           pesan);
              //                                                       setState(
              //                                                           () {
              //                                                         liked =
              //                                                             !liked;
              //                                                         xd.like_status_user !=
              //                                                             null;
              //                                                       });
              //                                                     } else {
              //                                                       print(
              //                                                           pesan);
              //                                                     }
              //                                                     // follow();
              //                                                   },
              //                                                 ),
              //                                                 Text(
              //                                                   xd.jumlahLike ??
              //                                                       '0',
              //                                                   style:
              //                                                       TextStyle(
              //                                                     fontSize: 14,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .w600,
              //                                                   ),
              //                                                 ),
              //                                                 // LikeTwo(),
              //                                                 // Text(
              //                                                 //   x.post_like_id,
              //                                                 //   style: TextStyle(
              //                                                 //     fontSize: 14,
              //                                                 //     fontWeight:
              //                                                 //         FontWeight.w600,
              //                                                 //   ),
              //                                                 // ),
              //                                               ],
              //                                             ),
              //                                             SizedBox(
              //                                               width: 10,
              //                                             ),
              //                                             Row(
              //                                               children: <Widget>[
              //                                                 IconButton(
              //                                                   iconSize: 25,
              //                                                   icon: Icon(
              //                                                     FontAwesomeIcons
              //                                                         .comment,
              //                                                   ),
              //                                                   onPressed:
              //                                                       () async {
              //                                                     var navigationResult =
              //                                                         await Navigator
              //                                                             .push(
              //                                                       context,
              //                                                       new MaterialPageRoute(
              //                                                         builder: (context) =>
              //                                                             Comment(
              //                                                                 xd),
              //                                                       ),
              //                                                     );
              //                                                   },
              //                                                 ),
              //                                                 Text(
              //                                                   xd.jumlahKomen ??
              //                                                       '0',
              //                                                   style:
              //                                                       TextStyle(
              //                                                     fontSize: 14,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .w600,
              //                                                   ),
              //                                                 ),
              //                                               ],
              //                                             ),
              //                                           ],
              //                                         ),
              //                                       ],
              //                                     ),
              //                                     Row(
              //                                       children: <Widget>[
              //                                         Container(
              //                                           margin: EdgeInsets.only(
              //                                             left: 15,
              //                                             right: 30,
              //                                           ),
              //                                           child: Text(
              //                                             // x.post_sub_cat_id,
              //                                             "Art",
              //                                             // show_cat,
              //                                             style: TextStyle(
              //                                               fontSize: 18,
              //                                               fontWeight:
              //                                                   FontWeight.w700,
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                         top: 10,
              //                                       ),
              //                                       child: Row(
              //                                         children: <Widget>[
              //                                           Container(
              //                                             margin:
              //                                                 EdgeInsets.only(
              //                                               left: 15,
              //                                               right: 30,
              //                                             ),
              //                                             child: Text(
              //                                               xd.post_title,
              //                                               style: TextStyle(
              //                                                 fontSize: 17,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .w500,
              //                                               ),
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                         top: 10,
              //                                       ),
              //                                       child: Row(
              //                                         children: <Widget>[
              //                                           Container(
              //                                             margin:
              //                                                 EdgeInsets.only(
              //                                               left: 15,
              //                                               right: 30,
              //                                             ),
              //                                             child: Text(
              //                                               xd.post_description ??
              //                                                   'null',
              //                                               style: TextStyle(
              //                                                 fontSize: 15,
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .w500,
              //                                               ),
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                         top: 10,
              //                                         right: 260,
              //                                       ),
              //                                       child: RaisedButton(
              //                                         splashColor:
              //                                             Colors.purpleAccent,
              //                                         elevation: 2,
              //                                         padding:
              //                                             EdgeInsets.all(12),
              //                                         shape:
              //                                             RoundedRectangleBorder(
              //                                           borderRadius:
              //                                               BorderRadius
              //                                                   .circular(15),
              //                                         ),
              //                                         color: Colors.black,
              //                                         // Color.fromRGBO(
              //                                         //     244, 217, 66, 1),
              //                                         child: Text(
              //                                           'SEE DEAL',
              //                                           style: TextStyle(
              //                                             color: Colors.white,
              //                                             fontSize: 15,
              //                                             fontWeight:
              //                                                 FontWeight.w600,
              //                                           ),
              //                                         ),
              //                                         onPressed: () async {
              //                                           var navigationResult =
              //                                               await Navigator
              //                                                   .push(
              //                                             context,
              //                                             new MaterialPageRoute(
              //                                               builder:
              //                                                   (context) =>
              //                                                       Deal(xd),
              //                                             ),
              //                                           );
              //                                         },
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 }),
              //       )
              //     // :
              // Container(

              // ),
              // :
              Container(
                child: list.isEmpty
                    ? Center(child: Text("BELUM ADA POST APAPUN"))
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
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1,
                                          // bottom: 8,
                                        ),
                                        child: Container(
                                          // width:
                                          //     SizeConfig.safeBlockHorizontal *
                                          //         100,
                                          // height:
                                          //     SizeConfig.safeBlockVertical *
                                          //         110,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    // RefreshIndicator(
                                                    // onRefresh: _followStatus,
                                                    // key: _refreshFollow,
                                                    // child: Container(),
                                                    // ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                                                      child: ListTile(
                                                        leading: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: x.user_img ==
                                                                  null
                                                              ? InkWell(
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
                                                                  child:
                                                                      placeholder)
                                                              : InkWell(
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
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor: Color.fromRGBO(244, 217, 66, 1), 
                                                                    radius: 40,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            ImageUrl.imageProfile +
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
                                                                x.post_user_id
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
                                                                    return PopupMenuItem<
                                                                            String>(
                                                                        value:
                                                                            choice,
                                                                        child: Text(
                                                                            choice));
                                                                  }).toList();
                                                                })
                                                            // ? IconButton(
                                                            //     icon: Icon(Icons.more),
                                                            //     onPressed: () {})
                                                            : IconButton(
                                                                icon: Icon(
                                                                  x.follow_status_user ==
                                                                          null
                                                                      ? FontAwesomeIcons
                                                                          .userPlus
                                                                      : FontAwesomeIcons
                                                                          .userCheck,
                                                                  color: x.follow_status_user ==
                                                                          null
                                                                      ? Color
                                                                          .fromRGBO(
                                                                              244,
                                                                              217,
                                                                              66,
                                                                              1)
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                iconSize: 25,
                                                                onPressed:
                                                                    () async {
                                                                  await getPref();
                                                                  final response =
                                                                      await http.post(
                                                                          FollowUrl
                                                                              .follow,
                                                                          body: {
                                                                        // "post_cat_id" : post_cat_id,
                                                                        "user_id":
                                                                            user_id,
                                                                        "follow_user_one":
                                                                            user_id,
                                                                        "valuee":
                                                                            x.post_user_id,
                                                                        "follow_user_two":
                                                                            x.post_user_id,
                                                                        // "follow_status": followed,
                                                                      });
                                                                  final data =
                                                                      jsonDecode(
                                                                          response
                                                                              .body);
                                                                  int value = data[
                                                                      'value'];
                                                                  String pesan =
                                                                      data[
                                                                          'message'];
                                                                  if (value ==
                                                                      1) {
                                                                    print(pesan);
                                                                    setState(() {
                                                                      x.follow_status_user !=
                                                                          null;
                                                                    });
                                                                    _showToast(
                                                                        pesan);
                                                                  } else if (value ==
                                                                      2) {
                                                                    print(pesan);
                                                                    _showToastUnfoll(
                                                                        pesan);
                                                                  } else {
                                                                    _showToast(
                                                                        pesan);
                                                                  }
                                                                  // follow();
                                                                },
                                                              ),
                                                        // IconButton(
                                                        //     icon: Icon(
                                                        //       follow ==
                                                        //               null
                                                        //           ? FontAwesomeIcons
                                                        //               .userPlus
                                                        //           : FontAwesomeIcons
                                                        //               .userCheck,
                                                        //       color: follow ==
                                                        //               null
                                                        //           ? Color
                                                        //               .fromRGBO(
                                                        //                   244,
                                                        //                   217,
                                                        //                   66,
                                                        //                   1)
                                                        //           : Colors
                                                        //               .black,
                                                        //     ),
                                                        //     iconSize: 25,
                                                        //     onPressed:
                                                        //         () async {
                                                        //       await getPref();
                                                        //       final response =
                                                        //           await http.post(
                                                        //               FollowUrl
                                                        //                   .follow,
                                                        //               body: {
                                                        //             // "post_cat_id" : post_cat_id,
                                                        //             "user_id":
                                                        //                 user_id,
                                                        //             "follow_user_one":
                                                        //                 user_id,
                                                        //             "valuee": x
                                                        //                 .post_user_id,
                                                        //             "follow_user_two":
                                                        //                 x.post_user_id,
                                                        //             // "follow_status": followed,
                                                        //           });
                                                        //       final data =
                                                        //           jsonDecode(
                                                        //               response
                                                        //                   .body);
                                                        //       int value =
                                                        //           data['value'];
                                                        //       String pesan =
                                                        //           data[
                                                        //               'message'];
                                                        //       if (value == 1) {
                                                        //         print(pesan);
                                                        //         // setState(() {
                                                        //         //   // x.follow_status_user !=
                                                        //         //   //     null;
                                                        //         // });
                                                        //         _refreshFollow.currentState.show();
                                                        //       } else {
                                                        //         print(pesan);
                                                        //       }
                                                        //       // follow();
                                                        //     },
                                                        //   ),
                                                        subtitle: Container(
                                                          width: 165,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.location_on,
                                                                color: Colors
                                                                    .grey[600],
                                                                size: 11,
                                                              ),
                                                              // Expanded(
                                                              // child:
                                                              Flexible(
                                                                child: Container(
                                                                  child: Text(
                                                                    x.post_location,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, bottom: 10),
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
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10.0, right: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          // Row(
                                                          // children: <Widget>[
                                                          // Like(
                                                          //     stream:
                                                          //         _controller
                                                          //             .stream
                                                          //             ),
                                                          // Row(
                                                          //   children: <Widget>[
                                                          //     // RefreshIndicator(
                                                          //     //   onRefresh: _lihatDataPost,
                                                          //     //   key: _refreshLike,
                                                          //     //   child:
                                                          //     //       IconButton(
                                                          //     //     icon: Icon(
                                                          //     //       x.like_status_user ==
                                                          //     //               null
                                                          //     //           ? Icons
                                                          //     //               .favorite_border
                                                          //     //           : Icons
                                                          //     //               .favorite,
                                                          //     //       color: x.like_status_user ==
                                                          //     //               null
                                                          //     //           ? Colors
                                                          //     //               .black
                                                          //     //           : Color.fromRGBO(
                                                          //     //               244,
                                                          //     //               217,
                                                          //     //               66,
                                                          //     //               1),
                                                          //     //     ),
                                                          //     //     iconSize: 30,
                                                          //     //     onPressed:
                                                          //     //         () async {
                                                          //     //       // setState(
                                                          //     //       //     () async {
                                                          //     //       //   dipencet_addlike =
                                                          //     //       //       x.post_id;
                                                          //     //       // });
                                                          //     //       // addLike();
                                                          //     //       await getPref();
                                                          //     //       final response =
                                                          //     //           await http.post(
                                                          //     //               LikeUrl
                                                          //     //                   .addLike,
                                                          //     //               body: {
                                                          //     //             // "post_cat_id" : post_cat_id,
                                                          //     //             "user_id":
                                                          //     //                 user_id,
                                                          //     //             "post_id":
                                                          //     //                 x.post_id,
                                                          //     //             // "follow_status": followed,
                                                          //     //           });
                                                          //     //       final data =
                                                          //     //           jsonDecode(
                                                          //     //               response
                                                          //     //                   .body);
                                                          //     //       int value = data[
                                                          //     //           'value'];
                                                          //     //       String pesan =
                                                          //     //           data[
                                                          //     //               'message'];
                                                          //     //       if (value ==
                                                          //     //           1) {
                                                          //     //         print(
                                                          //     //             pesan);
                                                          //     //         // setState(() {
                                                          //     //         //   // liked = !liked;
                                                          //     //         //   x.like_status_user !=
                                                          //     //         //       null;
                                                          //     //         // });
                                                          //     //       } else {
                                                          //     //         print(
                                                          //     //             pesan);
                                                          //     //       }
                                                          //     //       _refreshLike.currentState.show();
                                                          //     //       // likeStatus();
                                                          //     //       // follow();
                                                          //     //     },
                                                          //     //   ),
                                                          //     // // ),
                                                          //     // Text(
                                                          //     //   x.jumlahLike ??
                                                          //     //       '0',
                                                          //     //   style:
                                                          //     //       TextStyle(
                                                          //     //     fontSize: 14,
                                                          //     //     fontWeight:
                                                          //     //         FontWeight
                                                          //     //             .w600,
                                                          //     //   ),
                                                          //     // ),
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
                                                                          Comment(
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
                                                              // Spacer(flex: 2),
                                                            ],
                                                          ),
                                                          user_id ==
                                                                  x.post_user_id
                                                              ? Container()
                                                              : IconButton(
                                                                  icon: Icon(Icons
                                                                      .more_vert),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      report_post_id =
                                                                          x.post_id;
                                                                      report_post_img =
                                                                          x.post_img;
                                                                    });
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          _popUpGallery(
                                                                              context),
                                                                    );
                                                                    // _openCustomDialog(BuildContext context);
                                                                  },
                                                                ),
                                                          // Spacer(flex: 1),
                                                          // Row(
                                                          // mainAxisAlignment: MainAxisAlignment.end,
                                                          // children: <Widget>[

                                                          // ],
                                                          // )
                                                        ],
                                                        // ),
                                                        // ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 23,
                                                            right: 30,
                                                          ),
                                                          child:
                                                              //  x.post_cat_id == "1" ?
                                                              Text(
                                                            // x.post_sub_cat_id,
                                                            show_cat(
                                                                x.post_cat_id),
                                                            style: TextStyle(
                                                              fontSize: 18,
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
                                                          const EdgeInsets.only(
                                                        top: 10,
                                                        left: 8,
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 15,
                                                              right: 30,
                                                            ),
                                                            child: Text(
                                                              x.post_title,
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                                        left: 8,
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 15,
                                                              right: 30,
                                                            ),
                                                            child: Text(
                                                              x.post_description ??
                                                                  'null',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              maxLines: 5,
                                                              softWrap: false,
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
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              left: 15,
                                                              right: 15
                                                              // right: 260,
                                                              ),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: RaisedButton(
                                                          splashColor: Colors
                                                              .purpleAccent,
                                                          elevation: 2,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          color:
                                                              // Colors.black,
                                                              Color.fromRGBO(
                                                                  250,
                                                                  185,
                                                                  32,
                                                                  1),
                                                          child: Text(
                                                            'KOLABS',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          onPressed: () async {
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
              // : StreamBuilder(
              //     stream: _postsController.stream,
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //       // print('Has error: ${snapshot.hasError}');
              //       // print('Has data: ${snapshot.hasData}');
              //       // print('Snapshot Data ${snapshot.data}');

              //       if (snapshot.hasError) {
              //         return Text(snapshot.error);
              //       }

              //       if (snapshot.hasData) {
              //         return Container(
              //             child:
              //                 // load_post
              //                 //     ? Center(child: CircularProgressIndicator())
              //                 //     :
              //                 RefreshIndicator(
              //           onRefresh: _handleRefresh,
              //           key: _refreshLike,
              //           child: ListView.builder(
              //               shrinkWrap: true,
              //               physics: const NeverScrollableScrollPhysics(),
              //               itemCount: snapshot.data.length,
              //               itemBuilder: (context, index) {
              //                 var xdd = snapshot.data[index];
              //                 final e = list[index];
              //                 // for(var i = 0; i < lis.length; i++)
              //                 // final x = lis[i];
              //                 return Container(
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(8),
              //                     child: Padding(
              //                       padding: const EdgeInsets.only(
              //                         top: 1,
              //                       ),
              //                       child: Container(
              //                         width:
              //                             SizeConfig.safeBlockHorizontal *
              //                                 100,
              //                         height: SizeConfig.safeBlockVertical *
              //                             110,
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                         ),
              //                         child: Column(
              //                           children: <Widget>[
              //                             // for(var i = 0; i < lis.length; i++)
              //                             Padding(
              //                               padding:
              //                                   const EdgeInsets.symmetric(
              //                                 vertical: 2,
              //                               ),
              //                               child: Column(
              //                                 children: <Widget>[
              //                                   ListTile(
              //                                     leading: Container(
              //                                       width: 50,
              //                                       height: 50,
              //                                       decoration:
              //                                           BoxDecoration(
              //                                         shape:
              //                                             BoxShape.circle,
              //                                       ),
              //                                       child:
              //                                           xdd['user_img'] ==
              //                                                   null
              //                                               ? placeholder
              //                                               : CircleAvatar(
              //                                                   radius: 40,
              //                                                   backgroundImage:
              //                                                       NetworkImage(ImageUrl.imageProfile +
              //                                                           xdd['user_img']),
              //                                                   // child: ClipOval(
              //                                                   //   child: Image(
              //                                                   //     width: 50,
              //                                                   //     height: 50,
              //                                                   //     image: AssetImage(
              //                                                   //       widget.icon,
              //                                                   //     ),
              //                                                   //     fit: BoxFit.cover,
              //                                                   //   ),
              //                                                   // ),
              //                                                 ),
              //                                     ),
              //                                     title: InkWell(
              //                                       onTap: () async {
              //                                         var navigationResult =
              //                                             await Navigator
              //                                                 .push(
              //                                           context,
              //                                           new MaterialPageRoute(
              //                                             builder: (context) =>
              //                                                 AnotherProfile(
              //                                                     e),
              //                                           ),
              //                                         );
              //                                       },
              //                                       child: Text(
              //                                         xdd['user_username'],
              //                                         style: TextStyle(
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     trailing: user_id ==
              //                                             xdd[
              //                                                 'post_user_id']
              //                                         ? PopupMenuButton<
              //                                                 String>(
              //                                             onSelected:
              //                                                 choiceAction,
              //                                             itemBuilder:
              //                                                 (BuildContext
              //                                                     context) {
              //                                               return MoreButton
              //                                                   .choices
              //                                                   .map((String
              //                                                       choice) {
              //                                                 return PopupMenuItem<
              //                                                         String>(
              //                                                     value:
              //                                                         choice,
              //                                                     child: Text(
              //                                                         choice));
              //                                               }).toList();
              //                                             })
              //                                         // ? IconButton(
              //                                         //     icon: Icon(Icons.more),
              //                                         //     onPressed: () {})
              //                                         : IconButton(
              //                                             icon: Icon(
              //                                               xdd['follow_status_user'] ==
              //                                                       null
              //                                                   ? FontAwesomeIcons
              //                                                       .userPlus
              //                                                   : FontAwesomeIcons
              //                                                       .userCheck,
              //                                               color: xdd['follow_status_user'] ==
              //                                                       null
              //                                                   ? Color
              //                                                       .fromRGBO(
              //                                                           244,
              //                                                           217,
              //                                                           66,
              //                                                           1)
              //                                                   : Colors
              //                                                       .black,
              //                                             ),
              //                                             iconSize: 25,
              //                                             onPressed:
              //                                                 () async {
              //                                               await getPref();
              //                                               final response =
              //                                                   await http.post(
              //                                                       FollowUrl
              //                                                           .follow,
              //                                                       body: {
              //                                                     // "post_cat_id" : post_cat_id,
              //                                                     "user_id":
              //                                                         user_id,
              //                                                     "follow_user_one":
              //                                                         user_id,
              //                                                     "valuee":
              //                                                         xdd['post_user_id'],
              //                                                     "follow_user_two":
              //                                                         xdd['post_user_id'],
              //                                                     // "follow_status": followed,
              //                                                   });
              //                                               final data =
              //                                                   jsonDecode(
              //                                                       response
              //                                                           .body);
              //                                               int value = data[
              //                                                   'value'];
              //                                               String pesan =
              //                                                   data[
              //                                                       'message'];
              //                                               if (value ==
              //                                                   1) {
              //                                                 print(pesan);
              //                                                 // setState(
              //                                                 //     () {
              //                                                 //   xdd['follow_status_user'] !=
              //                                                 //       null;
              //                                                 // });
              //                                               } else {
              //                                                 print(pesan);
              //                                               }
              //                                               _refreshLike
              //                                                   .currentState
              //                                                   .show();
              //                                               // follow();
              //                                             },
              //                                           ),
              //                                     subtitle: Row(
              //                                       children: <Widget>[
              //                                         Icon(
              //                                           Icons.location_on,
              //                                           color: Colors
              //                                               .grey[600],
              //                                           size: 11,
              //                                         ),
              //                                         Text(
              //                                           xdd['post_location'],
              //                                           style: TextStyle(
              //                                             fontWeight:
              //                                                 FontWeight
              //                                                     .bold,
              //                                           ),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   ),
              //                                   Container(
              //                                     margin:
              //                                         EdgeInsets.all(10),
              //                                     width: double.infinity,
              //                                     height: 350,
              //                                     decoration: BoxDecoration(
              //                                       image: DecorationImage(
              //                                         image: NetworkImage(ImageUrl
              //                                                 .imageContent +
              //                                             xdd['post_img']),
              //                                         fit: BoxFit.fitWidth,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceBetween,
              //                                     children: <Widget>[
              //                                       Row(
              //                                         children: <Widget>[
              //                                           // Like(
              //                                           //     stream:
              //                                           //         _controller
              //                                           //             .stream
              //                                           //             ),
              //                                           Row(
              //                                             children: <
              //                                                 Widget>[
              //                                               // RefreshIndicator(
              //                                               //   onRefresh: _lihatDataPost,
              //                                               //   key: _refreshLike,
              //                                               //   child:
              //                                               // IconButton(
              //                                               //   icon:
              //                                               //       Icon(
              //                                               //     xdd['like_status_user'] == null ||
              //                                               //             liked
              //                                               //         ? Icons.favorite_border
              //                                               //         : Icons.favorite,
              //                                               //     color: xdd['like_status_user'] == null ||
              //                                               //             liked
              //                                               //         ? Colors
              //                                               //             .black
              //                                               //         : Color.fromRGBO(
              //                                               //             244,
              //                                               //             217,
              //                                               //             66,
              //                                               //             1),
              //                                               //   ),
              //                                               //   iconSize:
              //                                               //       30,
              //                                               //   onPressed:
              //                                               //       () async {
              //                                               //     setState(
              //                                               //         () {
              //                                               //       liked =
              //                                               //           !liked;
              //                                               //     });
              //                                               //     await getPref();
              //                                               //     print(
              //                                               //         user_id);

              //                                               //     final response = await http.post(
              //                                               //         LikeUrl.addLike,
              //                                               //         body: {
              //                                               //           // "post_cat_id" : post_cat_id,
              //                                               //           "user_id": user_id,
              //                                               //           "post_id": xdd['post_id'],
              //                                               //           // "follow_status": followed,
              //                                               //         });
              //                                               //     final data =
              //                                               //         jsonDecode(response.body);
              //                                               //     int value =
              //                                               //         data['value'];
              //                                               //     String
              //                                               //         pesan =
              //                                               //         data['message'];
              //                                               //     if (value ==
              //                                               //         1) {
              //                                               //       print(
              //                                               //           pesan);
              //                                               //       setState(
              //                                               //           () {
              //                                               //         liked =
              //                                               //             !liked;
              //                                               //       });
              //                                               //       // setState(() {
              //                                               //       //   // liked = !liked;
              //                                               //       //   x.like_status_user !=
              //                                               //       //       null;
              //                                               //       // });
              //                                               //     } else {
              //                                               //       print(
              //                                               //           pesan);
              //                                               //     }

              //                                               //     _refreshLike
              //                                               //         .currentState
              //                                               //         .show();

              //                                               //     // likeStatus();
              //                                               //     // follow();
              //                                               //   },
              //                                               // ),
              //                                               // // ),
              //                                               // Text(
              //                                               //   xdd['jumlahLike'] ??
              //                                               //       '0',
              //                                               //   style:
              //                                               //       TextStyle(
              //                                               //     fontSize:
              //                                               //         14,
              //                                               //     fontWeight:
              //                                               //         FontWeight.w600,
              //                                               //   ),
              //                                               // ),
              //                                               // LikeTwo(),
              //                                               // Text(
              //                                               //   x.post_like_id,
              //                                               //   style: TextStyle(
              //                                               //     fontSize: 14,
              //                                               //     fontWeight:
              //                                               //         FontWeight.w600,
              //                                               //   ),
              //                                               // ),
              //                                             ],
              //                                           ),
              //                                           SizedBox(
              //                                             width: 10,
              //                                           ),
              //                                           Row(
              //                                             children: <
              //                                                 Widget>[
              //                                               IconButton(
              //                                                 iconSize: 25,
              //                                                 icon: Icon(
              //                                                   FontAwesomeIcons
              //                                                       .comment,
              //                                                 ),
              //                                                 onPressed:
              //                                                     () async {
              //                                                   // for (var i =
              //                                                   //         0;
              //                                                   //     i < list.length;
              //                                                   //     i++)
              //                                                   var navigationResult =
              //                                                       await Navigator
              //                                                           .push(
              //                                                     context,
              //                                                     new MaterialPageRoute(
              //                                                       builder:
              //                                                           (context) =>
              //                                                               Comment(e),
              //                                                     ),
              //                                                   );
              //                                                 },
              //                                               ),
              //                                               Text(
              //                                                 xdd['jumlahKomen'] ??
              //                                                     '0',
              //                                                 style:
              //                                                     TextStyle(
              //                                                   fontSize:
              //                                                       14,
              //                                                   fontWeight:
              //                                                       FontWeight
              //                                                           .w600,
              //                                                 ),
              //                                               ),
              //                                             ],
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ],
              //                                   ),
              //                                   Row(
              //                                     children: <Widget>[
              //                                       Container(
              //                                         margin:
              //                                             EdgeInsets.only(
              //                                           left: 15,
              //                                           right: 30,
              //                                         ),
              //                                         child: Text(
              //                                           // x.post_sub_cat_id,
              //                                           "Art",
              //                                           style: TextStyle(
              //                                             fontSize: 18,
              //                                             fontWeight:
              //                                                 FontWeight
              //                                                     .w700,
              //                                           ),
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                   Padding(
              //                                     padding:
              //                                         const EdgeInsets.only(
              //                                       top: 10,
              //                                     ),
              //                                     child: Row(
              //                                       children: <Widget>[
              //                                         Container(
              //                                           margin:
              //                                               EdgeInsets.only(
              //                                             left: 15,
              //                                             right: 30,
              //                                           ),
              //                                           child: Text(
              //                                             xdd['post_title'],
              //                                             style: TextStyle(
              //                                               fontSize: 17,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .w500,
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   ),
              //                                   Padding(
              //                                     padding:
              //                                         const EdgeInsets.only(
              //                                       top: 10,
              //                                     ),
              //                                     child: Row(
              //                                       children: <Widget>[
              //                                         Container(
              //                                           width: MediaQuery.of(
              //                                                       context)
              //                                                   .size
              //                                                   .width *
              //                                               0.8,
              //                                           margin:
              //                                               EdgeInsets.only(
              //                                             left: 15,
              //                                             right: 30,
              //                                           ),
              //                                           child: Text(
              //                                             xdd['post_description'] ??
              //                                                 'null',
              //                                             style: TextStyle(
              //                                               fontSize: 15,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .w500,
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   ),
              //                                   Padding(
              //                                     padding:
              //                                         const EdgeInsets.only(
              //                                       top: 10,
              //                                       right: 260,
              //                                     ),
              //                                     child: RaisedButton(
              //                                       splashColor:
              //                                           Colors.purpleAccent,
              //                                       elevation: 2,
              //                                       padding:
              //                                           EdgeInsets.all(12),
              //                                       shape:
              //                                           RoundedRectangleBorder(
              //                                         borderRadius:
              //                                             BorderRadius
              //                                                 .circular(15),
              //                                       ),
              //                                       color: Colors.black,
              //                                       // Color.fromRGBO(
              //                                       //     244,
              //                                       //     217,
              //                                       //     66,
              //                                       //     1),
              //                                       child: Text(
              //                                         'SEE DEAL',
              //                                         style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontSize: 15,
              //                                           fontWeight:
              //                                               FontWeight.w600,
              //                                         ),
              //                                       ),
              //                                       onPressed: () async {
              //                                         // print("hai");
              //                                         // for(var i = 0; i > lis.length; i++)
              //                                         var navigationResult =
              //                                             await Navigator
              //                                                 .push(
              //                                           context,
              //                                           new MaterialPageRoute(
              //                                             builder:
              //                                                 (context) =>
              //                                                     Deal(e),
              //                                           ),
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               }),
              //         ));
              //         if (snapshot.connectionState !=
              //             ConnectionState.done) {
              //           return Center(
              //             child: CircularProgressIndicator(),
              //           );
              //         }

              //         if (!snapshot.hasData &&
              //             snapshot.connectionState ==
              //                 ConnectionState.done) {
              //           return Text('No Posts');
              //         }
              //       }
              //     }),
            ]),
          ],
        ),
      ),
    );
  }
}

class Like extends StatefulWidget {
  final PostContent model;
  final Stream<int> stream;
  Like({this.stream, this.model});

  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {
  String user_id, valuee, follow_user_one;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      follow_user_one = preferences.getString("user_id");
    });
  }

  // int secondsToDisplay = 0;

  // void _updateSeconds(int newSeconds) {
  //   setState(() {
  //     secondsToDisplay = newSeconds;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   widget.stream.listen((seconds) {
  //     _updateSeconds(seconds);
  //   });
  // }

  var loading = false;
  final list = new List<PostContent>();
  Future<void> _lihatDataPost() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.peluangPost, body: {
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
          api['block_status_user'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Column(
        //   children: <Widget>[
        //     for(var i = 0; i < list.length; i++)
        //     Icon(
        //       list[i].like_status_user == null
        //           ? Icons.favorite_border
        //           : Icons.favorite,
        //       color: list[i].like_status_user == null
        //           ? Colors.black
        //           : Color.fromRGBO(244, 217, 66, 1),
        //     ),
        //   ],
        // );
        Row(
      children: <Widget>[
        for (var i = 0; i < list.length; i++)
          IconButton(
            icon: Icon(
              list[i].like_status_user == null
                  ? Icons.favorite_border
                  : Icons.favorite,
              color: list[i].like_status_user == null
                  ? Colors.black
                  : Color.fromRGBO(244, 217, 66, 1),
            ),
            iconSize: 30,
            onPressed: () async {
              await getPref();
              final response = await http.post(LikeUrl.addLike, body: {
                // "post_cat_id" : post_cat_id,
                "user_id": user_id,
                "post_id": list[i].post_id,
                // "follow_status": followed,
              });
              final data = jsonDecode(response.body);
              int value = data['value'];
              String pesan = data['message'];
              if (value == 1) {
                print(pesan);
                setState(() {
                  // liked = !liked;
                  list[i].like_status_user != null;
                });
              } else {
                print(pesan);
              }
              // follow();
            },
          ),
        for (var i = 0; i < list.length; i++)
          Text(
            list[i].jumlahLike ?? '0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
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
