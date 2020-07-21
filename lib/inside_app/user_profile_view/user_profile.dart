import 'dart:convert';

import 'package:dipena/inside_app/chat/chat_user_profile.dart';
import 'package:dipena/inside_app/home/details.dart';
import 'package:dipena/inside_app/user_profile_view/user_followers.dart';
import 'package:dipena/model/anotherProfile.dart';
import 'package:dipena/model/countFollow.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/model/profilePost.dart';
import 'package:dipena/model/selectAnotherUserProfileModel.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  final String user_id;
  UserProfile(this.user_id);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String user_id,
      user_fullname,
      user_username,
      user_img,
      user_bio,
      user_email,
      user_id_login;
  final GlobalKey<RefreshIndicatorState> _refreshFollow =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id_login = preferences.getString("user_id");
      // user_username = preferences.getString("user_username");
      // follow_user_one = preferences.getString("user_id");
    });
  }

  var loadingg = false;
  // String user_username;
  final listt = new List<SelectAnotherUserProfile>();
  Future<void> _selectProfile() async {
    // await getPref();
    listt.clear();
    setState(() {
      loadingg = true;
    });
    final response = await http.post(
        "https://dipena.com/flutter/api/post/selectUserProfile2_0.php",
        body: {
          'user_id': widget.user_id,
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
        final abc = new SelectAnotherUserProfile(
          api['user_id'],
          api['user_fullname'],
          api['user_username'],
          api['user_email'],
          api['user_bio'],
          api['user_img'],
        );
        listt.add(abc);
      });
      setState(() {
        for (var i = 0; i < listt.length; i++) {
          user_username = listt[i].user_username;
          user_fullname = listt[i].user_fullname;
          user_img = listt[i].user_img;
          user_bio = listt[i].user_bio;
          user_email = listt[i].user_email;
          // report_user_image = another_list[i].user_img;
          // block_user_two = another_list[i].user_id;
        }
        loadingg = false;
      });
    }
  }

  var loading = false;
  final list = new List<PostProfile>();
  Future<void> _lihatDataPostProfile() async {
    // await getPref();
    listt.clear();
    setState(() {
      loadingg = true;
    });
    final response = await http.post(PostUrl.selectPostProfile, body: {
      'user_id': widget.user_id,
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
        list.add(abc);
      });
      setState(() {
        loading = false;
      });
    }
  }

  var loadingLoc = false;
  final listLoc = new List<LocationModel>();
  Future<void> _lihatDataLoc() async {
    // await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(EditProfileUrl.selectUserLocation, body: {
      "user_id": widget.user_id,
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
        listLoc.add(ab);
      });
      setState(() {
        loadingLoc = false;
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
          "user_id": user_id_login,
          "post_user_id": widget.user_id,
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

  var loadinggg = false;
  final listFollow = new List<CountFollow>();
  Future<void> _countFollow() async {
    // await getPref();
    listFollow.clear();
    setState(() {
      loadinggg = true;
    });
    final response = await http.post(FollowUrl.countFollow, body: {
      "user_id": widget.user_id,
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
        loadinggg = false;
      });
    }
  }

  Widget _loading(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
          title: Text("Please Wait..."),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                // height: 50,
                // width: 50,
                child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }

  String view = "post";
  String post_detail_id;
  Widget viewPost() {
    if (view == 'post') {
      return list.isEmpty
          ? Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/img/warning.png"
                    ),
                    SizedBox(height: 10),
                    Center(child: Text("You Haven't Post Anything Yet")),
                  ],
                )),
              ),
          )
          : Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: Wrap(
                // physics: const NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                children: <Widget>[
                  // listt.isEmpty ?
                  for (var i = 0; i < list.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          post_detail_id = list[i].post_id;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(post_detail_id)));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(0),
                        child: Image.network(
                          ImageUrl.imageContent + list[i].post_img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  // new Photo(
                  //   photo1: 'assets/img/post_one.jpg',
                  //   photo2: 'assets/img/post_two.jpg',
                  //   photo3: 'assets/img/post_one.jpg',
                  // ),
                  // new Photo(
                  //   photo1: 'assets/img/post_one.jpg',
                  //   photo2: 'assets/img/post_two.jpg',
                  //   photo3: 'assets/img/post_one.jpg',
                  // ),
                ],
              ),
            );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var i = 0; i < listLoc.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: listLoc.isEmpty ||
                          listLoc[i].location_city == "" ||
                          listLoc[i].location_country == ""
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Belum ada Kota/Negara",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins Regular",
                              ),
                            ),
                          ],
                        )
                      :
                      // listLoc[i].location_city == "" && listLoc[i].location_country == null ?
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                            ),
                            for (var i = 0; i < listLoc.length; i++)
                              // Text(
                              //   // "Jakarta, Indonesia",
                              //   listLoc[i].location_city,
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontFamily: "Poppins Regular",
                              //   ),
                              // ),
                              RichText(
                                text: TextSpan(
                                    text: listLoc[i].location_city,
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontSize: 13.0,
                                        fontFamily: "Poppins Regular"),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ', ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins Regular")),
                                      TextSpan(
                                          text: listLoc[i].location_country,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins Regular")),
                                    ]),
                              )
                          ],
                        ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Icon(
                        Icons.mail,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      // "tianurmala64@gmail.com",
                      user_email ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        "About",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins Semibold",
                          fontSize: 18,
                        ),
                      ),
                    ),
                    user_bio == null || user_bio == ""
                        ? Text(
                            // "Aku adalah anak gembala, selalu riang serta gembira.",
                            "Doesn't have a bio yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Regular",
                            ),
                          )
                        : Text(
                            // "Aku adalah anak gembala, selalu riang serta gembira.",
                            user_bio ?? "Doesn't have a bio yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Regular",
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Color isActiveButtonColor(String viewName) {
    if (view == viewName) {
      return Colors.black;
    } else {
      return Colors.black26;
    }
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _selectProfile();
    _lihatDataPostProfile();
    _lihatDataLoc();
    _countFollow();
    _followStatus();
  }

  String user_chat_id;

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage(
        'assets/img/icon_two.png',
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black),
        title: RichText(
          text: TextSpan(
              text: '@',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: "Poppins Semibold"),
              children: <TextSpan>[
                TextSpan(
                    text: user_username,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins Semibold",
                      fontSize: 15,
                    )),
              ]),
        ),
        // Text(
        //   // '@tianurmala_',
        //   user_username ?? "",
        //   style: TextStyle(
        //       fontSize: 15,
        //       color: Colors.black,
        //       fontFamily: "Poppins Semibold"),
        // ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        child: ListView(
          primary: true,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RefreshIndicator(
                                  onRefresh: _followStatus,
                                  key: _refreshFollow,
                                  child: Container(),
                                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        top: 30,
                      ),
                      child: user_img == null
                          ? placeholder
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                ImageUrl.imageProfile + user_img,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        top: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              // 'Tia Nurmala',
                              user_fullname ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins Semibold",
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Row(
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: 130,
                                  height: 30,
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      color: Color(0xFFF39C12),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Message",
                                      style: TextStyle(
                                        color: Color(0xFFF39C12),
                                        fontSize: 12,
                                        fontFamily: "Poppins Regular",
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        user_chat_id = widget.user_id;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatUserProfile(
                                                      user_chat_id)));
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Container(
                                //   color: status == null
                                //       ? Colors.white
                                //       : Color(0xFFF39C12),
                                //   child:
                                status == null ?
                                ButtonTheme(
                                  minWidth: 50,
                                  height: 30,
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      color: status == null
                                          ? Color(0xFFF39C12)
                                          : Colors.black,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      status == null
                                          ? Icons.person_add
                                          : Icons.person,
                                      color: status == null
                                          ? Color(0xFFF39C12)
                                          : Colors.black,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _loading(context),
                                      );
                                      await getPref();
                                      final response = await http
                                          .post(FollowUrl.follow, body: {
                                        // "post_cat_id" : post_cat_id,
                                        "user_id": user_id_login,
                                        "follow_user_one": user_id_login,
                                        "valuee": widget.user_id,
                                        "follow_user_two": widget.user_id,
                                        // "follow_status": followed,
                                      });
                                      final data = jsonDecode(response.body);
                                      int value = data['value'];
                                      String pesan = data['message'];
                                      if (value == 1) {
                                        
                                        print(pesan);
                                        Navigator.pop(context);
                                        // setState(
                                        //     () {
                                        //   xdd['follow_status_user'] !=
                                        //       null;
                                        // });
                                        _refreshFollow.currentState.show();
                                        for(var i = 0; i < follow_status.length; i++)
                                        follow_status[i].follow_status != null;
                                      } else {
                                        print(pesan);
                                        Navigator.pop(context);
                                        _refreshFollow.currentState.show();
                                      }
                                    },
                                  ),
                                ) : 
                                ButtonTheme(
                                  minWidth: 50,
                                  height: 30,
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      color: status == null
                                          ? Color(0xFFF39C12)
                                          : Colors.black,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      status == null
                                          ? Icons.person_add
                                          : Icons.person,
                                      color: status == null
                                          ? Color(0xFFF39C12)
                                          : Colors.black,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _loading(context),
                                      );
                                      await getPref();
                                      final response = await http
                                          .post(FollowUrl.follow, body: {
                                        // "post_cat_id" : post_cat_id,
                                        "user_id": user_id_login,
                                        "follow_user_one": user_id_login,
                                        "valuee": widget.user_id,
                                        "follow_user_two": widget.user_id,
                                        // "follow_status": followed,
                                      });
                                      final data = jsonDecode(response.body);
                                      int value = data['value'];
                                      String pesan = data['message'];
                                      if (value == 1) {
                                        
                                        print(pesan);
                                        Navigator.pop(context);
                                        // setState(
                                        //     () {
                                        //   xdd['follow_status_user'] !=
                                        //       null;
                                        // });
                                        _refreshFollow.currentState.show();
                                        for(var i = 0; i < follow_status.length; i++)
                                        follow_status[i].follow_status != null;
                                      } else {
                                        print(pesan);
                                        Navigator.pop(context);
                                        _refreshFollow.currentState.show();
                                      }
                                    },
                                  ),
                                ),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    right: 30,
                    left: 30,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // InkWell(
                      //   onTap: () {
                      //     // Navigator.push(
                      //     //     context,
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) => ListCollabs()));
                      //   },
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width / 5,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Text(
                      //           '10',
                      //           style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 20,
                      //             fontFamily: "Poppins Semibold",
                      //           ),
                      //         ),
                      //         Text(
                      //           'Collabs',
                      //           style: TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 15,
                      //               fontFamily: "Poppins Regular"),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   color: Colors.black,
                      //   width: 0.2,
                      //   height: 22,
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserFollowers()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: listFollow.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // for (var i = 0; i < listFollow.length; i++)
                                    // listFollow.isEmpty ?
                                    // for (var i = 0; i < listFollow.length; i++)
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: "Poppins Semibold",
                                      ),
                                    ),
                                    // :
                                    // Text(
                                    //   listFollow[i].follower ?? '0',
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //     fontSize: 20,
                                    //     fontFamily: "Poppins Semibold",
                                    //   ),
                                    // ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "Poppins Regular",
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    for (var i = 0; i < listFollow.length; i++)
                                      // listFollow.isEmpty ?
                                      // for (var i = 0; i < listFollow.length; i++)
                                      // Text(
                                      //   '0',
                                      //   style: TextStyle(
                                      //     color: Colors.black,
                                      //     fontSize: 20,
                                      //     fontFamily: "Poppins Semibold",
                                      //   ),
                                      // ),
                                      // :
                                      Text(
                                        listFollow[i].follower ?? '0',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: "Poppins Semibold",
                                        ),
                                      ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "Poppins Regular",
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        width: 0.2,
                        height: 22,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Following()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '5',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: "Poppins Semibold",
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Poppins Regular",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(color: Colors.grey[300]),
            SizedBox(
              height: 5,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 25.0),
            // child:
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: InkWell(
                      onTap: () {
                        changeView("post");
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ProfilePost()));
                      },
                      child: Icon(
                        Icons.photo_library,
                        color: isActiveButtonColor("post"),
                        // new Color(0xFF7F8C8D),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: InkWell(
                      onTap: () {
                        changeView("info");
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ProfileInfo()));
                      },
                      child: Icon(Icons.info_outline,
                          color: isActiveButtonColor("info")
                          // new Color(0xFF7F8C8D),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            // ),
            SizedBox(
              height: 12.5,
            ),
            // Divider(color: Colors.grey[300]),
            viewPost(),
          ],
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  Photo({this.photo1, this.photo2, this.photo3});
  final String photo1;
  final String photo2;
  final String photo3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Details()));
          },
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Image.asset(
              photo1,
              width: MediaQuery.of(context).size.width / 3,
              fit: BoxFit.fill,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Details()));
          },
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Image.asset(
              photo2,
              width: MediaQuery.of(context).size.width / 3,
              fit: BoxFit.fill,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Details()));
          },
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Image.asset(
              photo3,
              width: MediaQuery.of(context).size.width / 3,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfo extends StatefulWidget {
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Icon(Icons.location_on, color: Colors.black),
                    ),
                    Text(
                      "Jakarta, Indonesia",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Icon(Icons.mail, color: Colors.black),
                    ),
                    Text(
                      "tianurmala64@gmail.com",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        "About",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins Semibold",
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      "Aku adalah anak gembala, selalu riang serta gembira.",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
