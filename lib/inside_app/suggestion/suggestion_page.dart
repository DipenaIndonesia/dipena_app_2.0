import 'dart:convert';
import 'dart:ffi';

import 'package:dipena/auth/login/login_page.dart';
import 'package:dipena/inside_app/suggestion/suggestion_model.dart';
import 'package:dipena/inside_app/suggestion/suggestion_skip.dart';
import 'package:dipena/model/anotherProfile.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionPage extends StatefulWidget {
  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final GlobalKey<RefreshIndicatorState> _refreshFollow =
      GlobalKey<RefreshIndicatorState>();
  var loading = false;
  final list = new List<AnotherProfileData>();
  Future<void> _lihatData() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
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
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  String user_id;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      // location_user_id = preferences.getString('user_id');
      // user_fullname = preferences.getString("user_fullname");
      // user_username = preferences.getString("user_username");
      // user_email = preferences.getString("user_email");
      // user_bio = preferences.getString("user_bio");
      // user_img = preferences.getString("user_img");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatData();
  }

  int follow;

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

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String text_value;

  follow_text(String text) {
    if (text == "1") {
      return "Followed";
    } else {
      return "Follow";
    }
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Image.asset(
      "assets/img/user_search.png",
      color: Color(0xFF7F8C8D),
      height: 100,
      width: 100,
    );
    var placeholderUser = CircleAvatar(
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image(
          width: 50,
          height: 50,
          image: AssetImage(
            "assets/img/user_search.png",
            // suggestData[i].icon,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
    return WillPopScope(
      //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
      onWillPop: () async {
        Future.value(
            false); //return a `Future` with false value so this route cant be popped or closed.
      },
      child: Scaffold(
        key: _scaffoldkey,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _lihatData,
              key: _refreshFollow,
              child: Container(),
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/user_search.png",
                              color: Color(0xFF7F8C8D),
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              "People We Recommend",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins Semibold",
                              ),
                            ),
                            Text(
                              "These are people \n with most being collabs",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Poppins Regular",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    // itemCount: suggestData.length,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final x = list[i];
                      return Column(
                        children: <Widget>[
                          Divider(
                            height: 5,
                          ),
                          ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: x.user_img == null
                                  ? placeholderUser
                                  : CircleAvatar(
                                      child: ClipOval(
                                        child: Image(
                                          width: 50,
                                          height: 50,
                                          image: NetworkImage(
                                              // suggestData[i].icon,
                                              ImageUrl.imageProfile +
                                                  x.user_img),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    x.user_fullname,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Poppins Semibold",
                                    ),
                                  ),
                                  Text(
                                    x.user_username,
                                    style: TextStyle(
                                      color: Color(0xFF7F8C8D),
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      // "suggestData[i].bio",
                                      x.user_bio ?? "No Bio",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: "Poppins Regular",
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              color: x.follow_status_user == null
                                  ? Colors.white
                                  : Color(0xFFF39C12),
                              width: 85,
                              height: 25,
                              child: OutlineButton(
                                borderSide: BorderSide(
                                  color: Color(0xFFF39C12),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  x.follow_status_user == null
                                      ? "Follow"
                                      : "Followed",
                                  // follow_text(text_value),
                                  style: TextStyle(
                                    color: x.follow_status_user == null
                                        ? Color(0xFFF39C12)
                                        : Colors.white,
                                    fontSize: 13,
                                    fontFamily: "Poppins Regular",
                                  ),
                                ),
                                // ) :
                                // Text(
                                //   "Followed",
                                //   style: TextStyle(
                                //     color: Color(0xFFF39C12),
                                //     fontSize: 13,
                                //     fontFamily: "Poppins Regular",
                                //   ),
                                // ),
                                onPressed: () async {
                                  // setState(() {
                                  //   follow = 1;
                                  // });
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _loading(context),
                                  );
                                  await getPref();
                                  final response =
                                      await http.post(FollowUrl.follow, body: {
                                    // "post_cat_id" : post_cat_id,
                                    "user_id": user_id,
                                    "follow_user_one": user_id,
                                    "valuee": x.user_id,
                                    "follow_user_two": x.user_id,
                                    // "follow_status": followed,
                                  });
                                  final data = jsonDecode(response.body);
                                  int value = data['value'];
                                  String pesan = data['message'];
                                  if (value == 1) {
                                    print(pesan);
                                    setState(() {
                                      follow = 1;
                                      Navigator.pop(context);
                                      _refreshFollow.currentState.show();
                                      x.follow_status_user != null;
                                      // text_value = "1";
                                    });
                                    // _showToast(
                                    //     pesan);
                                  } else if (value == 2) {
                                    print(pesan);
                                    setState(() {
                                      follow = 0;
                                      Navigator.pop(context);
                                      _refreshFollow.currentState.show();
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
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 30,
              right: 0,
              child: follow == 1
                  ? FlatButton(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Color(0xFFF39C12),
                          fontSize: 15,
                          fontFamily: "Poppins Medium",
                        ),
                      ),
                      onPressed: () async {
                        var navigationResult = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                        // if (navigationResult == true) {
                        //   MaterialPageRoute(
                        //     builder: (context) => Homepage(),
                        //   );
                        // }
                      },
                    )
                  : FlatButton(
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: Color(0xFFF39C12),
                          fontSize: 15,
                          fontFamily: "Poppins Medium",
                        ),
                      ),
                      onPressed: () async {
                        var navigationResult = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                        // if (navigationResult == true) {
                        //   MaterialPageRoute(
                        //     builder: (context) => Homepage(),
                        //   );
                        // }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
