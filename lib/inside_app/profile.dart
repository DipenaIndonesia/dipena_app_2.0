import 'dart:convert';

import 'package:dipena/auth/login.dart';
import 'package:dipena/inside_app/deal.dart';
import 'package:dipena/inside_app/seeDealsFromProfile.dart';
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
  // }

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
                            padding: EdgeInsets.only(top: 350),
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
                                      padding: EdgeInsets.only(top: 350),
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
