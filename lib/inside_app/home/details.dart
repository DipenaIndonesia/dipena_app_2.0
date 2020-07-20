import 'dart:convert';

import 'package:dipena/inside_app/chat/chat_page.dart';
import 'package:dipena/inside_app/chat/chat_user_profile.dart';
import 'package:dipena/model/seeDeals.dart';
import 'package:dipena/model/selectPostFollow.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  // final PostFollow model;
  // Details(this.model);
  final String post_detail_id;
  Details(this.post_detail_id);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String user_id, post_user_id;
  var loading = false;
  final list = new List<SeeDeals>();
  Future<void> _seeDeals() async {
    // await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post(DealUrl.seeDeals, body: {"post_id": widget.post_detail_id});
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
        final ab = new SeeDeals(
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
            api['user_img']);
        list.add(ab);
      });
      setState(() {
        for(var i = 0; i < list.length; i++){
          post_user_id = list[i].post_user_id;
        }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _seeDeals();
  }

  // String chat_user_id;

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

  submit() async {

    await getPref();
    final response = await http.post(DealUrl.takeDeals, body: {
      "user_id": user_id,
      "user_id_two": post_user_id,
      // "post_cat_id" : post_cat_id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
      });
    } else {
      print(pesan);
    }
  }

  String chat_user_id;

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image(
          image: AssetImage(
            "assets/img/icon_one.jpg",
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        // child:
        itemCount: list.length,
        itemBuilder: (context, i) {
          final x = list[i];
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 1.8,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: NetworkImage(
                  //         // "assets/img/post_one.jpg",
                  //         ImageUrl.imageContent + x.post_img),
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: NetworkImage(
                            // post,
                            ImageUrl.imageContent + x.post_img),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      new Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FloatingActionButton(
                              backgroundColor:
                                  Color.fromRGBO(255, 255, 255, 0.5),
                              child: new Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      )
                    ],
                  ),
                  //   Container(
                  //     margin: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  //     child: Stack(
                  //       alignment: Alignment.topLeft,
                  //       children: <Widget>[
                  //         Container(
                  //           width: 35,
                  //           height: 35,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: Colors.white,
                  //             boxShadow: [
                  //               new BoxShadow(
                  //                 color: Colors.grey,
                  //                 blurRadius: 4,
                  //               ),
                  //             ],
                  //           ),
                  //           child: IconButton(
                  //             icon: Icon(
                  //               Icons.arrow_back,
                  //               color: Colors.black,
                  //               size: 20,
                  //             ),
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //             },
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
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
                                  // child: ClipOval(
                                  // child: Image(
                                  backgroundImage: NetworkImage(
                                      // "assets/img/icon_one.jpg",
                                      ImageUrl.imageProfile + x.user_img),
                                  // fit: BoxFit.fill,
                                  minRadius: 40,
                                  // ),
                                  // ),
                                ),
                        ),
                        title: Text(
                          // "Tia Nurmala",
                          x.user_fullname,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins Semibold",
                          ),
                        ),
                        subtitle: Text(
                          // "@tianurmala_",
                          x.user_username,
                          style: TextStyle(
                            color: Color(0xFF7F8C8D),
                            fontSize: 15,
                            fontFamily: "Poppins Regular",
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        show_cat(x.post_cat_id),
                        // "Designer",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Poppins Semibold",
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        // "Description",
                        x.post_description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Poppins Regular",
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Services",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Poppins Semibold",
                        ),
                      ),
                      // SizedBox(height: 15),
                      Text(
                        // "Description",
                        x.post_offer,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Poppins Regular",
                        ),
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: new Color(0xFFF39C12),
                            splashColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            onPressed: () async {
                              submit();
                              setState(() {
                                chat_user_id = post_user_id;
                              });
                              var navigationResult = await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => ChatUserProfile(chat_user_id),
                                ),
                              );
                              // if (navigationResult == true) {
                              //   MaterialPageRoute(
                              //     builder: (context) => Chat(),
                              //   );
                              // }
                            },
                            child: Text(
                              "Collabs",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: "Poppins Medium",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DetailsData extends StatelessWidget {
  DetailsData({this.profile, this.name, this.username});
  final String profile;
  final String name;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[],
    );
  }
}
