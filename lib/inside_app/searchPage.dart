import 'dart:convert';

import 'package:dipena/inside_app/chatFromList.dart';
import 'package:dipena/inside_app/chatFromListTwo.dart';
import 'package:dipena/inside_app/searchAnotherUserProfile.dart';
import 'package:dipena/model/listChat.dart';
import 'package:dipena/model/searchClass.dart';
// import 'package:dipena/model/searchClass.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'chat.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshList =
      GlobalKey<RefreshIndicatorState>();
  String user_id, valuee, follow_user_one, user_username;

  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     user_id = preferences.getString("user_id");
  //     user_username = preferences.getString("user_username");
  //     // follow_user_one = preferences.getString("user_id");
  //   });
  // }

  // var loading = false;
  // final list = new List<ListChat>();
  // Future<void> _lihatDataPost() async {
  //   await getPref();
  //   list.clear();
  //   setState(() {
  //     loading = true;
  //   });
  //   final response = await http
  //       .post(ChatUrl.listChat, body: {
  //     "user_id": user_id,
  //   });
  //   if (response.contentLength == 2) {
  //     //   await getPref();
  //     // final response =
  //     //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
  //     //   "user_id": user_id,
  //     //   "location_country": location_country,
  //     //   "location_city": location_city,
  //     //   "location_user_id": user_id
  //     // });

  //     // final data = jsonDecode(response.body);
  //     // int value = data['value'];
  //     // String message = data['message'];
  //     // String changeProf = data['changeProf'];
  //   } else {
  //     final data = jsonDecode(response.body);
  //     data.forEach((api) {
  //       final ab = new ListChat(
  //           api['chat_content'],
  //           api['chat_time'],
  //           api['user_username'],
  //           api['user_img'],
  //           api['chat_user_two'],
  //           api['chat_user_one'],
  //           api['user_username_from'],
  //           api['user_img_from']);
  //       list.add(ab);
  //     });
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  List<SearchClass> _list = [];
  List<SearchClass> _search = [];
  var loading = false;
  Future<Null> fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
        await http.get("https://dipena.com/flutter/api/search/search.php");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(SearchClass.formJson(i));
          loading = false;
        }
      });
    }
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _list.forEach((f) {
      if (f.user_username.contains(text) ||
          f.user_fullname.contains(text) ||
          f.user_email.contains(text)) _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        minRadius: 23, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(62),
        //   child: AppBar(
        //     elevation: 2,
        //     backgroundColor: Color.fromRGBO(244, 217, 66, 1),
        //     title: Text(
        //       'Chats',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 20,
        //       ),
        //     ),
        //   ),
        // ),
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.0),
            // color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              // child: Card(
              child: ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black),
                title: TextField(
                  cursorColor: Colors.grey,
                  cursorWidth: 1,
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.grey,
                    //  Color.fromRGBO(244, 217, 66, 1),
                    fontSize: 20,
                    // fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                  controller: controller,
                  onChanged: onSearch,
                  decoration: InputDecoration(
                      hintText: "Search", border: InputBorder.none),
                ),
                trailing: IconButton(
                  onPressed: () {
                    controller.clear();
                    onSearch('');
                  },
                  icon: Icon(Icons.close),
                ),
              ),
              // ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: _search.length != 0 || controller.text.isNotEmpty
                      ? ListView.builder(
                          itemCount: _search.length,
                          itemBuilder: (context, i) {
                            final b = _search[i];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) =>
                                          SearchAnotherProfile(b),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        b.user_img == null
                                            ? placeholder
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    ImageUrl.imageProfile +
                                                        b.user_img),
                                                minRadius: 23,
                                              ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              width: 165,
                                              child: Column(
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(b.user_username,
                                                      textAlign: TextAlign.left,
                                                      style: new TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  // Flexible(
                                                  // child:
                                                  Text(
                                                    b.user_bio ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    softWrap: false,
                                                    // ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(right: 20.0),
                                    //   child: FlatButton(
                                    //     textColor: Colors.black,
                                    //     shape: RoundedRectangleBorder(
                                    //         side: BorderSide(
                                    //             color: Colors.grey,
                                    //             width: 1,
                                    //             style: BorderStyle.solid),
                                    //         borderRadius:
                                    //             BorderRadius.circular(10)),
                                    //     onPressed: () {
                                    //       // print(x.user_id);
                                    //       // setState(() {
                                    //       //   block_user_two_id = x.user_id;
                                    //       // });
                                    //       // block();
                                    //       // _refresh.currentState.show();
                                    //     },
                                    //     child: Text("Unblock"),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            );
                            // Container(
                            //     padding: EdgeInsets.all(10.0),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: <Widget>[
                            //         Text(
                            //           b.user_username,
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 18.0),
                            //         ),
                            //         SizedBox(
                            //           height: 4.0,
                            //         ),
                            //         Text(b.user_id),
                            //       ],
                            //     ));
                          },
                        )
                      : ListView.builder(
                          itemCount: _list.length,
                          itemBuilder: (context, i) {
                            final a = _list[i];
                            return Container(
                                // padding: EdgeInsets.all(10.0),
                                // child: Column(
                                //   crossAxisAlignment:
                                //       CrossAxisAlignment.start,
                                //   children: <Widget>[
                                //     Text(
                                //       a.user_username,
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 18.0),
                                //     ),
                                //     SizedBox(
                                //       height: 4.0,
                                //     ),
                                //     Text(a.user_id),
                                //   ],
                                // )
                                );
                          },
                        ),
                ),
        ],
      ),
    )
        // RefreshIndicator(
        //   onRefresh: _lihatDataPost,
        //   key: _refresh,
        //   child: RefreshIndicator(
        //     onRefresh: _lihatDataPost,
        //     key: _refreshList,
        //             child: list.isEmpty
        //         ? Center(
        //             child: Text("ANDA BELUM CHAT SIAPAPUN"),
        //           )
        //         : loading
        //             ? Center(child: CircularProgressIndicator())
        //             : ListView.builder(
        //                 itemCount: list.length,
        //                 shrinkWrap: true,
        //                 physics: ClampingScrollPhysics(),
        //                 scrollDirection: Axis.vertical,
        //                 itemBuilder: (context, i) {
        //                   final x = list[i];
        //                   return Material(
        //                     child: x.user_username != user_username ?
        //                     InkWell(
        //                       onTap: () async {
        //                         await Navigator.push(
        //                           context,
        //                           new MaterialPageRoute(
        //                             builder: (context) => ChatFromList(x),
        //                           ),
        //                         );
        //                       },
        //                       child: Container(
        //                         margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
        //                         padding: EdgeInsets.only(
        //                           top: 10,
        //                           bottom: 10,
        //                         ),
        //                         decoration: BoxDecoration(
        //                           boxShadow: [
        //                             BoxShadow(
        //                               color: Colors.grey.withAlpha(50),
        //                               offset: Offset(0, 0),
        //                               blurRadius: 5,
        //                             ),
        //                           ],
        //                           borderRadius: BorderRadius.circular(5),
        //                           color: Colors.white,
        //                         ),
        //                         child: Row(
        //                           children: <Widget>[
        //                             Stack(
        //                               children: <Widget>[
        //                                 Padding(
        //                                   padding: const EdgeInsets.only(
        //                                     left: 8.0,
        //                                   ),
        //                                   child:
        //                                    Container(
        //                                     child: x.user_username != user_username
        //                                         ? x.user_img == null ? placeholder :
        //                                         CircleAvatar(
        //                                             backgroundImage: NetworkImage(
        //                                                 ImageUrl.imageProfile +
        //                                                     x.user_img),
        //                                             minRadius: 30,
        //                                           )
        //                                         : x.user_img_from == null ? placeholder :
        //                                         CircleAvatar(
        //                                             backgroundImage: NetworkImage(
        //                                                 ImageUrl.imageProfile +
        //                                                     x.user_img_from),
        //                                             minRadius: 30,
        //                                           ),
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                             Padding(
        //                               padding: EdgeInsets.only(
        //                                 left: 15,
        //                               ),
        //                             ),
        //                             Expanded(
        //                               child: Column(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: <Widget>[
        //                                   x.user_username != user_username
        //                                       ? InkWell(
        //                                           // onTap: () async {
        //                                           //   await Navigator.push(
        //                                           //     context,
        //                                           //     new MaterialPageRoute(
        //                                           //       builder: (context) =>
        //                                           //           ChatFromList(x),
        //                                           //     ),
        //                                           //   );
        //                                           // },
        //                                           child: Row(
        //                                             children: <Widget>[
        //                                               Text(
        //                                                 'to : ',
        //                                                 style: TextStyle(
        //                                                   color: Colors.grey[600],
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                               Text(
        //                                                 x.user_username,
        //                                                 style: TextStyle(
        //                                                   color: Colors.black,
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         )
        //                                       : InkWell(
        //                                           // onTap: () async {
        //                                           //   await Navigator.push(
        //                                           //     context,
        //                                           //     new MaterialPageRoute(
        //                                           //       builder: (context) =>
        //                                           //           ChatFromListTwo(x),
        //                                           //     ),
        //                                           //   );
        //                                           // },
        //                                           child: Row(
        //                                             children: <Widget>[
        //                                               Text(
        //                                                 'from : ',
        //                                                 style: TextStyle(
        //                                                   color: Colors.grey[600],
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                               Text(
        //                                                 x.user_username_from,
        //                                                 style: TextStyle(
        //                                                   color: Colors.black,
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                   Padding(
        //                                     padding: EdgeInsets.only(
        //                                       top: 5,
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     x.chat_content,
        //                                     style: TextStyle(
        //                                       color: Colors.black54,
        //                                       fontSize: 14,
        //                                     ),
        //                                   ),
        //                                   Padding(
        //                                     padding: EdgeInsets.only(
        //                                       top: 5,
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     x.chat_time,
        //                                     style: TextStyle(
        //                                       color: Colors.grey,
        //                                       fontSize: 12,
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                             Column(
        //                               children: <Widget>[
        //                                 Padding(
        //                                   padding: EdgeInsets.only(
        //                                     right: 15,
        //                                   ),
        //                                   child: Icon(
        //                                     Icons.chevron_right,
        //                                     size: 18,
        //                                   ),
        //                                 ),
        //                               ],
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     )
        //                     :
        //                     InkWell(
        //                       onTap: () async {
        //                         await Navigator.push(
        //                           context,
        //                           new MaterialPageRoute(
        //                             builder: (context) => ChatFromListTwo(x),
        //                           ),
        //                         );
        //                       },
        //                       child: Container(
        //                         margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
        //                         padding: EdgeInsets.only(
        //                           top: 10,
        //                           bottom: 10,
        //                         ),
        //                         decoration: BoxDecoration(
        //                           boxShadow: [
        //                             BoxShadow(
        //                               color: Colors.grey.withAlpha(50),
        //                               offset: Offset(0, 0),
        //                               blurRadius: 5,
        //                             ),
        //                           ],
        //                           borderRadius: BorderRadius.circular(5),
        //                           color: Colors.white,
        //                         ),
        //                         child: Row(
        //                           children: <Widget>[
        //                             Stack(
        //                               children: <Widget>[
        //                                 Padding(
        //                                   padding: const EdgeInsets.only(
        //                                     left: 8.0,
        //                                   ),
        //                                   child: Container(
        //                                     child: x.user_username != user_username
        //                                         ? x.user_img == null ? placeholder :
        //                                         CircleAvatar(
        //                                             backgroundImage: NetworkImage(
        //                                                 ImageUrl.imageProfile +
        //                                                     x.user_img),
        //                                             minRadius: 30,
        //                                           )
        //                                         : x.user_img_from == null ? placeholder :
        //                                         CircleAvatar(
        //                                             backgroundImage: NetworkImage(
        //                                                 ImageUrl.imageProfile +
        //                                                     x.user_img_from),
        //                                             minRadius: 30,
        //                                           ),
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                             Padding(
        //                               padding: EdgeInsets.only(
        //                                 left: 15,
        //                               ),
        //                             ),
        //                             Expanded(
        //                               child: Column(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: <Widget>[
        //                                   x.user_username != user_username
        //                                       ? InkWell(
        //                                           // onTap: () async {
        //                                           //   await Navigator.push(
        //                                           //     context,
        //                                           //     new MaterialPageRoute(
        //                                           //       builder: (context) =>
        //                                           //           ChatFromList(x),
        //                                           //     ),
        //                                           //   );
        //                                           // },
        //                                           child: Row(
        //                                             children: <Widget>[
        //                                               Text(
        //                                                 'to : ',
        //                                                 style: TextStyle(
        //                                                   color: Colors.grey[600],
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                               Text(
        //                                                 x.user_username,
        //                                                 style: TextStyle(
        //                                                   color: Colors.black,
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         )
        //                                       : InkWell(
        //                                           // onTap: () async {
        //                                           //   await Navigator.push(
        //                                           //     context,
        //                                           //     new MaterialPageRoute(
        //                                           //       builder: (context) =>
        //                                           //           ChatFromListTwo(x),
        //                                           //     ),
        //                                           //   );
        //                                           // },
        //                                           child: Row(
        //                                             children: <Widget>[
        //                                               Text(
        //                                                 'from : ',
        //                                                 style: TextStyle(
        //                                                   color: Colors.grey[600],
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                               Text(
        //                                                 x.user_username_from,
        //                                                 style: TextStyle(
        //                                                   color: Colors.black,
        //                                                   fontSize: 18,
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                   Padding(
        //                                     padding: EdgeInsets.only(
        //                                       top: 5,
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     x.chat_content,
        //                                     style: TextStyle(
        //                                       color: Colors.black54,
        //                                       fontSize: 14,
        //                                     ),
        //                                   ),
        //                                   Padding(
        //                                     padding: EdgeInsets.only(
        //                                       top: 5,
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     x.chat_time,
        //                                     style: TextStyle(
        //                                       color: Colors.grey,
        //                                       fontSize: 12,
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                             Column(
        //                               children: <Widget>[
        //                                 Padding(
        //                                   padding: EdgeInsets.only(
        //                                     right: 15,
        //                                   ),
        //                                   child: Icon(
        //                                     Icons.chevron_right,
        //                                     size: 18,
        //                                   ),
        //                                 ),
        //                               ],
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     )
        //                   );
        //                 },
        //               ),
        //   ),

        );
  }
}
