import 'dart:convert';

import 'package:dipena/auth/login.dart';
import 'package:dipena/inside_app/deal.dart';
import 'package:dipena/inside_app/seeDealsFromProfile.dart';
import 'package:dipena/model/blockedUser.dart';
import 'package:dipena/model/countFollow.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/model/profilePost.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:dipena/inside_app/app_data.dart';
import 'package:dipena/inside_app/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'edit_profile.dart';
import 'history.dart';
import 'makedeal.dart';

class Profile extends StatefulWidget {
  // final VoidCallback signOutProfile;
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final GlobalKey<RefreshIndicatorState> _refresh =
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
      user_img;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      location_user_id = preferences.getString('user_id');
      user_username = preferences.getString("user_username");
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

  var loadinggg = false;
  final listFollow = new List<CountFollow>();
  Future<void> _countFollow() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
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

  @override
  void initState() {
    pics = AppData.pics[0];
    super.initState();
    getPref();
    _countFollow();
    _lihatData();
    _lihatDataPostProfile();
  }

  @override
  Widget build(BuildContext context) {
    // ApiService().getProfiles().then((value) => print("value: $value"));
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
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
      endDrawer: Drawer(
        child: DrawerHeader(
            // child: list.isEmpty ?
            child:
                //
                list.isEmpty
                    ? Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.edit,
                              color: Color.fromRGBO(244, 217, 66, 1),
                              size: 30,
                            ),
                            title: Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Edit(LocationModel(
                                      location_country, location_city))));
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.av_timer,
                              color: Color.fromRGBO(244, 217, 66, 1),
                              size: 30,
                            ),
                            title: Text(
                              'History',
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () async {
                              var navigationResult = await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => History(),
                                ),
                              );
                              if (navigationResult == true) {
                                MaterialPageRoute(
                                  builder: (context) => History(),
                                );
                              }
                            },
                          ),
                          Padding(
                            // padding: MediaQuery.of(context).padding,
                            padding: EdgeInsets.only(top: 300),
                            child: ListTile(
                              leading: Icon(
                                Icons.supervised_user_circle,
                                color: Color.fromRGBO(244, 217, 66, 1),
                                size: 30,
                              ),
                              title: Text(
                                'Settings',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Settings()));
                                // SharedPreferences preferences =
                                //     await SharedPreferences.getInstance();
                                // setState(() {
                                //   preferences.setInt('value', null);
                                //   preferences.commit();
                                //   _loginStatus = LoginStatus.notSignIn;
                                // });
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext ctx) =>
                                //             Login()));
                              },
                            ),
                          ),
                          Padding(
                            // padding: MediaQuery.of(context).padding,
                            padding: EdgeInsets.only(top: 10),
                            child: ListTile(
                              leading: Icon(
                                Icons.supervised_user_circle,
                                color: Color.fromRGBO(244, 217, 66, 1),
                                size: 30,
                              ),
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
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
                                            Login()));
                              },
                            ),
                          ),
                        ],
                      )
                    : loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final x = list[i];
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        color: Color.fromRGBO(244, 217, 66, 1),
                                        size: 30,
                                      ),
                                      title: Text(
                                        'Edit Profile',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Edit(x)));
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.av_timer,
                                        color: Color.fromRGBO(244, 217, 66, 1),
                                        size: 30,
                                      ),
                                      title: Text(
                                        'History',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      onTap: () async {
                                        var navigationResult =
                                            await Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => History(),
                                          ),
                                        );
                                        if (navigationResult == true) {
                                          MaterialPageRoute(
                                            builder: (context) => History(),
                                          );
                                        }
                                      },
                                    ),
                                    Padding(
                                      // padding: MediaQuery.of(context).padding,
                                      padding: EdgeInsets.only(top: 300),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.settings,
                                          color:
                                              Color.fromRGBO(244, 217, 66, 1),
                                          size: 30,
                                        ),
                                        title: Text(
                                          'Settings',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        onTap: () async {
                                          // SharedPreferences preferences =
                                          //     await SharedPreferences
                                          //         .getInstance();
                                          // setState(() {
                                          //   preferences.setInt('value', null);
                                          //   preferences.commit();
                                          //   _loginStatus =
                                          //       LoginStatus.notSignIn;
                                          // });
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (BuildContext ctx) =>
                                          //             Login()));
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Settings()));
                                        },
                                      ),
                                    ),
                                    Padding(
                                      // padding: MediaQuery.of(context).padding,
                                      padding: EdgeInsets.only(top: 10),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.supervised_user_circle,
                                          color:
                                              Color.fromRGBO(244, 217, 66, 1),
                                          size: 30,
                                        ),
                                        title: Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        onTap: () async {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          setState(() {
                                            preferences.setInt('value', null);
                                            preferences.commit();
                                            _loginStatus =
                                                LoginStatus.notSignIn;
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext ctx) =>
                                                      Login()));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
      ),
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
                  leading: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: Text(
                    'My Profile',
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
                                  ImageUrl.imageProfile + user_img),
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
                            '$user_username',
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
                                      : Row(
                                          children: <Widget>[
                                            for (var i = 0;
                                                i < list.length;
                                                i++)
                                              Text(
                                                list[0].location_country,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                  wordSpacing: 2,
                                                ),
                                              ),
                                            Text(
                                              ', ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                wordSpacing: 2,
                                              ),
                                            ),
                                            Text(
                                              list[0].location_city,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                wordSpacing: 2,
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
                      Text(
                        user_bio ?? 'Belum ada bio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      RaisedButton(
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
                          'Make Deals',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                        onPressed: () async {
                          var navigationResult = await Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => MakeDeal(),
                            ),
                          );
                          if (navigationResult == true) {
                            MaterialPageRoute(
                              builder: (context) => MakeDeal(),
                            );
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
                ? Center(child: Text("ANDA BELUM POST APAPUN"))
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
                      // Color.fromRGBO(244, 217, 66, 1),
                    ),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                  //  Color.fromRGBO(244, 217, 61, 1),
                ),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(
                //       Icons.more_vert,
                //       size: 25,
                //     ),
                //     onPressed: () {
                //       // showDialog(
                //       //     context: context,
                //       //     builder: (BuildContext context) => _popUp(context));
                //       // _popUpReport();
                //     },
                //   ),
                // ],
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
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.lock_outline),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child:
                        Text("Privacy", style: new TextStyle(fontSize: 18.0)),
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
                    child: Text("Help", style: new TextStyle(fontSize: 18.0)),
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
                    child: Text("About", style: new TextStyle(fontSize: 18.0)),
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
                      // Color.fromRGBO(244, 217, 66, 1),
                    ),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                  //  Color.fromRGBO(244, 217, 61, 1),
                ),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(
                //       Icons.more_vert,
                //       size: 25,
                //     ),
                //     onPressed: () {
                //       // showDialog(
                //       //     context: context,
                //       //     builder: (BuildContext context) => _popUp(context));
                //       // _popUpReport();
                //     },
                //   ),
                // ],
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
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.block),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Blocked Accounts",
                        style: new TextStyle(fontSize: 18.0)),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top:5.0, left: 20.0, right: 20.0, bottom: 20.0),
          //   child: Row(children: <Widget>[
          //     Icon(Icons.help_outline),
          //     Padding(
          //       padding: const EdgeInsets.only(left:8.0),
          //       child: Text("Help", style: new TextStyle(fontSize: 20.0)),
          //     ),
          //   ],),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top:5.0, left: 20.0, right: 20.0, bottom: 20.0),
          //   child: Row(children: <Widget>[
          //     Icon(Icons.info_outline),
          //     Padding(
          //       padding: const EdgeInsets.only(left:8.0),
          //       child: Text("About", style: new TextStyle(fontSize: 20.0)),
          //     ),
          //   ],),
          // )
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

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      // location_user_id = preferences.getString('user_id');
      // user_username = preferences.getString("user_username");
      // user_bio = preferences.getString("user_bio");
      // user_img = preferences.getString("user_img");
    });
  }

  String block_user_two_id;
  var loading = false;
  final list = new List<BlockedUsers>();
  Future<void> _lihatDataBlockedUser() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post("https://dipena.com/flutter/api/user/blockedUser.php", body: {
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
        final abc = new BlockedUsers(
          api['user_id'],
          api['user_username'],
          api['user_bio'],
          api['user_img'],
        );
        list.add(abc);
      });
      setState(() {
        // for (var i = 0; i < list.length; i++) {
        //   block_user_two_id = list[i].user_id;
        // }
        loading = false;
      });
    }
  }

  block() async {
    await getPref();
    await block_user_two_id;
    final response = await http
        .post("https://dipena.com/flutter/api/block/block.php", body: {
      "block_user_one": user_id,
      "block_user_two": block_user_two_id,

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
      _refresh.currentState.show();
      // Navigator.pop(context);
      // print(pesan);
      // setState(() {
      //   // x.follow_status_user !=
      //   // null;
      // });
      _showToast(messageEnglish);
    } else if (value == 2) {
      // Navigator.pop(context);
      // print(pesan);
      // _showToastUnfoll(
      // pesan);
      _showToast(messageEnglish);
    } else {
      // Navigator.pop(context);
      // _showToast(pesan);
      _showToast(messageEnglish);
    }
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.green,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _lihatDataBlockedUser();
  }

  @override
  Widget build(BuildContext context) {
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
                        // Color.fromRGBO(244, 217, 66, 1),
                      ),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                    //  Color.fromRGBO(244, 217, 61, 1),
                  ),
                  // actions: <Widget>[
                  //   IconButton(
                  //     icon: Icon(
                  //       Icons.more_vert,
                  //       size: 25,
                  //     ),
                  //     onPressed: () {
                  //       // showDialog(
                  //       //     context: context,
                  //       //     builder: (BuildContext context) => _popUp(context));
                  //       // _popUpReport();
                  //     },
                  //   ),
                  // ],
                ),
              ),
            ),
            list.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Center(child: Text("No User Blocked")),
                  )
                : loading
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        key: _refresh,
                        onRefresh: _lihatDataBlockedUser,
                        child: ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final x = list[i];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            ImageUrl.imageProfile + x.user_img),
                                        minRadius: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(x.user_username,
                                                  textAlign: TextAlign.left,
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                x.user_bio,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: FlatButton(
                                      textColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        print(x.user_id);
                                        setState(() {
                                          block_user_two_id = x.user_id;
                                        });
                                        block();
                                        _refresh.currentState.show();
                                      },
                                      child: Text("Unblock"),
                                    ),
                                  )
                                ],
                              ),
                            );
                            // ]);
                          },
                        ),
                      )
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
                      // Color.fromRGBO(244, 217, 66, 1),
                    ),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                  //  Color.fromRGBO(244, 217, 61, 1),
                ),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(
                //       Icons.more_vert,
                //       size: 25,
                //     ),
                //     onPressed: () {
                //       // showDialog(
                //       //     context: context,
                //       //     builder: (BuildContext context) => _popUp(context));
                //       // _popUpReport();
                //     },
                //   ),
                // ],
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
                        style: new TextStyle(fontSize: 18.0)),
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
                        style: new TextStyle(fontSize: 18.0)),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top:5.0, left: 20.0, right: 20.0, bottom: 20.0),
          //   child: Row(children: <Widget>[
          //     Icon(Icons.help_outline),
          //     Padding(
          //       padding: const EdgeInsets.only(left:8.0),
          //       child: Text("Help", style: new TextStyle(fontSize: 20.0)),
          //     ),
          //   ],),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top:5.0, left: 20.0, right: 20.0, bottom: 20.0),
          //   child: Row(children: <Widget>[
          //     Icon(Icons.info_outline),
          //     Padding(
          //       padding: const EdgeInsets.only(left:8.0),
          //       child: Text("About", style: new TextStyle(fontSize: 20.0)),
          //     ),
          //   ],),
          // )
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
                    // Color.fromRGBO(244, 217, 66, 1),
                  ),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
                //  Color.fromRGBO(244, 217, 61, 1),
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(
              //       Icons.more_vert,
              //       size: 25,
              //     ),
              //     onPressed: () {
              //       // showDialog(
              //       //     context: context,
              //       //     builder: (BuildContext context) => _popUp(context));
              //       // _popUpReport();
              //     },
              //   ),
              // ],
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
                color: Color.fromRGBO(244, 217, 66, 4),
                height: MediaQuery.of(context).size.height / 5,
                child: Center(
                    child:
                        Image.asset("assets/images/dipena_logo_square2.png"))),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Center(
                  child: Text("Data Policy",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0))),
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
                    style: new TextStyle(fontSize: 15.0, color: Colors.black)),
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
                        style: TextStyle(color: Colors.black, fontSize: 13.0),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'halo@dipena.com',
                              style: TextStyle(color: Colors.blue)),
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
                    // Color.fromRGBO(244, 217, 66, 1),
                  ),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
                //  Color.fromRGBO(244, 217, 61, 1),
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(
              //       Icons.more_vert,
              //       size: 25,
              //     ),
              //     onPressed: () {
              //       // showDialog(
              //       //     context: context,
              //       //     builder: (BuildContext context) => _popUp(context));
              //       // _popUpReport();
              //     },
              //   ),
              // ],
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
                child: Center(
                    child:
                        Image.asset("assets/images/dipena_logo_square2.png"))),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
              child: Text("Terms of Use",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                "Dear the one who will change the world",
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text("Welcome to dipena!"),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We, as a social network in the scope of creative industry, are doing our best on connecting people with opportunities. And this terms of use will guide you on how we govern the community of dipena to create a sustainable ecosystem. When you signed up for dipena and join the community, you agree with all the terms of use below.",
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 45.0, right: 45.0),
              child: Text("HOW CAN YOU USE DIPENA?",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We are providing a platform for creative people can share their art in a way people can see it as an opportunities, not only an art. We are doing our best to connecting creative people to the society on business purposes, because we believe that every single thing need to be shaped beautifully. And dipena is all about connecting an opportunities in the scope of creative industry.",
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	For painter, designer, and photographer.",
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "Share your vision and prove it with your art. We genuinely believe that you are not only deserve likes and comments on every post that have posted in your othe social media, but you should get more project and meet with new potential people that could change your life. And so, being as a social network that push you to express yourself on business purposes is what we’re interested in. You’ll be guided on creating a post that will be implified as an opportunities by the society, because you will fill up your service deals every time you want to post your art. ",
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	For everyone", textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We bring you closer to the poeple that might work with you to change the world. And we encourage you to “take deals” on every post that you might interest on and communicate with them on our platform. Help us to create this sustainable ecosystem and together change this messy world to be a better place to live. ",
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 45.0, right: 45.0),
              child: Text("HOW CAN'T YOU USE DIPENA?",
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child:
                  Text("•	We are not e-commerce", textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "As a social network, it means that we’re connecting the society. Please be conscious that this is not an e-commerce where you can sell goods to your audience and it’s a pleasure for us if you can use it the way it should be. ",
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
              child: Text("•	Content prohibited", textAlign: TextAlign.justify),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
              child: Text(
                  "We don’t give a tolerance for any content that consist any of :",
                  textAlign: TextAlign.justify),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("1.	Pornographic content",
                        textAlign: TextAlign.justify),
                    Text("2.	Highly explicit nudity",
                        textAlign: TextAlign.justify),
                    Text("3.	Hate speech post or comment",
                        textAlign: TextAlign.justify),
                    Text("4.	Harrassment and threats",
                        textAlign: TextAlign.justify),
                    Text("5.	Illegal activities or goods",
                        textAlign: TextAlign.justify),
                    Text("6.	Graphic violence", textAlign: TextAlign.justify),
                    Text("7.	Spam", textAlign: TextAlign.justify),
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
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'report ',
                            style: TextStyle(color: Colors.blue)),
                        TextSpan(
                            text:
                                'from our users that indicate content prohibited.',
                            style: TextStyle(color: Colors.black)),
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
                    // Color.fromRGBO(244, 217, 66, 1),
                  ),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
                //  Color.fromRGBO(244, 217, 61, 1),
              ),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(
              //       Icons.more_vert,
              //       size: 25,
              //     ),
              //     onPressed: () {
              //       // showDialog(
              //       //     context: context,
              //       //     builder: (BuildContext context) => _popUp(context));
              //       // _popUpReport();
              //     },
              //   ),
              // ],
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
                      style: new TextStyle(fontSize: 18.0)),
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
                      style: new TextStyle(fontSize: 18.0)),
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
                      // Color.fromRGBO(244, 217, 66, 1),
                    ),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                  //  Color.fromRGBO(244, 217, 61, 1),
                ),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(
                //       Icons.more_vert,
                //       size: 25,
                //     ),
                //     onPressed: () {
                //       // showDialog(
                //       //     context: context,
                //       //     builder: (BuildContext context) => _popUp(context));
                //       // _popUpReport();
                //     },
                //   ),
                // ],
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  color: Color.fromRGBO(244, 217, 66, 4),
                  height: MediaQuery.of(context).size.height / 5,
                  child: Center(
                      child: Image.asset(
                          "assets/images/dipena_logo_square2.png"))),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
                child: Text("Block an Account",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                child:
                    Text("How to block user :", textAlign: TextAlign.justify),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to User Profile.",
                          textAlign: TextAlign.justify),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the", textAlign: TextAlign.justify),
                          Icon(Icons.more_vert),
                          Text(" In the top right corner"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify),
                      ),
                      Text('3.	Then choose "Block" to block user.',
                          textAlign: TextAlign.justify),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 25.0, left: 45.0, right: 45.0),
                child: Text("How to unblock users :",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to Profile Tab in the bottom right corner",
                          textAlign: TextAlign.justify),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify),
                      ),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the", textAlign: TextAlign.justify),
                          Icon(Icons.dehaze),
                          Text(" In the top right corner"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify),
                      ),
                      Text('3.	Then choose "Settings".',
                          textAlign: TextAlign.justify),
                      Text('4.	Then choose "Privacy".',
                          textAlign: TextAlign.justify),
                      Text('5.	After that choose "Blocked Accounts".',
                          textAlign: TextAlign.justify),
                      Text(
                          '6.	Then choose which account that you want to get unblocked by click "Unblock".',
                          textAlign: TextAlign.justify),
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
                      // Color.fromRGBO(244, 217, 66, 1),
                    ),
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                  //  Color.fromRGBO(244, 217, 61, 1),
                ),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(
                //       Icons.more_vert,
                //       size: 25,
                //     ),
                //     onPressed: () {
                //       // showDialog(
                //       //     context: context,
                //       //     builder: (BuildContext context) => _popUp(context));
                //       // _popUpReport();
                //     },
                //   ),
                // ],
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  color: Color.fromRGBO(244, 217, 66, 4),
                  height: MediaQuery.of(context).size.height / 5,
                  child: Center(
                      child: Image.asset(
                          "assets/images/dipena_logo_square2.png"))),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
                child: Text("Reporting Account or Post",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 45.0, right: 45.0),
                child:
                    Text("How to report posts :", textAlign: TextAlign.justify),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to the post that you want to report.",
                          textAlign: TextAlign.justify),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the", textAlign: TextAlign.justify),
                          Icon(Icons.more_vert),
                          Text(" In the bottom right corner"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("below the post image.",
                            textAlign: TextAlign.justify),
                      ),
                      Text('3.	Then choose "Report" to report post.',
                          textAlign: TextAlign.justify),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 25.0, left: 45.0, right: 45.0),
                child: Text("How to Report an Account :",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 55.0, right: 45.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1.	Go to the Account/User Profile.",
                          textAlign: TextAlign.justify),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15.0),
                      //   child: Text("of the screen.",
                      //       textAlign: TextAlign.justify),
                      // ),
                      Row(
                        children: <Widget>[
                          Text("2.	Click the", textAlign: TextAlign.justify),
                          Icon(Icons.more_vert),
                          Text(" In the top right corner"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("of the screen.",
                            textAlign: TextAlign.justify),
                      ),
                      Text('3.	Then choose "Report" to report Account/',
                          textAlign: TextAlign.justify),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text("User.", textAlign: TextAlign.justify),
                      ),
                      Text(
                          '4.	Then choose the reason why you reported the account.',
                          textAlign: TextAlign.justify),
                      // Text('5.	After that choose "Blocked Accounts".',
                      //     textAlign: TextAlign.justify),
                      // Text('6.	Then choose which account that you want to get unblocked by click "Unblock".',
                      //     textAlign: TextAlign.justify),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
