import 'dart:convert';

import 'package:dipena/auth/login/login_page.dart';
import 'package:dipena/inside_app/home/details.dart';
import 'package:dipena/inside_app/profile/followers.dart';
import 'package:dipena/inside_app/profile/following.dart';
import 'package:dipena/inside_app/profile/sidebar/edit_profile.dart';
import 'package:dipena/model/countFollow.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dipena/model/profilePost.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String view = "post";

  String post_detail_id;
  Widget viewPost() {
    if (view == 'post') {
      return listt.isEmpty
          ? Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/img/warning.png",
                      width: 50,
                      height: 50,
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
                  for (var i = 0; i < listt.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          post_detail_id = listt[i].post_id;
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
                          ImageUrl.imageContent + listt[i].post_img,
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
              for (var i = 0; i < list.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: list.isEmpty ||
                          list[i].location_city == "" ||
                          list[i].location_country == ""
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
                      // list[i].location_city == "" && list[i].location_country == null ?
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
                            for (var i = 0; i < list.length; i++)
                              // Text(
                              //   // "Jakarta, Indonesia",
                              //   list[i].location_city,
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontFamily: "Poppins Regular",
                              //   ),
                              // ),
                              RichText(
                                text: TextSpan(
                                    text: list[i].location_city,
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
                                          text: list[i].location_country,
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
                      "$user_email",
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
                            "You doesn't have a bio yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Regular",
                            ),
                          )
                        : Text(
                            // "Aku adalah anak gembala, selalu riang serta gembira.",
                            "$user_bio",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Regular",
                            ),
                          )
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

  String user_username,
      user_fullname,
      user_email,
      user_bio,
      user_id,
      location_user_id,
      location_id,
      location_country,
      location_city,
      user_img;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      location_user_id = preferences.getString('user_id');
      user_fullname = preferences.getString("user_fullname");
      user_username = preferences.getString("user_username");
      user_email = preferences.getString("user_email");
      user_bio = preferences.getString("user_bio");
      user_img = preferences.getString("user_img");
    });
  }

  var loadinggg = false;
  final listFollow = new List<CountFollow>();
  Future<void> _countFollow() async {
    await getPref();
    listFollow.clear();
    setState(() {
      loadinggg = true;
    });
    final response = await http.post(FollowUrl.countFollow, body: {
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
        final ab = new CountFollow(api['following'], api['follower']);
        listFollow.add(ab);
      });
      setState(() {
        loadinggg = false;
      });
    }
  }

  var loadingg = false;
  final listt = new List<PostProfile>();
  Future<void> _lihatDataPostProfile() async {
    await getPref();
    listt.clear();
    setState(() {
      loadingg = true;
    });
    final response = await http.post(PostUrl.selectPostProfile, body: {
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
        loadingg = false;
      });
    }
  }

  var loading = false;
  final list = new List<LocationModel>();
  Future<void> _lihatData() async {
    await getPref();
    list.clear();
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
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _countFollow();
    _lihatDataPostProfile();
    _lihatData();
  }

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
      endDrawer: Drawer(
        child: DrawerHeader(
          child: list.isEmpty
              ? Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.supervised_user_circle),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 16, fontFamily: "Poppins Regular"),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => EditProfile(
                                LocationModel(location_country, location_city),
                                getPref),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 25,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 16, fontFamily: "Poppins Regular"),
                      ),
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Settings()));
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListTile(
                            dense: true,
                            leading:
                                // Icon(Icons.search,
                                Icon(Icons.do_not_disturb_alt),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "Poppins Regular"),
                            ),
                            onTap: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                preferences.setInt('value', null);
                                preferences.commit();
                                _loginStatus = LoginStatus.notSignIn;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext ctx) =>
                                          LoginPage()));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    for (var i = 0; i < list.length; i++)
                      ListTile(
                        dense: true,
                        leading: Icon(Icons.supervised_user_circle),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 16, fontFamily: "Poppins Regular"),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                                  EditProfile(list[i], getPref),
                            ),
                          );
                        },
                      ),
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 25,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 16, fontFamily: "Poppins Regular"),
                      ),
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Settings()));
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListTile(
                            dense: true,
                            leading:
                                // Icon(Icons.search,
                                Icon(Icons.do_not_disturb_alt),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "Poppins Regular"),
                            ),
                            onTap: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                preferences.setInt('value', null);
                                preferences.commit();
                                _loginStatus = LoginStatus.notSignIn;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext ctx) =>
                                          LoginPage()));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontFamily: "Poppins Regular"),
        ),
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
                        top: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            // 'Tia Nurmala',
                            '$user_fullname',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Semibold",
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              '@$user_username',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins Regular"),
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
                                  builder: (context) => Followers()));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Following()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: listFollow.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // for (var i = 0; i < listFollow.length; i++)
                                    Text(
                                      '0',
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
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => Details()));
        //   },
        //   child: Container(
        //     margin: EdgeInsets.all(0),
        //     padding: EdgeInsets.all(0),
        //     child: Image.asset(
        //       photo2,
        //       width: MediaQuery.of(context).size.width / 3,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => Details()));
        //   },
        //   child: Container(
        //     margin: EdgeInsets.all(0),
        //     padding: EdgeInsets.all(0),
        //     child: Image.asset(
        //       photo3,
        //       width: MediaQuery.of(context).size.width / 3,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
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

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
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
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Poppins Regular",
                    ),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => Privacy(),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.lock_outline),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Privacy",
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => Help(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.help_outline),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Help",
                        style: new TextStyle(
                            fontSize: 18.0, fontFamily: "Poppins Regular")),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => About(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.info_outline),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "About",
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
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
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Privacy',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Poppins Regular"),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                  //  Color.fromRGBO(244, 217, 61, 1),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => BlockedAccounts(),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.block),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Blocked Accounts",
                        style: new TextStyle(
                            fontSize: 18.0, fontFamily: "Poppins Regular")),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockedAccounts extends StatefulWidget {
  @override
  _BlockedAccountsState createState() => _BlockedAccountsState();
}

