import 'dart:convert';

import 'package:dipena/inside_app/explore/explore_click.dart';
import 'package:dipena/inside_app/home/details.dart';
import 'package:dipena/model/explore/exploreModel.dart';
import 'package:dipena/model/navigateCat.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatefulWidget {
  final Category model;
  CategoryPage(this.model);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int selectedIndex = 0;

  // final List<String> categories = [
  //   "Art",
  //   "Design",
  //   "Photography",
  //   "Other",
  // ];

  List<Category> categories = [
    Category(
      '1',
      'Painter',
    ),
    Category(
      '2',
      'Designer',
    ),
    Category(
      '3',
      'Photographer',
    ),
    Category(
      '4',
      'Others',
    ),
  ];


  final String url = "http://dipena.com/flutter/api/post/explorePost.php";

  List data = List();

  Future<String> getUserExplore() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  String user_id;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      // user_username = preferences.getString("user_username");
      // follow_user_one = preferences.getString("user_id");
    });
  }


  var loading = false;
  final list = new List<PostContent>();
  Future<void> _lihatDataPostCat() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post("https://dipena.com/flutter/api/post/explorePostCat.php", body: {
      "user_id": user_id,
      "post_cat_id": widget.model.id,
    });
    if (response.contentLength == 2) {

    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new PostContent(
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
          api['follow_status'],
          api['like_status'],
          api['jumlahKomen'],
          api['jumlahLike'],
          api['like_status_user'],
          api['follow_status_user'],
          api['block_status'],
        );
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
    // getUserExplore();
    // _userExplore();
    getPref();
    _lihatDataPostCat();
    // _userExploreImage();
    // print(postImageId);
  }

  String post_explore_detail_id;

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
  Widget build(BuildContext context) {
    var color = 0xffffffff;
    var placeholder = CircleAvatar(
      child: ClipOval(
        child: Image(
          width: 50,
          height: 50,
          image: AssetImage(
              // data.icon,
              'assets/img/icon_two.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              title: new Text(
                widget.model.name,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child: Wrap(
                        children: <Widget>[
                          for (var i = 0; i < list.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    post_explore_detail_id = list[i].post_id;
                                  });
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => Details(post_explore_detail_id),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  // height: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    color: Color(color),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Card(
                                      elevation: 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                child: list[i].user_img == null
                                                    ? placeholder
                                                    : CircleAvatar(
                                                        child: ClipOval(
                                                          child: Image(
                                                            width: 50,
                                                            height: 50,
                                                            image: NetworkImage(
                                                                ImageUrl.imageProfile +
                                                                    list[i]
                                                                        .user_img),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RichText(
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                          text: '@',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.0),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: list[i]
                                                                    .user_username,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ),
                                                    // Text(
                                                    //   // "nama",
                                                    //   list[i].user_username,
                                                    //   style: TextStyle(
                                                    //     color: Colors.black,
                                                    //     fontSize: 13,
                                                    //     fontFamily:
                                                    //         "Poppins Semibold",
                                                    //   ),
                                                    //   maxLines: 1,
                                                    //   softWrap: false,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    // ),
                                                    Text(
                                                      // "username",
                                                      // list[i].user_username,
                                                      show_cat(
                                                          list[i].post_cat_id),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF7F8C8D),
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "Poppins Regular",
                                                      ),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Image(
                                              image: NetworkImage(
                                                  // post,
                                                  ImageUrl.imageContent +
                                                      list[i].post_img),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}

class Items {
  String icon;
  String name;
  String username;
  String post1;
  String post2;

  Items({
    this.icon,
    this.name,
    this.username,
    this.post1,
    this.post2,
  });
}
