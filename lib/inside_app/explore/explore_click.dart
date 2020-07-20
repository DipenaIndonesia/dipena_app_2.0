import 'dart:convert';

import 'package:dipena/inside_app/explore/explore_model.dart';
import 'package:dipena/model/profilePost.dart';
import 'package:dipena/model/selectAnotherUserProfileModel.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExploreClick extends StatefulWidget {
  final String post_explore_detail_id;
  ExploreClick(this.post_explore_detail_id);
  @override
  _ExploreClickState createState() => _ExploreClickState();
}

class _ExploreClickState extends State<ExploreClick> {


  var loadingg = false;
  final list = new List<PostProfile>();
  Future<void> _lihatDataPostProfile() async {
    // await getPref();
    list.clear();
    setState(() {
      loadingg = true;
    });
    final response = await http.post("https://dipena.com/flutter/api/post/ExploreDetailPost.php", body: {
      'user_id': widget.post_explore_detail_id,
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
        loadingg = false;
      });
    }
  }

  var loading = false;
  // String user_username;
  final listt = new List<SelectAnotherUserProfile>();
  Future<void> _selectProfile() async {
    // await getPref();
    listt.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(
        "https://dipena.com/flutter/api/post/selectUserProfile2_0.php",
        body: {
          'user_id': widget.post_explore_detail_id,
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
          // user_username = listt[i].user_username;
          // user_fullname = listt[i].user_fullname;
          // user_img = listt[i].user_img;
          // user_bio = listt[i].user_bio;
          // user_email = listt[i].user_email;
          // report_user_image = another_list[i].user_img;
          // block_user_two = another_list[i].user_id;
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatDataPostProfile();
    _selectProfile();
  }
  
  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
                            child: ClipOval(
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage(
                                  "assets/img/icon_one.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Poppins Regular",
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 180,
            child: Expanded(
              child: 
              // ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount: list.length,
              //   itemBuilder: (context, i) 
              //     // final x = list[i];
              //     // return
              //     => 
                  Stack(
                  children: [
                    for(var i = 0; i < list.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 5,
                            child: InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 8,
                                foregroundDecoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      // exploreData[i].image,
                                      ImageUrl.imageContent + list[i].post_img
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // }
              // )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(var i = 0; i < listt.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: listt[i].user_img == null ? placeholder :
                          CircleAvatar(
                            child: ClipOval(
                              child: Image(
                                width: 50,
                                height: 50,
                                image: NetworkImage(
                                  ImageUrl.imageProfile + listt[i].user_img,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              // "Sasha Witt",
                              listt[i].user_fullname ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Semibold",
                              ),
                            ),
                            Text(
                              // "@sasha",
                              listt[i].user_username ?? "",
                              style: TextStyle(
                                color: Color(0xFF7F8C8D),
                                fontSize: 13,
                                fontFamily: "Poppins Regular",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                      height: 25,
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: Color(0xFFF39C12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Follow",
                          style: TextStyle(
                            color: Color(0xFFF39C12),
                            fontSize: 13,
                            fontFamily: "Poppins Regular",
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore er dolore.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: "Poppins Regular",
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: 650,
                  height: 50,
                  child: RaisedButton(
                    color: Color(0xFFF39C12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Collabs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Poppins Medium",
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
