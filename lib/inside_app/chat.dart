import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dipena/url.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:flutter/gestures.dart';

import 'package:dipena/inside_app/testRealTimeChat.dart';
import 'package:dipena/model/chatData.dart';
import 'package:dipena/model/seeDeals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final SeeDeals model;
  Chat(this.model);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshChat =
      GlobalKey<RefreshIndicatorState>();

  final _key = new GlobalKey<FormState>();

  TextEditingController txtChat = TextEditingController();

  String user_id, chat_content;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
    });
  }

  submit() async {
    if (_imageFile == null) {
      await getPref();
      final response = await http
          .post("https://dipena.com/flutter/api/chat/sendMessage.php", body: {
        "user_id": user_id,
        "post_user_id": widget.model.post_user_id,
        "chat_content": chat_content,
      });
      final data = jsonDecode(response.body);
      int value = data['value'];
      String pesan = data['message'];
      if (value == 1) {
        print(pesan);
        setState(() {
          txtChat.clear();
        });
      } else {
        print(pesan);
      }
    }
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(
          "https://dipena.com/flutter/api/chat/sendMessageWithImage.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['user_id'] = user_id;
      request.fields['post_user_id'] = widget.model.post_user_id;
      request.fields['chat_content'] = chat_content;

      request.files.add(http.MultipartFile("chat_img", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode > 2) {
        final data = jsonDecode(respStr);
        String img = data['img'];
        print("Image uploaded");
        print(img);
        setState(() {
          txtChat.clear();
          _imageFile = null;
        });
      } else {
        print("Image failed to be upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  // var loading = false;
  // final list = new List<ChatContent>();
  // Future<void> _chatContent() async {
  //   await getPref();
  //   list.clear();
  //   setState(() {
  //     _messages.clear();
  //     loading = true;
  //   });
  //   final response = await http
  //       .post("https://dipena.com/flutter/api/chat/selectChatOne.php", body: {
  //     "user_id": user_id,
  //     "post_user_id": widget.model.post_user_id,
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
  //       final ab = new ChatContent(
  //           api['chat_id'],
  //           api['chat_user_one'],
  //           api['chat_user_two'],
  //           api['chat_content'],
  //           api['user_username'],
  //           api['user_img']);
  //       list.add(ab);
  //     });
  //     setState(() {
  //       _messages.clear();
  //       loading = false;
  //     });
  //   }
  // }

  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmit(String text) {
    txtChat.clear();
    ChatMessage message = new ChatMessage(text: text);
    setState(() {
      _messages.insert(0, message);
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  void addValue() {
    // if(list.insert == true){
    setState(() {
      // counter++;
      //  print("nambah");
      // list[i]
      _refresh.currentState.show();
      // _messages.clear();
    });
    // }
  }

  Timer timer;
  int counter = 0;

  TapGestureRecognizer _tapGallery;
  TapGestureRecognizer _tapCamera;

  @override
  void initState() {
    // setState(() {
    //
    //   new Timer.periodic(oneSecond, (Timer t) => setState(() {}));
    // });
    // const oneSecond = const Duration(seconds: 1);
    // new Timer.periodic(oneSecond, (Timer t) => setState((){}));
    // TODO: implement initState
    timer =
        Timer.periodic(Duration(milliseconds: 250), (Timer t) => addValue());
    super.initState();
    _tapGallery = new TapGestureRecognizer()..onTap = () => _pilihCamera();
    _tapCamera = new TapGestureRecognizer()..onTap = () => _pilihGallery();
    getPref();
    _postsController = new StreamController();
    loadPosts();
    // _chatContent();
    // _chatContentTwo();
  }

  @override
  void dispose() {
    _tapGallery.dispose();
    _tapCamera.dispose();
    timer?.cancel();
    super.dispose();
  }

  File _imageFile;

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  _pilihCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  Widget _popUpGallery(BuildContext context) {
    return new AlertDialog(
      title: Text("Choose Method"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _pilihGallery();
            },
            child: Text("Gallery")),
        FlatButton(
            onPressed: () {
              _pilihCamera();
            },
            child: Text("Camera")),
      ],
    );
  }

  Widget _chatfield() {
    var placeholder = Container(
      width: 20,
      height: 20,
      child: Image.asset('./img/placeholder.png'),
    );
    return Form(
      key: _key,
      // child: Positioned(
      //   bottom: 0,
      //   left: 0,
      //   width: MediaQuery.of(context).size.width,
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
            _imageFile == null
                ? IconButton(
                    icon: Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _popUpGallery(context),
                      );
                    },
                  )
                : InkWell(
                    child: Container(
                        height: 30.0,
                        width: 30.0,
                        child: Image.file(_imageFile)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _popUpGallery(context),
                      );
                    },
                  ),

            // InkWell(
            //   onTap: () {
            //     AlertDialog(
            //       title: Text("Choose Method"),
            //       actions: <Widget>[
            //         FlatButton(
            //             onPressed: () {
            //               _pilihGallery();
            //             },
            //             child: Text("Gallery")),
            //         FlatButton(
            //             onPressed: () {
            //               _pilihCamera();
            //             },
            //             child: Text("Camera")),
            //       ],
            //     );
            //   },
            //   child: _imageFile == null
            //         ? Icon(
            //             Icons.image,
            //             color: Colors.black,
            //           )
            //         : Image.file(_imageFile),
            //   ),
            Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
            ),
            Flexible(
              child: TextFormField(
                controller: txtChat,
                onFieldSubmitted: _handleSubmit,
                keyboardType: TextInputType.text,
                onSaved: (e) => chat_content = e,
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
                _handleSubmit(txtChat.text);
              },
            ),
          ],
        ),
      ),
    );
    // );
  }

  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;

  Future fetchPost() async {
    await getPref();
    final response = await http
        .post('https://dipena.com/flutter/api/chat/selectChatOne.php', body: {
      "user_id": user_id,
      "post_user_id": widget.model.post_user_id,
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
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          centerTitle: true,
          elevation: 3,
          backgroundColor: Color.fromRGBO(244, 217, 66, 1),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: widget.model.user_img == null ?
                placeholder :
                 CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://dipena.com/flutter/image_profile/' +
                          widget.model.user_img),
                  backgroundColor: Colors.grey[200],
                  minRadius: 30,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model.user_username,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  )
                ],
              )
            ],
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
                            child: RefreshIndicator(
                              onRefresh: _handleRefresh,
                              child: ListView.builder(
                                reverse: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  var post = snapshot.data[index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      children: <Widget>[
                                        // post["chat_user_one"] == user_id
                                        //     ? Bubble(
                                        //         message: post["chat_content"],
                                        //         isMe: true,
                                        //       )
                                        //     : Bubble(
                                        //         message: post["chat_content"],
                                        //         isMe: false,
                                        //       ),
                                        post['chat_img'] == null
                                            ? post["chat_user_one"] == user_id
                                                ? Bubble(
                                                    message:
                                                        post["chat_content"],
                                                    isMe: true,
                                                  )
                                                : Bubble(
                                                    message:
                                                        post["chat_content"],
                                                    isMe: false,
                                                  )
                                            // Text("Gk ada gambar ")
                                            :
                                            //     ? post["chat_user_one"] == user_id
                                            //         ? Bubble(
                                            //             message:
                                            //                 post["chat_content"],
                                            //             isMe: true,
                                            //           )
                                            //         : Bubble(
                                            //             message:
                                            //                 post["chat_content"],
                                            //             isMe: false,
                                            //           )
                                            //     : Column(
                                            //         children: <Widget>[
                                            //           post["chat_user_one"] ==
                                            //                   user_id
                                            //               ?  Column(
                                            //                   children: <Widget>[
                                            post["chat_user_one"] == user_id
                                                ? Column(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          child: Image.network(
                                                              ImageUrl.imageChat +
                                                                  post[
                                                                      'chat_img']),
                                                        ),
                                                      ),
                                                      Bubble(
                                                        message: post[
                                                            "chat_content"],
                                                        isMe: true,
                                                      )
                                                    ],
                                                  )
                                                : Column(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          child: Image.network(
                                                              ImageUrl.imageChat +
                                                                  post[
                                                                      'chat_img']),
                                                        ),
                                                      ),
                                                      Bubble(
                                                        message: post[
                                                            "chat_content"],
                                                        isMe: false,
                                                      )
                                                    ],
                                                  )
                                        //                     Bubble(
                                        //                       message: post[
                                        //                           "chat_content"],
                                        //                       isMe: true,
                                        //                     )
                                        //                   ],
                                        //                 )
                                        //               : Column(
                                        //                   children: <Widget>[
                                        //                     Image.network(ImageUrl
                                        //                             .imageChat+
                                        //                         post[
                                        //                             'chat_img']),
                                        //                     Bubble(
                                        //                       message: post[
                                        //                           "chat_content"],
                                        //                       isMe: false,
                                        //                     ),
                                        //                   ],
                                        //                 )
                                        //         ],
                                        //       )

                                        //  Bubble(
                                        //             message:
                                        //                 post["chat_content"],
                                        //             isMe: false,
                                        //           )
                                      ],
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
            Container(child: _chatfield())
          ],
        ),
      ),
      // ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return ListView(
      // primary: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          padding: isMe
              ? EdgeInsets.only(
                  left: 40,
                )
              : EdgeInsets.only(
                  right: 40,
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Color.fromRGBO(244, 217, 66, 1)
                          : Colors.grey[300],
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(0),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message,
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ChatContent {
  final String chat_id;
  final String chat_user_one;
  final String chat_user_two;
  final String chat_content;
  final String user_username;
  final String user_img;

  ChatContent.fromJsonMap(Map map)
      : chat_id = map['chat_id'],
        chat_user_one = map['chat_user_one'],
        chat_user_two = map['chat_user_two'],
        chat_content = map['chat_content'],
        user_username = map['user_username'],
        user_img = map['user_img'];
}
