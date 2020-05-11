import 'dart:async';
import 'dart:convert';

import 'package:dipena/model/commentData.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Comment extends StatefulWidget {
  // final VoidCallback reload;
  final PostContent model;
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

  // var comments = CommentData(comment_id, comment_post_id, comment_content, comment_time, user_username, user_img);
  // var count = comments.where((c)=>c.comment_id == )

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatComment();
    _postsController = new StreamController();
    loadPosts();
  }

  Widget _commentfield() {
    return Form(
      key: _key,
      child: Container(
        padding: EdgeInsets.all(10),
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
              child:
               TextFormField(
                keyboardType: TextInputType.text,
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
    );
  }

  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;

  Future fetchPost() async {
    await getPref();
    final response = await http
        .post(CommentUrl.selectComment, body: {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  PreferredSize(
        //       preferredSize: Size.fromHeight(62),
        //       child:
        
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () {
             Navigator.of(context).pop();
            },
          ),
          // automaticallyImplyLeading: false,
          // Navigator.pop(context) == true,
          backgroundColor: Color.fromRGBO(244, 217, 66, 1),
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Comment',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body:
          // Visibility(
          //    visible: visible,
          //     child:
         Container(
        // color: Colors.white,
        // backgroundColor: Colors.white,
        // Function(ScrollNotification:)
        // notificationPredicate: Notification,
        // onRefresh: _handleRefresh,
        // key: _refresh,
        child: Column(
          children: <Widget>[
            // Flexible(
            //   child: ListView.builder(
            //     itemBuilder: (BuildContext context, int index) => _makeElement(index),
            //     )
            // ),
            // Container(
            // color: Colors.white,
            // Flexible(
            //   // children: <Widget>[
            //   child:
            //       //  loading
            //       //     ? Center(child: CircularProgressIndicator())
            //       //     :
            //       list.isEmpty
            //           ? Center(
            //               child: Text("CHAT KOSONG"),
            //             )
            //           :
            //           // : listTwo.isEmpty ?

            //           // Center(child: Text("CHAT KOSONG"),) :
            //           ListView.builder(
            //               reverse: true,
            //               //  primary: true,
            //               //     shrinkWrap: true,
            //               //     physics: const NeverScrollableScrollPhysics(),
            //               itemCount: list.length,
            //               itemBuilder: (context, i) {
            //                 final x = list[i];
            //                 // final b = listTwo[i];
            //                 return Container(
            //                   // onRefresh: _chatContent,
            //                   // key: _refreshChat,
            //                   child: loading
            //                       ? Center(child: CircularProgressIndicator())
            //                       : Padding(
            //                           padding:
            //                               EdgeInsets.only(left: 10, right: 10),
            //                           child: Column(
            //                             //           shrinkWrap: true,
            //                             // physics: const NeverScrollableScrollPhysics(),
            //                             children: <Widget>[
            //                               // for (var i = 0; i < list.length; i++)

            //                               // Text(
            //                               //   'Today',
            //                               //   style: TextStyle(
            //                               //     color: Colors.grey,
            //                               //     fontSize: 12,
            //                               //   ),
            //                               // ),
            //                               // list[i].chat_user_one == user_id
            //                               //     ? Bubble(
            //                               //         message:
            //                               //             list[i].chat_content,
            //                               //         isMe: true,
            //                               //       )
            //                               //     : Bubble(
            //                               //         message:
            //                               //             list[i].chat_content,
            //                               //         isMe: false,
            //                               //       )
            //                               x.chat_user_one == user_id
            //                                   ? Bubble(
            //                                       message: x.chat_content,
            //                                       isMe: true,
            //                                     )
            //                                   : Bubble(
            //                                       message: x.chat_content,
            //                                       isMe: false,
            //                                     ),
            //                               // for(var u = 0; u < listTwo.length; u++)
            //                               // Bubble(
            //                               //   message: 'Apakah lukisan ini di jual?',
            //                               //   isMe: true,
            //                               // ),
            //                               // Text(
            //                               //   'Dec 15, 2019',
            //                               //   style: TextStyle(
            //                               //     color: Colors.grey,
            //                               //     fontSize: 12,
            //                               //   ),
            //                               // ),
            //                               // Bubble(
            //                               //   message: listTwo[u].chat_content,
            //                               //   isMe: false,
            //                               // ),
            //                               // Bubble(
            //                               //   message: 'Iya, kami menjualnya',
            //                               //   isMe: false,
            //                               // ),
            //                             ],
            //                           ),
            //                         ),
            //                   // )
            //                 );
            //               }),
            // ),
            // Flexible(
            //  Visibility(
            //    visible: true,
            //               child:
            RefreshIndicator(
              onRefresh: _handleRefresh,
              key: _refresh,
              child: Container(),
            ),
            Flexible(
              child: 
              StreamBuilder(
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
                            child: 
                            RefreshIndicator(
                              onRefresh: _handleRefresh,
                              child:
                               ListView.builder(
                                // reverse: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  var post = snapshot.data[index];
                                  return Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withAlpha(50),
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Container(
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(ImageUrl
                                                                .imageProfile +
                                                            post['user_img']),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      post['user_username'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: Text(
                                                        post['comment_time'],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                ),
                                                Text(
                                                  post['comment_content'],
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14,
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
                                  ],
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
            ),
            //  ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   reverse: true,
            //   itemBuilder: (_, int index) => _messages[index],
            //   itemCount: _messages.length,
            // ),
            // Text(counter.toString()),
            // ),

            // ),
            Container(child: _commentfield())
          ],
        ),
      ),
      // ),
    );
        // ),
        // body: 
        // // RefreshIndicator(
        // //   onRefresh: _lihatComment,
        // //   key: _refresh,
        // //   child:
        //    Column(children: <Widget>[
        //     // ListView(primary: true, children: <Widget>[
        //     Flexible(
        //       child: loading
        //           ? Center(child: CircularProgressIndicator())
        //           : list.isEmpty
        //               ? Center(
        //                   child: Text("Comment kosong",
        //                       style: new TextStyle(fontSize: 30.0)))
        //               : Flexible(
                          // child: ListView.builder(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     scrollDirection: Axis.vertical,
                          //     itemCount: list.length,
                          //     itemBuilder: (context, i) {
                          //       final x = list[i];
                          //       return Column(
                          //         children: <Widget>[
                          //           Container(
                          //             margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                          //             padding: EdgeInsets.only(
                          //               top: 10,
                          //               bottom: 10,
                          //             ),
                          //             decoration: BoxDecoration(
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.grey.withAlpha(50),
                          //                   offset: Offset(0, 0),
                          //                   blurRadius: 5,
                          //                 ),
                          //               ],
                          //               borderRadius: BorderRadius.circular(5),
                          //               color: Colors.white,
                          //             ),
                          //             child: Row(
                          //               children: <Widget>[
                          //                 Stack(
                          //                   children: <Widget>[
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                         left: 8.0,
                          //                       ),
                          //                       child: Container(
                          //                         child: CircleAvatar(
                          //                           backgroundImage:
                          //                               NetworkImage(ImageUrl
                          //                                       .imageProfile +
                          //                                   x.user_img),
                          //                           minRadius: 25,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 Padding(
                          //                   padding: EdgeInsets.only(
                          //                     left: 15,
                          //                   ),
                          //                 ),
                          //                 Expanded(
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                     children: <Widget>[
                          //                       Row(
                          //                         children: <Widget>[
                          //                           Text(
                          //                             x.user_username,
                          //                             style: TextStyle(
                          //                               color: Colors.black,
                          //                               fontSize: 17,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                             ),
                          //                           ),
                          //                           Padding(
                          //                             padding:
                          //                                 const EdgeInsets.only(
                          //                                     left: 5.0),
                          //                             child: Text(
                          //                               x.comment_time,
                          //                               style: TextStyle(
                          //                                 color:
                          //                                     Colors.grey[600],
                          //                                 fontSize: 10,
                          //                                 fontWeight:
                          //                                     FontWeight.bold,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       Padding(
                          //                         padding: EdgeInsets.only(
                          //                           top: 5,
                          //                         ),
                          //                       ),
                          //                       Text(
                          //                         x.comment_content,
                          //                         style: TextStyle(
                          //                           color: Colors.black54,
                          //                           fontSize: 14,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 Column(
                          //                   children: <Widget>[
                          //                     Padding(
                          //                       padding: EdgeInsets.only(
                          //                         right: 15,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       );
                          //     }),
        //                 ),
        //     ),
        //     // Positioned(
        //     //   bottom: 0,
        //     //   left: 0,
        //     //   width: MediaQuery.of(context).size.width,
        //     //   child: Form(
        //     //     key: _key,
        //     //     child: Container(
        //     //       padding: EdgeInsets.all(10),
        //     //       decoration: BoxDecoration(
        //     //         color: Colors.white,
        //     //         boxShadow: [
        //     //           BoxShadow(
        //     //             color: Colors.grey[300],
        //     //             offset: Offset(-2, 0),
        //     //             blurRadius: 5,
        //     //           ),
        //     //         ],
        //     //       ),
        //     //       child: Row(
        //     //         children: <Widget>[
        //     //           Expanded(
        //     //             child: TextFormField(

        //     //               keyboardType: TextInputType.text,
        //     //               controller: txtCommentContent,
        //     //               // validator: (e) {
        //     //               //                     if (e.isEmpty) {
        //     //               //                       return "Komen gk boleh kosong";
        //     //               //                     }
        //     //               //                   },
        //     //               // validator: (e) {
        //     //               //                     if (e.isEmpty) {
        //     //               //                       return "Comment cannot empty";
        //     //               //                     }
        //     //               //                   },
        //     //               onSaved: (e) => comment_content = e,
        //     //               decoration: InputDecoration(
        //     //                 hintText: 'Enter Message',
        //     //                 border: InputBorder.none,
        //     //               ),
        //     //             ),
        //     //           ),
        //     //           IconButton(
        //     //             icon: Icon(
        //     //               Icons.send,
        //     //               color: Colors.black,
        //     //             ),
        //     //             onPressed: () {
        //     //               check();
        //     //             },
        //     //           ),
        //     //         ],
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),  // )
        //     // ]),
        //     Container(child: _commentfield())
        //   ]),
        // // )
        // )
        // ;
  }

  // new CommentData(
  //   icon: 'assets/images/Profile_Icon_5.jpg',
  //   username: 'flowerstem',
  //   comment: 'This is epic!',
  // ),
  // new CommentData(
  //   icon: 'assets/images/Profile_Icon_6.jpg',
  //   username: 'dimples',
  //   comment: 'Can we collab?',
  // ),
  // new CommentData(
  //   icon: 'assets/images/Profile_Icon_7.jpg',
  //   username: 'makeitright',
  //   comment: 'I cannnot believe someone can be this creative',
  // ),
  // new CommentData(
  //   icon: 'assets/images/Profile_Icon_8.jpg',
  //   username: 'dionysus',
  //   comment: 'Wow this is what talent looks like',
  // ),

}

// class CommentData extends StatelessWidget {
//   CommentData({
//     this.icon,
//     this.username,
//     this.comment,
//   });

//   final String icon;
//   final String username;
//   final String comment;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           ListView.builder(
//             itemCount: 1,
//             shrinkWrap: true,
//             physics: ClampingScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             itemBuilder: (BuildContext context, int index) {
//               return Material(
//                 child: Container(
//                   margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
//                   padding: EdgeInsets.only(
//                     top: 10,
//                     bottom: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withAlpha(50),
//                         offset: Offset(0, 0),
//                         blurRadius: 5,
//                       ),
//                     ],
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.white,
//                   ),
//                   child: Row(
//                     children: <Widget>[
//                       Stack(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 8.0,
//                             ),
//                             child: Container(
//                               child: CircleAvatar(
//                                 backgroundImage: AssetImage(
//                                   icon,
//                                 ),
//                                 minRadius: 25,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 15,
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Text(
//                               username,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 top: 5,
//                               ),
//                             ),
//                             Text(
//                               comment,
//                               style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(
//                               right: 15,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
