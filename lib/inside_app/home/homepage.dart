import 'dart:convert';

import 'package:dipena/inside_app/chat/listchat.dart';
import 'package:dipena/inside_app/home/comment.dart';
import 'package:dipena/inside_app/home/details.dart';
import 'package:dipena/inside_app/home/home_collablist.dart';
import 'package:dipena/inside_app/user_profile_view/user_profile.dart';
import 'package:dipena/model/anotherProfile.dart';
import 'package:dipena/model/selectPostFollow.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String user_id,
      valuee,
      follow_user_one,
      user_username,
      location_country,
      location_city,
      user_profile_id,
      user_profile_fullname,
      user_profile_username,
      user_profile_img;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      user_username = preferences.getString("user_username");
      follow_user_one = preferences.getString("user_id");
    });
  }

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
      // await http.post("https://dipena.com/flutter/api/updateProfile.php");
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
          api['user_fullname'],
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

  final GlobalKey<RefreshIndicatorState> _refreshFollow =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshHome =
      GlobalKey<RefreshIndicatorState>();
  var loadingg = false;
  final listt = new List<AnotherProfileData>();
  Future<void> _lihatData() async {
    await getPref();
    listt.clear();
    setState(() {
      loadingg = true;
    });
    final response = await http.post(
        "https://dipena.com/flutter/api/suggestion/selectUserSuggest.php",
        body: {
          "user_id": user_id,
          // "user_id": widget.model.post_user_id,
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
        final ab = new AnotherProfileData(
          api['user_id'],
          api['user_fullname'],
          api['user_username'],
          api['user_bio'],
          api['user_img'],
          api['follow_status_user'],
        );
        listt.add(ab);
      });
      setState(() {
        loadingg = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatDataPostFollow();
    _lihatData();
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

  String post_detail_id;

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
      backgroundColor: Color(0xFF7F8C8D),
      child: ClipOval(
        child: Image(
          width: 50,
          height: 50,
          image: AssetImage("assets/img/user_search.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dipena",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "Poppins Medium",
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              child: Ink.image(
                image: AssetImage(
                  "assets/img/chat_icon.png",
                ),
                width: 25,
                height: 25,
              ),
              onTap: () async {
                var navigationResult = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => ListChat(),
                  ),
                );
                if (navigationResult == true) {
                  MaterialPageRoute(
                    builder: (context) => ListChat(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: list.isEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RefreshIndicator(
                        onRefresh: _lihatData,
                        key: _refreshFollow,
                        child: Container()),
                    RefreshIndicator(
                        onRefresh: _lihatDataPostFollow,
                        key: _refreshHome,
                        child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "People We Recommend",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Poppins Semibold",
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Find out more people on explore,\n Follow and Collabs with Others!",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins Regular",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          color: Color(0xFFF1F2F6),
                          width: MediaQuery.of(context).size.width / 1,
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 5),
                                // Text(
                                //   "People you might know",
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 13,
                                //     fontFamily: "Poppins Medium",
                                //   ),
                                // ),
                                // SizedBox(height: 8),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listt.length,
                                    itemBuilder: (context, i) => Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          child: Card(
                                            elevation: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                listt[i].user_img == null
                                                    ? placeholder
                                                    : CircleAvatar(
                                                        child: ClipOval(
                                                          child: Image(
                                                            width: 50,
                                                            height: 50,
                                                            image: NetworkImage(
                                                              ImageUrl.imageProfile +
                                                                  listt[i]
                                                                      .user_img,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                SizedBox(height: 5),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                  child: Text(
                                                    listt[i].user_fullname,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontFamily:
                                                          "Poppins Semibold",
                                                    ),
                                                    maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,  
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                  child: Text(
                                                    listt[i].user_username,
                                                    style: TextStyle(
                                                      color: Color(0xFF7F8C8D),
                                                      fontSize: 12,
                                                      fontFamily:
                                                          "Poppins Regular",
                                                    ),
                                                    maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,  
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  color:
                                                      listt[i].follow_status_user ==
                                                              null
                                                          ? Colors.white
                                                          : Color(0xFFF39C12),
                                                  width: 90,
                                                  height: 25,
                                                  child: OutlineButton(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFF39C12),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      listt[i].follow_status_user ==
                                                              null
                                                          ? "Follow"
                                                          : "Followed",
                                                      style: TextStyle(
                                                        color: listt[i]
                                                                    .follow_status_user ==
                                                                null
                                                            ? Color(0xFFF39C12)
                                                            : Colors.white,
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "Poppins Regular",
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _loading(context),
                                                      );
                                                      await getPref();
                                                      final response =
                                                          await http.post(
                                                              FollowUrl.follow,
                                                              body: {
                                                            // "post_cat_id" : post_cat_id,
                                                            "user_id": user_id,
                                                            "follow_user_one":
                                                                user_id,
                                                            "valuee": listt[i]
                                                                .user_id,
                                                            "follow_user_two":
                                                                listt[i]
                                                                    .user_id,
                                                            // "follow_status": followed,
                                                          });
                                                      final data = jsonDecode(
                                                          response.body);
                                                      int value = data['value'];
                                                      String pesan =
                                                          data['message'];
                                                      if (value == 1) {
                                                        print(pesan);
                                                        setState(() {
                                                          // follow = 1;
                                                          Navigator.pop(
                                                              context);
                                                          _refreshFollow
                                                              .currentState
                                                              .show();
                                                          listt[i].follow_status_user !=
                                                              null;
                                                          // text_value = "1";
                                                        });
                                                        // _showToast(
                                                        //     pesan);
                                                      } else if (value == 2) {
                                                        print(pesan);
                                                        setState(() {
                                                          // follow = 0;
                                                          Navigator.pop(
                                                              context);
                                                          _refreshFollow
                                                              .currentState
                                                              .show();
                                                          // text_value = "0";
                                                        });
                                                        // _showToastUnfoll(
                                                        //     pesan);
                                                      } else {
                                                        Navigator.pop(context);
                                                        print(pesan);
                                                        // _showToast(
                                                        //     pesan);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 50,
                          width: 85,
                          child: OutlineButton(
                              borderSide: BorderSide(
                                color: Color(0xFFF39C12),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "Refresh",
                                style: TextStyle(
                                  color: Color(0xFFF39C12),
                                  fontSize: 13,
                                  fontFamily: "Poppins Regular",
                                ),
                              ),
                              onPressed: () {
                                _refreshHome.currentState.show();
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : new Container(
              child:
                  // new ListView(
                  //   children: <Widget>[
                  //     new Post(
                  //       profile: "assets/img/icon_one.jpg",
                  //       nama: "Tia Nurmala",
                  //       username: "@tianurmala",
                  //       post: "assets/img/post_one.jpg",
                  //       kategori: "Designer",
                  //       deskripsi: "Potret sepeda ontel",
                  //     ),
                  //     new Post(
                  //       profile: 'assets/img/icon_two.png',
                  //       nama: "Tia Nurmala",
                  //       username: "@tianurmala",
                  //       post: "assets/img/post_two.jpg",
                  //       kategori: "Painter",
                  //       deskripsi: "Potret sepeda ontel",
                  //     ),
                  //   ],
                  // ),
                  ListView.builder(
                // children: <Widget>[
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            user_profile_id = x.post_user_id;
                            // user_profile_fullname = x.user_fullname;
                            // user_profile_username = x.user_username;
                            // user_profile_img = x.user_img;
                          });
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                                  UserProfile(user_profile_id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: x.user_img == null
                                  ? placeholder
                                  : CircleAvatar(
                                      backgroundColor: Color(0xFF7F8C8D),
                                      child: ClipOval(
                                        child: Image(
                                          width: 50,
                                          height: 50,
                                          image: NetworkImage(
                                              ImageUrl.imageProfile +
                                                  x.user_img),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            title: Text(
                              // nama,
                              x.user_fullname,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Semibold",
                              ),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      text: '@',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: x.user_username,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins Regular",
                                              fontSize: 12,
                                            )),
                                      ]),
                                ),
                                // Text(
                                //   // username,
                                //   x.user_username,
                                //   style: TextStyle(
                                //     color: Color(0xFF7F8C8D),
                                //     fontSize: 14,
                                //     fontFamily: "Poppins Regular",
                                //   ),
                                // ),
                              ],
                            ),
                            // trailing: IconButton(
                            //   icon: Icon(
                            //     Icons.more_horiz,
                            //     color: Color(0xFF7F8C8D),
                            //     size: 35,
                            //   ),
                            //   onPressed: () {},
                            // ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Image(
                          image: NetworkImage(
                              // post,
                              ImageUrl.imageContent + x.post_img),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 17),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Ink.image(
                                image: AssetImage(
                                  "assets/img/handshake.png",
                                ),
                                width: 26,
                                height: 26,
                              ),
                              onTap: () async {
                                var navigationResult = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => HomeCollab(),
                                  ),
                                );
                                if (navigationResult == true) {
                                  MaterialPageRoute(
                                    builder: (context) => HomeCollab(),
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 5),
                            Text(
                              "0",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Regular",
                              ),
                            ),
                            SizedBox(width: 15),
                            InkWell(
                              child: Ink.image(
                                image: AssetImage(
                                  "assets/img/comment.png",
                                ),
                                width: 26,
                                height: 26,
                              ),
                              onTap: () async {
                                var navigationResult = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => Comment(x),
                                  ),
                                );
                                if (navigationResult == true) {
                                  MaterialPageRoute(
                                    builder: (context) => Comment(x),
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 5),
                            Text(
                              // "0",
                              x.jumlahKomen ?? '0',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Regular",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              // kategori,
                              show_cat(x.post_cat_id),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins Semibold",
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                // deskripsi,
                                x.post_description,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins Regular",
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                    color: new Color(0xFFF39C12),
                                    splashColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: "Poppins Medium",
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        post_detail_id = x.post_id;
                                      });
                                      var navigationResult =
                                          await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) =>
                                              Details(post_detail_id),
                                        ),
                                      );
                                      // if (navigationResult == true) {
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Details(x),
                                      //   );
                                      // }
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },

                // ],
              ),
            ),
    );
  }
}

// class Post extends StatelessWidget {
//   Post({
//     this.profile,
//     this.nama,
//     this.username,
//     this.post,
//     this.kategori,
//     this.deskripsi,
//   });
//   final String profile;
//   final String nama;
//   final String username;
//   final String post;
//   final String kategori;
//   final String deskripsi;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//     );
//   }
// }
