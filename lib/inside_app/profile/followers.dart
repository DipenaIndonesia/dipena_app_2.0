import 'dart:convert';

import 'package:dipena/model/profile/followersModel.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// void main() => runApp(Followers());

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
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

  var loading = false;
  final list = new List<FollowersData>();
  Future<void> _lihatDataFollowers() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(
        "https://dipena.com/flutter/api/user/selectUserFollowers.php",
        body: {"user_id": user_id});
    // body: {
    // "user_id": user_id,
    // "user_id": widget.model.post_user_id,
    // });
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
        final ab = new FollowersData(
            api['user_id'],
            api['user_fullname'],
            api['user_username'],
            api['user_bio'],
            api['user_img'],
            api['follow_status']);
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
    _lihatDataFollowers();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image(
          // image: NetworkImage(profile),
          image: AssetImage("assets/img/user_search.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Followers",
          style: TextStyle(color: Colors.black, fontFamily: "Poppins Regular"),
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          final x = list[i];
          return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              // dense: true,
              leading: Container(
                padding: EdgeInsets.all(0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: x.user_img == null
                    ? placeholder
                    : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image(
                            width: 50,
                            height: 50,
                            // image: NetworkImage(profile),
                            image: NetworkImage(
                                ImageUrl.imageProfile + x.user_img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              title: Text(
                // name,
                x.user_fullname,
                style: TextStyle(
                  fontFamily: "Poppins Bold",
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                    text: '@',
                    style: TextStyle(
                        color: Colors.black,
                        // fontSize: 13.0,
                        fontFamily: "Poppins Regular"),
                    children: <TextSpan>[
                      TextSpan(
                          text: x.user_username,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Regular")),
                    ]),
              ),
              // Text(username,
              //     style:
              //         TextStyle(color: Colors.black, fontFamily: "Poppins Regular")),
              trailing: SizedBox(
                width: 100.0,
                height: 30.0,
                child: OutlineButton(
                  borderSide: BorderSide(
                    color: new Color(0xFFF39C12),
                    width: 1.0,
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Details()));
                  },
                  child: Text("Following",
                      style: TextStyle(
                          color: new Color(0xFFF39C12),
                          fontSize: 16.0,
                          fontFamily: "Poppins Regular")),
                  color: Colors.white,
                ),
              ),
              onTap: () {});
        },
        // children: <Widget>[
        // new ListFollowers(
        //   profile:
        //       'https://dipena.com/flutter/assets/images/Profile_Icon_7.jpg',
        //   name: "Tia Nurmala",
        //   username: "@ttiamala",
        // ),
        // new ListFollowers(
        //   profile:
        //       'https://dipena.com/flutter/assets/images/Profile_Icon_4.jpg',
        //   name: "Taye",
        //   username: "@tianurmala_",
        // ),
        // new ListFollowers(
        //   profile:
        //       'https://dipena.com/flutter/assets/images/Profile_Icon_5.jpg',
        //   name: "Baby",
        //   username: "@babyRoxann",
        // ),
        // new ListFollowers(
        //   profile:
        //       'https://dipena.com/flutter/assets/images/Profile_Icon_2.jpg',
        //   name: "Mala",
        //   username: "@keykim",
        // ),
        // new ListFollowers(
        //   profile:
        //       'https://dipena.com/flutter/assets/images/Profile_Icon_6.jpg',
        //   name: "Adam",
        //   username: "@adam_traceurs",
        // ),
        // new ListFollowers(
        //   profile:
        //       'https://dipena.com/flutter/assets/images/Profile_Icon_3.jpg',
        //   name: "Joe",
        //   username: "@joesnadya",
        // ),
        // ],
      ),
    );
  }
}

class ListFollowers extends StatelessWidget {
  ListFollowers({this.profile, this.name, this.username});
  final String profile;
  final String name;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        // dense: true,
        leading: Container(
          padding: EdgeInsets.all(0),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image(
                image: NetworkImage(profile),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontFamily: "Poppins Bold",
          ),
        ),
        subtitle: Text(username,
            style:
                TextStyle(color: Colors.black, fontFamily: "Poppins Regular")),
        trailing: SizedBox(
          width: 100.0,
          height: 30.0,
          child: OutlineButton(
            borderSide: BorderSide(
              color: new Color(0xFFF39C12),
              width: 1.0,
            ),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.all(0),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => Details()));
            },
            child: Text("Follow",
                style: TextStyle(
                    color: new Color(0xFFF39C12),
                    fontSize: 16.0,
                    fontFamily: "Poppins Regular")),
            color: Colors.white,
          ),
        ),
        onTap: () {});
  }
}