class _BlockedAccountsState extends State<BlockedAccounts> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  String user_id;

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        minRadius: 20, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
        key: _scaffoldkey,
        body: ListView(
          primary: true,
          children: <Widget>[
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
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Blocked Users',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Poppins Regular"),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
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
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'About',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Poppins Regular"),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => DataPolicy(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  // Icon(Icons.block),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Data Policy",
                        style: new TextStyle(
                            fontSize: 18.0, fontFamily: "Poppins Regular")),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => TermsOfUse(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  // Icon(Icons.block),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Terms of Use",
                        style: new TextStyle(
                            fontSize: 18.0, fontFamily: "Poppins Regular")),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataPolicy extends StatefulWidget {
  @override
  _DataPolicyState createState() => _DataPolicyState();
}

class _DataPolicyState extends State<DataPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      primary: true,
      children: <Widget>[
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
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Poppins Regular"),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
                color: Color.fromRGBO(244, 217, 66, 4),
                height: MediaQuery.of(context).size.height / 5,
                child:
                    Center(child: Image.asset("assets/img/dipena_logo.png"))),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Center(
                  child: Text("Data Policy",
                      style: new TextStyle(
                          fontFamily: "Poppins Bold", fontSize: 20.0))),
            ),
            Divider(
              color: Colors.black,
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                child: Text(
                    "We collect the content, communications and other information you provide when you use dipena, including when you sign up for an account, create or share content, and message or communicate with others. We collect such data as name, email address, country, city, IP address, mobile device ID, and any content and communications through dipena. ",
                    textAlign: TextAlign.justify,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontFamily: "Poppins Regular")),
              ),
            ),
            Container(
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                  child: RichText(
                    text: TextSpan(
                        text:
                            'Please feel free to have any inquiries regarding on terms of use or data policy on ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontFamily: "Poppins Regular"),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'halo@dipena.com',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: "Poppins Regular")),
                        ]),
                  )
                  // Text(
                  //     "Please feel free to have any inquiries regarding on terms of use or data policy on halo@dipena.com",
                  //     style: new TextStyle(fontSize: 15.0)),
                  ),
            )
          ],
        )
      ],
    ));
  }
}

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      primary: true,
      children: <Widget>[
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
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Terms of Use',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Poppins Regular"),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
                color: Color.fromRGBO(244, 217, 66, 4),
                height: MediaQuery.of(context).size.height / 5,
                child:
                    Center(child: Image.asset("assets/img/dipena_logo.png"))),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
              child: Text("Terms of Use",
                  style: new TextStyle(
                      fontFamily: "Poppins Bold", fontSize: 20.0)),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text("Dear the one who will change the world",
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text("Welcome to dipena!",
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We, as a social network in the scope of creative industry, are doing our best on connecting people with opportunities. And this terms of use will guide you on how we govern the community of dipena to create a sustainable ecosystem. When you signed up for dipena and join the community, you agree with all the terms of use below.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 45.0, right: 45.0),
              child: Text("HOW CAN YOU USE DIPENA?",
                  style: new TextStyle(
                      fontSize: 15.0, fontFamily: "Poppins Bold")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We are providing a platform for creative people can share their art in a way people can see it as an opportunities, not only an art. We are doing our best to connecting creative people to the society on business purposes, because we believe that every single thing need to be shaped beautifully. And dipena is all about connecting an opportunities in the scope of creative industry.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	For painter, designer, and photographer.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "Share your vision and prove it with your art. We genuinely believe that you are not only deserve likes and comments on every post that have posted in your othe social media, but you should get more project and meet with new potential people that could change your life. And so, being as a social network that push you to express yourself on business purposes is what we’re interested in. You’ll be guided on creating a post that will be implified as an opportunities by the society, because you will fill up your service deals every time you want to post your art. ",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	For everyone",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We bring you closer to the poeple that might work with you to change the world. And we encourage you to “take deals” on every post that you might interest on and communicate with them on our platform. Help us to create this sustainable ecosystem and together change this messy world to be a better place to live. ",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 45.0, right: 45.0),
              child: Text("HOW CAN'T YOU USE DIPENA?",
                  style: new TextStyle(
                      fontSize: 15.0, fontFamily: "Poppins Bold")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	We are not e-commerce",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "As a social network, it means that we’re connecting the society. Please be conscious that this is not an e-commerce where you can sell goods to your audience and it’s a pleasure for us if you can use it the way it should be. ",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	Content prohibited",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We don’t give a tolerance for any content that consist any of :",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontFamily: "Poppins Regular")),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("1.	Pornographic content",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                    Text("2.	Highly explicit nudity",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                    Text("3.	Hate speech post or comment",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                    Text("4.	Harrassment and threats",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                    Text("5.	Illegal activities or goods",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                    Text("6.	Graphic violence",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                    Text("7.	Spam",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: "Poppins Regular")),
                  ],
                )),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => ReportingAccountOrPost(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                      text:
                          'Please note that we will abolish every post which consist any one of above criteria, and we will act less than 24 hours on ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontFamily: "Poppins Regular"),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'report ',
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Poppins Regular")),
                        TextSpan(
                            text:
                                'from our users that indicate content prohibited.',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins Regular")),
                      ]),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 45.0, right: 45.0),
              child: Container(),
            )
          ],
        )
      ],
    ));
  }
}

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
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
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Help',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Poppins Regular"),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => BlockingAccount(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                // Icon(Icons.block),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Blocking Accounts",
                      style: new TextStyle(
                          fontSize: 18.0, fontFamily: "Poppins Regular")),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ReportingAccountOrPost(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                // Icon(Icons.block),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Reporting Accounts or Posts",
                      style: new TextStyle(
                          fontSize: 18.0, fontFamily: "Poppins Regular")),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class BlockingAccount extends StatefulWidget {
  @override
  _BlockingAccountState createState() => _BlockingAccountState();
}

