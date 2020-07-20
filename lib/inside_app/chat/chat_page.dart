import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dipena/model/listChat.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class Chat extends StatefulWidget {
  final ListChatModels model;
  Chat(this.model);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<RefreshIndicatorState> _refresh =
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

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
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

  submit() async {
    if (_imageFile == null) {
      await getPref();
      final response = await http
          .post("https://dipena.com/flutter/api/chat/sendMessage.php", body: {
        // "user_id": user_id,
        // "post_user_id": widget.model.post_user_id,
        // "chat_content": chat_content,
        "user_id": user_id,
        "user_id_two": widget.model.chat_user_one,
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
          "https://dipena.com/flutter/api/chat/sendMessageWithImage2_0.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['user_id'] = user_id;
      request.fields['user_id_two'] = widget.model.chat_user_one;
      // request.fields['chat_content'] = chat_content;

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

  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;

  Future fetchPost() async {
    await getPref();
    final response = await http
        .post('https://dipena.com/flutter/api/chat/selectChatOne.php', body: {
      "user_id": user_id,
      "post_user_id": widget.model.chat_user_one,
      // "post_user_id": user_id,
      // "post_user_id": widget.model.chat_user_two,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
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

  loadPosts() async {
    fetchPost().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  Future<Null> _handleRefresh() async {
    // count++;
    // print(count);
    fetchPost().then((res) async {
      _postsController.add(res);
      // showSnack();
      return null;
    });
  }

  Timer timer;
  int counter = 0;

  test() async {
    await getPref();
    return print(user_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer =
        Timer.periodic(Duration(milliseconds: 250), (Timer t) => addValue());
    super.initState();
    // _tapGallery = new TapGestureRecognizer()..onTap = () => _pilihCamera();
    // _tapCamera = new TapGestureRecognizer()..onTap = () => _pilihGallery();
    getPref();
    _postsController = new StreamController();
    loadPosts();
    // fetchPost();
    print(widget.model.chat_user_one);
    // print(user_id);
    test();
  }

  @override
  void dispose() {
    // _tapGallery.dispose();
    // _tapCamera.dispose();
    timer?.cancel();
    super.dispose();
  }

  Widget _popUpImage(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Text("Choose Method"),
            actions: <Widget>[
              Container(
                color: Colors.white,
                child: CupertinoDialogAction(
                  child: Text(
                    'Camera',
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _pilihCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                color: Colors.white,
                child: CupertinoDialogAction(
                  child: Text(
                    'Gallery',
                    style: new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _pilihGallery();
                    // delete();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ]),
      ),
    );
  }

  Widget _chatField() {
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
          child: _imageFile == null
              ? Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _popUpImage(context),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: txtChat,
                         onSaved: (e) => chat_content = e,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter Message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: "Poppins Regular",
                          ),
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
                      },
                    ),
                  ],
                )
              : Container(
                  height: MediaQuery.of(context).size.height / 2 - 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.file(_imageFile),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          check();
                        },
                      ),
                    ],
                  ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
      backgroundImage: AssetImage(
        "assets/img/icon_one.jpg",
      ),
      backgroundColor: Colors.grey[200],
      minRadius: 30,
    );
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: widget.model.user_img_from == null
                  ? placeholder
                  : CircleAvatar(
                      backgroundImage: NetworkImage(
                          // "assets/img/icon_one.jpg",
                          ImageUrl.imageProfile + widget.model.user_img_from),
                      backgroundColor: Colors.grey[200],
                      minRadius: 30,
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  // "Sasha Witt",
                  widget.model.user_fullname_from,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Poppins Medium",
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: '@',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.model.user_username_from,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins Regular",
                              fontSize: 13,
                            )),
                      ]),
                ),
                // Text(
                //   // "@sasha",
                //   widget.model.user_username_from,
                //   style: TextStyle(
                //     color: Color(0xFF7F8C8D),
                //     fontSize: 13,
                //     fontFamily: "Poppins Regular",
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
      body:
          // Stack(
          //   children: <Widget>[
          //     RefreshIndicator(
          //       onRefresh: _handleRefresh,
          //       key: _refresh,
          //       child: Container(),
          //     ),
          //     Container(
          //       color: Colors.white,
          //       child: Column(
          //         children: <Widget>[
          //           Flexible(
          //               child: StreamBuilder(
          //                   stream: _postsController.stream,
          //                   builder:
          //                       (BuildContext context, AsyncSnapshot snapshot) {
          //                     print('Has error: ${snapshot.hasError}');
          //                     print('Has data: ${snapshot.hasData}');
          //                     print('Snapshot Data ${snapshot.data}');
          //                     if (snapshot.hasError) {
          //                       return Text(snapshot.error);
          //                     }

          //                     if (snapshot.hasData) {
          //                       return ListView.builder(
          //                         itemCount: snapshot.data.length,
          //                         // shrinkWrap: true,
          //                         reverse: true,
          //                         physics: const AlwaysScrollableScrollPhysics(),
          //                         itemBuilder: (context, index) {
          //                           var post = snapshot.data[index];
          //                           return Padding(
          //                             padding: EdgeInsets.all(10),
          //                             child: Column(
          //                               children: <Widget>[
          //                                 // Text(
          //                                 //   "Today",
          //                                 //   style: TextStyle(
          //                                 //     color: new Color(0xFF7F8C8D),
          //                                 //     fontSize: 12,
          //                                 //     fontFamily: "Poppins Regular",
          //                                 //   ),
          //                                 // Text(
          //                                 //   "Today",
          //                                 //   style: TextStyle(
          //                                 //     color: new Color(0xFF7F8C8D),
          //                                 //     fontSize: 12,
          //                                 //     fontFamily: "Poppins Regular",
          //                                 //   ),
          //                                 // ),
          //                                 // Bubble(
          //                                 //   message: "Selamat siang",
          //                                 //   isMe: true,
          //                                 // ),
          //                                 // Bubble(
          //                                 //   message: 'Apakah lukisan ini di jual?',
          //                                 //   isMe: true,
          //                                 // ),
          //                                 // Text(
          //                                 //   "Dec 15, 2019",
          //                                 //   style: TextStyle(
          //                                 //     color: new Color(0xFF7F8C8D),
          //                                 //     fontSize: 12,
          //                                 //     fontFamily: "Poppins Regular",
          //                                 //   ),
          //                                 // ),
          //                                 // Bubble(
          //                                 //   message: "Siang",
          //                                 //   isMe: false,
          //                                 // ),
          //                                 // Bubble(
          //                                 //   message: "Iya kami menjualnya",
          //                                 //   isMe: false,
          //                                 // ),
          //                                 post['chat_img'] == null
          //                                     ? post["chat_user_one"] == user_id
          //                                         ? Bubble(
          //                                             message: post["chat_content"],
          //                                             isMe: true,
          //                                           )
          //                                         : Bubble(
          //                                             message: post["chat_content"],
          //                                             isMe: false,
          //                                           )
          //                                     // Text("Gk ada gambar ")
          //                                     :
          //                                     //     ? post["chat_user_one"] == user_id
          //                                     //         ? Bubble(
          //                                     //             message:
          //                                     //                 post["chat_content"],
          //                                     //             isMe: true,
          //                                     //           )
          //                                     //         : Bubble(
          //                                     //             message:
          //                                     //                 post["chat_content"],
          //                                     //             isMe: false,
          //                                     //           )
          //                                     //     : Column(
          //                                     //         children: <Widget>[
          //                                     //           post["chat_user_one"] ==
          //                                     //                   user_id
          //                                     //               ?  Column(
          //                                     //                   children: <Widget>[
          //                                     post["chat_user_one"] == user_id
          //                                         ? Column(
          //                                             children: <Widget>[
          //                                               Align(
          //                                                 alignment:
          //                                                     Alignment.centerRight,
          //                                                 child: Container(
          //                                                   width: MediaQuery.of(
          //                                                               context)
          //                                                           .size
          //                                                           .width /
          //                                                       2,
          //                                                   child: Image.network(
          //                                                       ImageUrl.imageChat +
          //                                                           post[
          //                                                               'chat_img']),
          //                                                 ),
          //                                               ),
          //                                               Bubble(
          //                                                 message:
          //                                                     post["chat_content"],
          //                                                 isMe: true,
          //                                               )
          //                                             ],
          //                                           )
          //                                         : Column(
          //                                             children: <Widget>[
          //                                               Align(
          //                                                 alignment:
          //                                                     Alignment.centerLeft,
          //                                                 child: Container(
          //                                                   width: MediaQuery.of(
          //                                                               context)
          //                                                           .size
          //                                                           .width /
          //                                                       2,
          //                                                   child: Image.network(
          //                                                       ImageUrl.imageChat +
          //                                                           post[
          //                                                               'chat_img']),
          //                                                 ),
          //                                               ),
          //                                               Bubble(
          //                                                 message:
          //                                                     post["chat_content"],
          //                                                 isMe: false,
          //                                               )
          //                                             ],
          //                                           ),
          //                                           Text(post['chat_content'])
          //                               ],
          //                             ),
          //                           );
          //                         },
          //                       );
          //                     }
          //                     if (snapshot.connectionState !=
          //                         ConnectionState.done) {
          //                       return Center(
          //                         child: CircularProgressIndicator(),
          //                       );
          //                     }

          //                     if (!snapshot.hasData &&
          //                         snapshot.connectionState ==
          //                             ConnectionState.done) {
          //                       return Text('No Chats');
          //                     }
          //                   }))
          //         ],
          //       ),
          //     ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   width: MediaQuery.of(context).size.width,
          //   child: Container(
          //     padding: EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey[300],
          //           offset: Offset(-2, 0),
          //           blurRadius: 5,
          //         ),
          //       ],
          //     ),
          //     child: Row(
          //       children: <Widget>[
          //         IconButton(
          //           icon: Icon(
          //             Icons.image,
          //             color: Colors.black,
          //           ),
          //           onPressed: () {},
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(
          //             left: 15,
          //           ),
          //         ),
          //         Expanded(
          //           child: TextFormField(
          //             keyboardType: TextInputType.text,
          //             decoration: InputDecoration(
          //               hintText: "Enter Message",
          //               border: InputBorder.none,
          //               hintStyle: TextStyle(
          //                 fontFamily: "Poppins Regular",
          //               ),
          //             ),
          //           ),
          //         ),
          //         IconButton(
          //           icon: Icon(
          //             Icons.send,
          //             color: Colors.black,
          //           ),
          //           onPressed: () {},
          //         ),
          //       ],
          //     ),
          //   ),
          // )
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
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: Align(
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
                                                      ),
                                                      // Bubble(
                                                      //   message: post[
                                                      //       "chat_content"],
                                                      //   isMe: true,
                                                      // )
                                                    ],
                                                  )
                                                : Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 8.0),
                                                        child: Align(
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
                                                      ),
                                                      // Bubble(
                                                      //   message: post[
                                                      //       "chat_content"],
                                                      //   isMe: false,
                                                      // )
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
            Container(child: _chatField())
          ],
        ),
      ),
      //     Container(child: _chatField())
      //   ],
      // ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 5),
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
                  color: isMe ? Colors.grey[600] : Colors.grey[300],
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
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
