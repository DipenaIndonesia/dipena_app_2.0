import 'dart:async';
import 'dart:convert';

import 'package:dipena/model/commentData.dart';
import 'package:dipena/model/selectPostFollow.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Comment extends StatefulWidget {
  final PostFollow model;
  Comment(this.model);
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final _key = new GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController txtCommentContent = TextEditingController();

  String user_id, comment_user_id, comment_content, post_id;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  var loading = false;
  final list = new List<CommentData>();
  Future<void> _lihatComment() async {
    // await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(CommentUrl.selectComment, body: {
      "post_id": widget.model.post_id,
    });

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new CommentData(
            api['comment_id'],
            api['comment_post_id'],
            api['comment_content'],
            api['comment_time'],
            api['user_username'],
            api['user_img']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      comment_user_id = preferences.getString("user_id");
    });
  }

  submit() async {
    await getPref();
    final response = await http.post(CommentUrl.addComment, body: {
      "user_id": user_id,
      "comment_user_id": user_id,
      "comment_content": comment_content,
      "post_id": widget.model.post_id,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String changeProf = data['changeProf'];

    if (value != 0) {
      String user_usernameAPI = data['user_username'];
      String user_bioAPI = data['user_bio'];
      print(message);
      // loginToast(message);
      // alertToast(changeProf);
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        txtCommentContent.clear();
        //   //  getPrefs();
      });
      // return true;
    } else {
      print(message);
      // loginToast(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatComment();
    _postsController = new StreamController();
    loadPosts();
  }

  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;

  Future fetchPost() async {
    await getPref();
    final response = await http.post(CommentUrl.selectComment, body: {
      "post_id": widget.model.post_id,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadPosts() async {
    fetchPost().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  Future<Null> _handleRefresh() async {
    count++;
    print(count);
    fetchPost().then((res) async {
      _postsController.add(res);
      // showSnack();
      return null;
    });
  }

  // bool isButtonDisable = false;
  bool _btnEnabled = false;

  Widget _commentfield() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Form(
        key: _key,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(-2, 0),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: txtCommentContent,
                  onSaved: (e) => comment_content = e,
                  decoration: InputDecoration(
                    hintText: 'Enter Message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () {
                  check();
                  _refresh.currentState.show();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      child: CircleAvatar(
        backgroundImage: AssetImage("assets/img/user_search.png"),
        minRadius: 25,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins Medium",
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          // primary: true,
          children: <Widget>[
            RefreshIndicator(
              onRefresh: _handleRefresh,
              key: _refresh,
              child: Container(),
            ),
            list.isEmpty
                ? Expanded(child: Center(child: Text("No comment found yet")))
                : Expanded(
                    child: StreamBuilder(
                      stream: _postsController.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        // print('Has error: ${snapshot.hasError}');
                        // print('Has data: ${snapshot.hasData}');
                        // print('Snapshot Data ${snapshot.data}');

                        if (snapshot.hasError) {
                          return Text(snapshot.error);
                        }

                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: Scrollbar(
                                  child: RefreshIndicator(
                                    onRefresh: _handleRefresh,
                                    child: ListView.builder(
                                      // reverse: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        var post = snapshot.data[index];
                                        return Material(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 15,
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child:
                                                          post["user_img"] ==
                                                                  null
                                                              ? placeholder
                                                              : Container(
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundImage:
                                                                        NetworkImage(ImageUrl.imageProfile +
                                                                            post["user_img"]),
                                                                    minRadius:
                                                                        25,
                                                                  ),
                                                                ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 15,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        // username,
                                                        // "",
                                                        post['user_username'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Poppins Semibold",
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 5,
                                                        ),
                                                      ),
                                                      Text(
                                                        // "",
                                                        post["comment_content"],
                                                        // comment,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Poppins Regular",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 15,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          return Text('No Posts');
                        }
                      },
                    ),
                    //             child: ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: list.length,
                    //   itemBuilder: (context, i) {
                    //     final x = list[i];
                    //     return Material(
                    //       child: Container(
                    //         padding: EdgeInsets.only(
                    //           top: 15,
                    //           bottom: 5,
                    //         ),
                    //         child: Row(
                    //           children: <Widget>[
                    //             Stack(
                    //               children: <Widget>[
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                     left: 5,
                    //                   ),
                    //                   child: x.user_img == null ? placeholder :
                    //                   Container(
                    //                     child: CircleAvatar(
                    //                       backgroundImage: NetworkImage(
                    //                         ImageUrl.imageProfile + x.user_img
                    //                         ),
                    //                       minRadius: 25,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             Padding(
                    //               padding: EdgeInsets.only(
                    //                 left: 15,
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     // username,
                    //                     // "",
                    //                     x.user_username,
                    //                     style: TextStyle(
                    //                       color: Colors.black,
                    //                       fontSize: 15,
                    //                       fontFamily: "Poppins Semibold",
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.only(
                    //                       top: 5,
                    //                     ),
                    //                   ),
                    //                   Text(
                    //                     // "",
                    //                     x.comment_content,
                    //                     // comment,
                    //                     style: TextStyle(
                    //                       color: Colors.black54,
                    //                       fontSize: 14,
                    //                       fontFamily: "Poppins Regular",
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             Column(
                    //               children: <Widget>[
                    //                 Padding(
                    //                   padding: EdgeInsets.only(
                    //                     right: 15,
                    //                   ),
                    //                 ),
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   // children: <Widget>[
                    //   // new CommentData(
                    //   //   icon: 'assets/img/icon_five.jpg',
                    //   //   username: '@flowerstem',
                    //   //   comment: 'This is epic!',
                    //   // ),
                    //   // new CommentData(
                    //   //   icon: 'assets/img/icon_four.jpg',
                    //   //   username: '@dimples',
                    //   //   comment: 'Can we collab?',
                    //   // ),
                    //   // new CommentData(
                    //   //   icon: 'assets/img/icon_one.jpg',
                    //   //   username: '@makeitright',
                    //   //   comment: 'I cannnot believe someone can be this creative',
                    //   // ),
                    //   // ],
                    // ),
                  ),
            Container(child: _commentfield())
          ],
        ),
      ),
    );
  }
}

class CommentDataModel extends StatelessWidget {
  CommentDataModel({
    this.icon,
    this.username,
    this.comment,
  });

  final String icon;
  final String username;
  final String comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Material(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 5,
                  ),
                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                            ),
                            child: Container(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  icon,
                                ),
                                minRadius: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              username,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Semibold",
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                              ),
                            ),
                            Text(
                              comment,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontFamily: "Poppins Regular",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              right: 15,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
