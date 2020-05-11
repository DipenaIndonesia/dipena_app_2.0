import 'dart:convert';

import 'package:dipena/inside_app/chatFromList.dart';
import 'package:dipena/inside_app/chatFromListTwo.dart';
import 'package:dipena/model/listChat.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'chat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
      final GlobalKey<RefreshIndicatorState> _refreshList =
      GlobalKey<RefreshIndicatorState>();
  String user_id, valuee, follow_user_one, user_username;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      user_username = preferences.getString("user_username");
      // follow_user_one = preferences.getString("user_id");
    });
  }

  var loading = false;
  final list = new List<ListChat>();
  Future<void> _lihatDataPost() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post(ChatUrl.listChat, body: {
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
        final ab = new ListChat(
            api['chat_content'],
            api['chat_time'],
            api['user_username'],
            api['user_img'],
            api['chat_user_two'],
            api['chat_user_one'],
            api['user_username_from'],
            api['user_img_from']);
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
    _lihatDataPost();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        minRadius: 30, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          elevation: 2,
          backgroundColor: Color.fromRGBO(244, 217, 66, 1),
          title: Text(
            'Chats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatDataPost,
        key: _refresh,
        child: RefreshIndicator(
          onRefresh: _lihatDataPost,
          key: _refreshList,
                  child: list.isEmpty
              ? Center(
                  child: Text("ANDA BELUM CHAT SIAPAPUN"),
                )
              : loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Material(
                          child: x.user_username != user_username ? 
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => ChatFromList(x),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                        child: 
                                         Container(
                                          child: x.user_username != user_username
                                              ? x.user_img == null ? placeholder :
                                              CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      ImageUrl.imageProfile +
                                                          x.user_img),
                                                  minRadius: 30,
                                                )
                                              : x.user_img_from == null ? placeholder :
                                              CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      ImageUrl.imageProfile +
                                                          x.user_img_from),
                                                  minRadius: 30,
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
                                      children: <Widget>[
                                        x.user_username != user_username
                                            ? InkWell(
                                                // onTap: () async {
                                                //   await Navigator.push(
                                                //     context,
                                                //     new MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           ChatFromList(x),
                                                //     ),
                                                //   );
                                                // },
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'to : ',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      x.user_username,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : InkWell(
                                                // onTap: () async {
                                                //   await Navigator.push(
                                                //     context,
                                                //     new MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           ChatFromListTwo(x),
                                                //     ),
                                                //   );
                                                // },
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'from : ',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      x.user_username_from,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 5,
                                          ),
                                        ),
                                        Text(
                                          x.chat_content,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 5,
                                          ),
                                        ),
                                        Text(
                                          x.chat_time,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
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
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                          :
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => ChatFromListTwo(x),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                          child: x.user_username != user_username
                                              ? x.user_img == null ? placeholder :
                                              CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      ImageUrl.imageProfile +
                                                          x.user_img),
                                                  minRadius: 30,
                                                )
                                              : x.user_img_from == null ? placeholder :
                                              CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      ImageUrl.imageProfile +
                                                          x.user_img_from),
                                                  minRadius: 30,
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
                                      children: <Widget>[
                                        x.user_username != user_username
                                            ? InkWell(
                                                // onTap: () async {
                                                //   await Navigator.push(
                                                //     context,
                                                //     new MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           ChatFromList(x),
                                                //     ),
                                                //   );
                                                // },
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'to : ',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      x.user_username,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : InkWell(
                                                // onTap: () async {
                                                //   await Navigator.push(
                                                //     context,
                                                //     new MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           ChatFromListTwo(x),
                                                //     ),
                                                //   );
                                                // },
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'from : ',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      x.user_username_from,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 5,
                                          ),
                                        ),
                                        Text(
                                          x.chat_content,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 5,
                                          ),
                                        ),
                                        Text(
                                          x.chat_time,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
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
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
