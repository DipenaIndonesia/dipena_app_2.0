import 'dart:convert';

import 'package:dipena/auth/login.dart';
import 'package:dipena/inside_app/deal.dart';
import 'package:dipena/inside_app/seeDealsFromProfile.dart';
import 'package:dipena/model/anotherProfile.dart';
import 'package:dipena/model/countFollow.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/model/profilePost.dart';
import 'package:dipena/model/searchClass.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dipena/inside_app/app_data.dart';
import 'package:dipena/inside_app/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'edit_profile.dart';
import 'history.dart';
import 'makedeal.dart';

class SearchAnotherProfile extends StatefulWidget {
  final SearchClass model;
  // SearchAnotherProfile(this.model);
  // final VoidCallback signOutSearchAnotherProfile;
  SearchAnotherProfile(this.model, {Key key}) : super(key: key);
  @override
  _SearchAnotherProfileState createState() => _SearchAnotherProfileState();
}

class _SearchAnotherProfileState extends State<SearchAnotherProfile> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshFollow =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshCountFollow =
      GlobalKey<RefreshIndicatorState>();

  // signOutProfile() {
  //   setState(() {
  //     widget.signOutProfile();
  //   });
  // }

  Pics pics;

  String user_username,
      user_bio,
      user_id,
      location_user_id,
      location_id,
      location_country,
      location_city,
      user_img,
      user_email;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      location_user_id = preferences.getString('user_id');
      user_username = preferences.getString("user_username");
      user_email = preferences.getString("user_email");
      user_bio = preferences.getString("user_bio");
      user_img = preferences.getString("user_img");
    });
  }

  // Future<List> getMethod() async {
  //   String theUrl = 'http://dipena.com/flutter/api/user/userLocation.php';
  //   var res = await http
  //       .get(Uri.encodeFull(theUrl), headers: {'Accept': 'application/json'});
  //   var responBody = json.decode(res.body);
  //   print(responBody);
  //   return responBody;
  // }

  var loading = false;
  final list = new List<LocationModel>();
  Future<void> _lihatData() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(EditProfileUrl.selectUserLocation, body: {
      // "user_id": user_id,
      "user_id": widget.model.user_id,
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
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  var loadinggg = false;
  final listFollow = new List<CountFollow>();
  Future<void> _countFollow() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(FollowUrl.countFollow, body: {
      // "user_id": user_id,
      "user_id": widget.model.user_id,
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
        final ab = new CountFollow(api['following'], api['follower']);
        listFollow.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  var loadingg = false;
  final listt = new List<PostProfile>();
  Future<void> _lihatDataPostProfile() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(PostUrl.selectPostProfile, body: {
      'user_id': widget.model.user_id,
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
        final abc = new PostProfile(
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
        );
        listt.add(abc);
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
  String profile, report_user_image, block_user_two;
  var another_loading = false;
  final another_list = new List<AnotherProfileData>();
  Future<void> _anotherUserData() async {
    // await getPref();
    another_list.clear();
    setState(() {
      another_loading = true;
    });
    final response = await http.post(
        "https://dipena.com/flutter/api/user/selectAnotherUserProfile.php",
        body: {
          // "user_id": user_id,
          "user_id": widget.model.user_id,
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
        final ab = new AnotherProfileData(api['user_id'], api['user_username'],
            api['user_bio'], api['user_img']);
        another_list.add(ab);
      });
      setState(() {
        for (var i = 0; i < another_list.length; i++) {
          profile = another_list[i].user_username;
          report_user_image = another_list[i].user_img;
          block_user_two = another_list[i].user_id;
        }
        another_loading = false;
      });
    }
  }

  String status;
  var loading_follow = false;
  final follow_status = new List<AnotherProfileFollowStatus>();
  Future<void> _followStatus() async {
    await getPref();
    follow_status.clear();
    setState(() {
      loading_follow = true;
    });
    final response = await http.post(
        "https://dipena.com/flutter/api/user/AnotherUserFollowStatus.php",
        body: {
          "user_id": user_id,
          "post_user_id": widget.model.user_id,
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
        final ab = new AnotherProfileFollowStatus(api['follow_status']);
        follow_status.add(ab);
      });
      setState(() {
        for (var i = 0; i < follow_status.length; i++) {
          status = follow_status[i].follow_status;
        }
        loading_follow = false;
      });
    }
  }

  @override
  void initState() {
    pics = AppData.pics[0];
    super.initState();
    getPref();
    _countFollow();
    _lihatData();
    _lihatDataPostProfile();
    _anotherUserData();
    _followStatus();
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.green,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  String report_user_username, msg;
  report() async {
    await getPref();
    await msg;
    await profile;
    await report_user_image;
    // await report_post_id;
    // await report_post_img;
    final response = await http
        .post("https://dipena.com/flutter/api/user/reportUser.php", body: {
      "user_username": user_username,
      // "user_password": user_password,
      "user_email": user_email,
      "report_user_username": profile,
      "report_user_image": report_user_image,
      "msg": msg
      // "post_id": report_post_id,
      // "post_img": report_post_img
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
      // print(report_post_id);
      _showToast(messageEnglish);
      print(report_user_image);
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

  block() async {
    await getPref();
    await block_user_two;
    final response = await http
        .post("https://dipena.com/flutter/api/block/block.php", body: {
      "block_user_one": user_id,
      "block_user_two": block_user_two,

      // "post_cat_id" : post_cat_id,
      // "user_id":
      //     user_id,
      // "follow_user_one":
      //     user_id,
      // "valuee": x
      //     .post_user_id,
      // "follow_user_two":
      //     x.post_user_id,
      // "follow_status": followed,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String messageEnglish = data['messageEnglish'];
    if (value == 1) {
      Navigator.pop(context);
      // print(pesan);
      // setState(() {
      //   // x.follow_status_user !=
      //   // null;
      // });
      _showToast(messageEnglish);
    } else if (value == 2) {
      Navigator.pop(context);
      // print(pesan);
      // _showToastUnfoll(
      // pesan);
      _showToast(messageEnglish);
    } else {
      Navigator.pop(context);
      // _showToast(pesan);
      _showToast(messageEnglish);
    }
  }

  Widget _popUp(BuildContext context) {
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
                // report();
                Navigator.pop(context);
                _popUpReport();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Report",
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.all(0),
              onPressed: () {
                // report();
                block();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Block",
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
            // for(var i = 0; i < list.length; i++)
            // list[i].post_id == report_post_id ?
          ],
        )),
      ),
    );
  }

  Widget _popUpReport() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              // height: 100,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Center(
                        child: Text("Report",
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                  ),
                  Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Why you reporting this account?",
                            style: new TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        msg = "This is a spam";
                      });
                      report();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("This is a spam",
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal))),
                    ),
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        msg = "This is inappropriate";
                      });
                      report();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("This is inappropriate",
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal))),
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    // ApiService().getProfiles().then((value) => print("value: $value"));
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
      key: _scaffoldkey,
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
      // endDrawer: Drawer(
      //   child: DrawerHeader(
      //       // child: list.isEmpty ?
      //       child:
      //           //
      //           list.isEmpty
      //               ? Column(
      //                   children: <Widget>[
      //                     ListTile(
      //                       leading: Icon(
      //                         Icons.edit,
      //                         color: Color.fromRGBO(244, 217, 66, 1),
      //                         size: 30,
      //                       ),
      //                       title: Text(
      //                         'Edit Profile',
      //                         style: TextStyle(fontSize: 18),
      //                       ),
      //                       onTap: () {
      //                         Navigator.of(context).push(MaterialPageRoute(
      //                             builder: (context) => Edit(LocationModel(
      //                                 location_country, location_city))));
      //                       },
      //                     ),
      //                     ListTile(
      //                       leading: Icon(
      //                         Icons.av_timer,
      //                         color: Color.fromRGBO(244, 217, 66, 1),
      //                         size: 30,
      //                       ),
      //                       title: Text(
      //                         'History',
      //                         style: TextStyle(fontSize: 18),
      //                       ),
      //                       onTap: () async {
      //                         var navigationResult = await Navigator.push(
      //                           context,
      //                           new MaterialPageRoute(
      //                             builder: (context) => History(),
      //                           ),
      //                         );
      //                         if (navigationResult == true) {
      //                           MaterialPageRoute(
      //                             builder: (context) => History(),
      //                           );
      //                         }
      //                       },
      //                     ),
      //                     Padding(
      //                       // padding: MediaQuery.of(context).padding,
      //                       padding: EdgeInsets.only(top: 350),
      //                       child: ListTile(
      //                         leading: Icon(
      //                           Icons.supervised_user_circle,
      //                           color: Color.fromRGBO(244, 217, 66, 1),
      //                           size: 30,
      //                         ),
      //                         title: Text(
      //                           'Logout',
      //                           style: TextStyle(
      //                             fontSize: 18,
      //                           ),
      //                         ),
      //                         onTap: () async {
      //                           SharedPreferences preferences =
      //                               await SharedPreferences.getInstance();
      //                           setState(() {
      //                             preferences.setInt('value', null);
      //                             preferences.commit();
      //                             _loginStatus = LoginStatus.notSignIn;
      //                           });
      //                           Navigator.pushReplacement(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (BuildContext ctx) =>
      //                                       Login()));
      //                         },
      //                       ),
      //                     ),
      //                   ],
      //                 )
      //               : loading
      //                   ? Center(child: CircularProgressIndicator())
      //                   : ListView.builder(
      //                       itemCount: list.length,
      //                       itemBuilder: (context, i) {
      //                         final x = list[i];
      //                         return Container(
      //                           child: Column(
      //                             children: <Widget>[
      //                               ListTile(
      //                                 leading: Icon(
      //                                   Icons.edit,
      //                                   color: Color.fromRGBO(244, 217, 66, 1),
      //                                   size: 30,
      //                                 ),
      //                                 title: Text(
      //                                   'Edit Profile',
      //                                   style: TextStyle(fontSize: 18),
      //                                 ),
      //                                 onTap: () {
      //                                   Navigator.of(context).push(
      //                                       MaterialPageRoute(
      //                                           builder: (context) => Edit(x)));
      //                                 },
      //                               ),
      //                               ListTile(
      //                                 leading: Icon(
      //                                   Icons.av_timer,
      //                                   color: Color.fromRGBO(244, 217, 66, 1),
      //                                   size: 30,
      //                                 ),
      //                                 title: Text(
      //                                   'History',
      //                                   style: TextStyle(fontSize: 18),
      //                                 ),
      //                                 onTap: () async {
      //                                   var navigationResult =
      //                                       await Navigator.push(
      //                                     context,
      //                                     new MaterialPageRoute(
      //                                       builder: (context) => History(),
      //                                     ),
      //                                   );
      //                                   if (navigationResult == true) {
      //                                     MaterialPageRoute(
      //                                       builder: (context) => History(),
      //                                     );
      //                                   }
      //                                 },
      //                               ),
      //                               Padding(
      //                                 // padding: MediaQuery.of(context).padding,
      //                                 padding: EdgeInsets.only(top: 350),
      //                                 child: ListTile(
      //                                   leading: Icon(
      //                                     Icons.supervised_user_circle,
      //                                     color:
      //                                         Color.fromRGBO(244, 217, 66, 1),
      //                                     size: 30,
      //                                   ),
      //                                   title: Text(
      //                                     'Logout',
      //                                     style: TextStyle(
      //                                       fontSize: 18,
      //                                     ),
      //                                   ),
      //                                   onTap: () async {
      //                                     SharedPreferences preferences =
      //                                         await SharedPreferences
      //                                             .getInstance();
      //                                     setState(() {
      //                                       preferences.setInt('value', null);
      //                                       preferences.commit();
      //                                       _loginStatus =
      //                                           LoginStatus.notSignIn;
      //                                     });
      //                                     Navigator.pushReplacement(
      //                                         context,
      //                                         MaterialPageRoute(
      //                                             builder: (BuildContext ctx) =>
      //                                                 Login()));
      //                                   },
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         );
      //                       })),
      // ),
      // body: ListView.builder(
      //   itemCount: list.length,
      //   itemBuilder: (context, i) {
      //     final x = list[i];
      //     return Container(
      //       child: Text(x.location_user_id),
      //     );
      //   }
      // )

      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: Container(
              child: ListView(children: <Widget>[
            Container(
              child: PreferredSize(
                preferredSize: Size.fromHeight(62),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text(
                    '$profile Profile',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      // Color.fromRGBO(244, 217, 66, 1),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                    //  Color.fromRGBO(244, 217, 61, 1),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        size: 25,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => _popUp(context));
                        // _popUpReport();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    for (var i = 0; i < another_list.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          top: 30,
                        ),
                        child: another_list[i].user_bio == null
                            ? placeholder
                            : CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    ImageUrl.imageProfile +
                                        another_list[i].user_img),
                              ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        top: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (var i = 0; i < another_list.length; i++)
                            Text(
                              another_list[i].user_username,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 13,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                  ),
                                  child: list.isEmpty
                                      ? Row(
                                          children: <Widget>[
                                            Text(
                                              'Country: Unknown \n'
                                              'City: Unknown',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                wordSpacing: 2,
                                              ),
                                            ),
                                            // Text(
                                            //   ', ',
                                            //   style: TextStyle(
                                            //     color: Colors.black,
                                            //     letterSpacing: 2,
                                            //     wordSpacing: 2,
                                            //   ),
                                            // ),
                                            // Text(
                                            //   '',
                                            //   style: TextStyle(
                                            //     color: Colors.black,
                                            //     letterSpacing: 2,
                                            //     wordSpacing: 2,
                                            //   ),
                                            // ),
                                          ],
                                        )
                                      : Container(
                                          width: 165,
                                          child: Row(
                                            children: <Widget>[
                                              for (var i = 0;
                                                  i < list.length;
                                                  i++)
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: list[0]
                                                            .location_country,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: ', ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                          TextSpan(
                                                              text: list[0]
                                                                  .location_city,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ]),
                                                  ),
                                                ),
                                              // Text(
                                              //   list[0].location_country,
                                              //   // overflow: TextOverflow.ellipsis,
                                              //   style: TextStyle(
                                              //     fontSize: 13,
                                              //     color: Colors.black,
                                              //     letterSpacing: 2,
                                              //     wordSpacing: 2,
                                              //   ),
                                              // ),
                                              // Text(
                                              //   ', ',
                                              //   style: TextStyle(
                                              //     fontSize: 13,
                                              //     color: Colors.black,
                                              //     letterSpacing: 2,
                                              //     wordSpacing: 2,
                                              //   ),
                                              // ),
                                              // Text(list[0].location_city,
                                              //     // overflow: TextOverflow.ellipsis,
                                              //     style: TextStyle(
                                              //       fontSize: 13,
                                              //       color: Colors.black,
                                              //       letterSpacing: 2,
                                              //       wordSpacing: 2,
                                              //     ),
                                              //     softWrap: false),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Container(
                    color: Color.fromRGBO(244, 217, 66, 1),
                    width: 100,
                    height: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      for (var i = 0; i < another_list.length; i++)
                        another_list[i].user_bio == null
                            ? Text(
                                'Belum ada bio',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            : Text(
                                another_list[i].user_bio,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Column(
                //     children: <Widget>[
                //       // for(var i = 0; i < another_list.length; i++)
                //       Text(
                //         user_bio ?? 'Belum ada bio',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    right: 30,
                    left: 30,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      listFollow.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // for(var i = 0; i < listFollow.length; i++)
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (var i = 0; i < listFollow.length; i++)
                                  Text(
                                    listFollow[i].follower ?? '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                      Container(
                        color: Colors.black,
                        width: 0.2,
                        height: 22,
                      ),
                      listFollow.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // for(var i = 0; i < listFollow.length; i++)
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (var i = 0; i < listFollow.length; i++)
                                  Text(
                                    listFollow[i].following ?? '0',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                      Container(
                        color: Colors.black,
                        width: 0.2,
                        height: 22,
                      ),
                      RefreshIndicator(
                        onRefresh: _followStatus,
                        key: _refreshFollow,
                        child: Container(),
                      ),
                      RefreshIndicator(
                        onRefresh: _countFollow,
                        key: _refreshCountFollow,
                        child: Container(),
                      ),
                      status == null
                          ? RaisedButton(
                              splashColor: Colors.purpleAccent,
                              elevation: 1,
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color:
                                  // Colors.black,
                                  Color.fromRGBO(250, 185, 32, 1),
                              // Color.fromRGBO(244, 217, 66, 1),
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                ),
                              ),
                              onPressed: () async {
                                // var navigationResult = await Navigator.push(
                                //   context,
                                //   new MaterialPageRoute(
                                //     builder: (context) => MakeDeal(),
                                //   ),
                                // );
                                // if (navigationResult == true) {
                                //   MaterialPageRoute(
                                //     builder: (context) => MakeDeal(),
                                //   );
                                // }
                                await getPref();
                                final response =
                                    await http.post(FollowUrl.follow, body: {
                                  // "post_cat_id" : post_cat_id,
                                  "user_id": user_id,
                                  "follow_user_one": user_id,
                                  "valuee": widget.model.user_id,
                                  "follow_user_two": widget.model.user_id,
                                  // "follow_status": followed,
                                });
                                final data = jsonDecode(response.body);
                                int value = data['value'];
                                String pesan = data['message'];
                                if (value == 1) {
                                  print(pesan);
                                  // setState(
                                  //     () {
                                  //   xdd['follow_status_user'] !=
                                  //       null;
                                  // });
                                  _refreshFollow.currentState.show();
                                  _refreshCountFollow.currentState.show();
                                } else {
                                  print(pesan);
                                }
                              },
                            )
                          : RaisedButton(
                              splashColor: Colors.purpleAccent,
                              elevation: 1,
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Color.fromRGBO(250, 185, 32, 1),
                              // Colors.black,
                              // Color.fromRGBO(244, 217, 66, 1),
                              child: Text(
                                'Followed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                ),
                              ),
                              onPressed: () async {
                                await getPref();
                                final response =
                                    await http.post(FollowUrl.follow, body: {
                                  // "post_cat_id" : post_cat_id,
                                  "user_id": user_id,
                                  "follow_user_one": user_id,
                                  "valuee": widget.model.user_id,
                                  "follow_user_two": widget.model.user_id,
                                  // "follow_status": followed,
                                });
                                final data = jsonDecode(response.body);
                                int value = data['value'];
                                String pesan = data['message'];
                                if (value == 1) {
                                  print(pesan);

                                  // setState(
                                  //     () {
                                  //   xdd['follow_status_user'] !=
                                  //       null;
                                  // });
                                  _refreshFollow.currentState.show();
                                  _refreshCountFollow.currentState.show();
                                } else {
                                  print(pesan);
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   child: Wrap(
            //     children: <Widget>[
            //       for (int i = 0; i < AppData.pics.length; i++)
            //         GestureDetector(
            //           child: Container(
            //             height: MediaQuery.of(context).size.width / 3,
            //             width: MediaQuery.of(context).size.width / 3,
            //             decoration: BoxDecoration(
            //               image: DecorationImage(
            //                 image: AssetImage(
            //                   AppData.pics[i].imageUrl,
            //                 ),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),
            // ),
            listt.isEmpty
                ? Center(child: Text("$profile BELUM POST APAPUN"))
                : loadingg
                    ? Center(child: CircularProgressIndicator())
                    :
                    // ListView.builder(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: listt.length,
                    //   itemBuilder: (context, i){
                    //     final b = listt[i];
                    //     return Container(

                    Container(
                        child: Wrap(
                          children: <Widget>[
                            for (var i = 0; i < listt.length; i++)
                              GestureDetector(
                                child: Container(
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          ImageUrl.imageContent +
                                              listt[i].post_img),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  final x = listt[i];
                                  var navigationResult = await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => SeeDealsProfile(x),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
          ]))
          //         );
          //         }
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