class _BlockingAccountState extends State<BlockingAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        primary: true,
        children: <Widget>[
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
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Blocking Accounts',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Poppins Regular"),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  color: Color.fromRGBO(244, 217, 66, 4),
                  height: MediaQuery.of(context).size.height / 5,
                  child:
                      Center(child: Image.asset("assets/img/dipena_logo.png"))),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
                child: Text("Block an Account",
                    style: new TextStyle(
                        fontFamily: "Poppins Bold", fontSize: 20.0)),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                child: Text("How to block user :",
                    textAlign: TextAlign.justify,
                    style: new TextStyle(fontFamily: "Poppins Regular")),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to User Profile.",
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the",
                              textAlign: TextAlign.justify,
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                          Icon(Icons.more_vert),
                          Text(" In the top right corner",
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify,
                            style:
                                new TextStyle(fontFamily: "Poppins Regular")),
                      ),
                      Text('3.	Then choose "Block" to block user.',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 25.0, left: 45.0, right: 45.0),
                child: Text("How to unblock users :",
                    textAlign: TextAlign.justify,
                    style: new TextStyle(fontFamily: "Poppins Regular")),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to Profile Tab in the bottom right ",
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("corner of the screen.",
                            textAlign: TextAlign.justify,
                            style:
                                new TextStyle(fontFamily: "Poppins Regular")),
                      ),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the",
                              textAlign: TextAlign.justify,
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                          Icon(Icons.dehaze),
                          Text(" In the top right corner",
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify,
                            style:
                                new TextStyle(fontFamily: "Poppins Regular")),
                      ),
                      Text('3.	Then choose "Settings".',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Text('4.	Then choose "Privacy".',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Text('5.	After that choose "Blocked Accounts".',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Text(
                          '6.	Then choose which account that you want to get unblocked by click "Unblock".',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class ReportingAccountOrPost extends StatefulWidget {
  @override
  _ReportingAccountOrPostState createState() => _ReportingAccountOrPostState();
}

class _ReportingAccountOrPostState extends State<ReportingAccountOrPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        primary: true,
        children: <Widget>[
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
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reporting Accounts or Posts',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Poppins Regular"),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  color: Color.fromRGBO(244, 217, 66, 4),
                  height: MediaQuery.of(context).size.height / 5,
                  child:
                      Center(child: Image.asset("assets/img/dipena_logo.png"))),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
                child: Text("Reporting Account or Post",
                    style: new TextStyle(
                        fontFamily: "Poppins Bold", fontSize: 20.0)),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                child: Text("How to report posts :",
                    textAlign: TextAlign.justify,
                    style: new TextStyle(fontFamily: "Poppins Regular")),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to the post that you want to report.",
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the",
                              textAlign: TextAlign.justify,
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                          Icon(Icons.more_vert),
                          Text(" In the bottom right corner",
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("below the post image.",
                            textAlign: TextAlign.justify,
                            style:
                                new TextStyle(fontFamily: "Poppins Regular")),
                      ),
                      Text('3.	Then choose "Report" to report post.',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 25.0, left: 45.0, right: 45.0),
                child: Text("How to Report an Account :",
                    textAlign: TextAlign.justify,
                    style: new TextStyle(fontFamily: "Poppins Regular")),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to the Account/User Profile.",
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the",
                              textAlign: TextAlign.justify,
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                          Icon(Icons.more_vert),
                          Text(" In the top right corner",
                              style:
                                  new TextStyle(fontFamily: "Poppins Regular")),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify,
                            style:
                                new TextStyle(fontFamily: "Poppins Regular")),
                      ),
                      Text('3.	Then choose "Report" to report ',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("Account/User.",
                            textAlign: TextAlign.justify,
                            style:
                                new TextStyle(fontFamily: "Poppins Regular")),
                      ),
                      Text(
                          '4.	Then choose the reason why you reported the account.',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(fontFamily: "Poppins Regular")),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
