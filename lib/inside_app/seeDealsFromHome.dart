import 'dart:convert';

import 'package:dipena/inside_app/editPostDeal.dart';
import 'package:dipena/inside_app/navbar.dart';
import 'package:dipena/model/post.dart';
import 'package:dipena/model/profilePost.dart';
import 'package:dipena/model/seeDeals.dart';
import 'package:dipena/model/selectPostFollow.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';

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

class SeeDealsFromHome extends StatefulWidget {
  final PostFollow model;
  SeeDealsFromHome(this.model);
  @override
  _SeeDealsFromHomeState createState() => _SeeDealsFromHomeState();
}

class _SeeDealsFromHomeState extends State<SeeDealsFromHome> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  String message;
  bool isMe;

  String user_id;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      // follow_user_one = preferences.getString("user_id");
    });
  }

  submit() async {
    // try {
    //   var stream =
    //       http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
    //   var length = await _imageFile.length();
    //   var uri = Uri.parse("https://dipena.com/flutter/api/post/addPost.php");
    //   final request = http.MultipartRequest("POST", uri);
    //   request.fields['post_user_id'] = user_id;
    //   request.fields['user_id'] = user_id;
    //   request.fields['post_title'] = post_title;
    //   request.fields['post_location'] = post_location;
    //   request.fields['post_offer'] = post_offer;
    //   request.fields['post_description'] = post_description;

    //   request.files.add(http.MultipartFile("post_img", stream, length,
    //       filename: path.basename(_imageFile.path)));
    //   var response = await request.send();
    //   if (response.statusCode > 2) {
    //     print("Image uploaded");
    //     setState(() {
    //       Navigator.pop(context);
    //     });
    //   } else {
    //     print("Image failed to be upload");
    //   }
    // } catch (e) {
    //   debugPrint("Error $e");
    // }

    await getPref();
    final response = await http.post(DealUrl.takeDeals, body: {
      "user_id": user_id,
      "user_id_two": widget.model.post_user_id,
      // "post_cat_id" : post_cat_id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        // Navigator.push(
        //                                                   context,
        //                                                   new MaterialPageRoute(
        //                                                     builder: (context) =>
        //                                                         Chat(),
        //                                                   ),
        //                                                 );
      });
    } else {
      print(pesan);
    }
  }

  var loading = false;
  final list = new List<SeeDeals>();
  Future<void> _seeDeals() async {
    // await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post(DealUrl.seeDeals, body: {"post_id": widget.model.post_id});
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
            api['user_username'],
            api['user_img']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  delete() async {
    // await getPref();
    await popUpPostId;
    // await report_post_img;
    final response = await http
        .post("https://dipena.com/flutter/api/post/deletePost.php", body: {
      // "user_username": user_username,
      // "user_password": user_password,
      // "user_email": user_email,
      "post_id": popUpPostId,
      // "post_img": report_post_img
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    // String message = data['message'];
    String messageEnglish = data['messageEnglish'];
    // String changeProf = data['changeProf'];
    // String user_usernameAPI = data['user_username'];
    // String user_bioAPI = data['user_bio'];
    // String user_emailAPI = data['user_email'];
    // String user_id = data['user_id'];
    // String user_img = data['user_img'];

    if (value == 1) {
      // Navigator.pop(context);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => NavToHomePage()));
      // _refresh.currentState.show();
      // print(report_post_id);
      // _showToast(messageEnglish);
      // setState(() {
      //   _loginStatus = LoginStatus.signIn;
      //   savePref(value, user_id, user_username, user_emailAPI, user_bioAPI, user_img);
      // });
      // print(message);
      // _showToast(message);
    } else {
      print("fail");
      // _showToast(messageEnglish);
      // print(message);
      // _showToast(messageEnglish);
    }
  }

  Widget _popUpDeleteConfirm(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Text("Are you sure want to delete this post?"),
            actions: <Widget>[
              Container(
                color: Colors.grey,
                child: CupertinoDialogAction(
                  child: Text(
                    'Cancel',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                color: Colors.red[400],
                child: CupertinoDialogAction(
                  child: Text(
                    'Delete',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    delete();
                    // Navigator.of(context).pop();
                  },
                ),
              ),
            ]),
      ),
    );
  }

  String popUpPostId;
  Widget _popUpMore(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // final x = list[i];
            for (var i = 0; i < list.length; i++)
              list[i].post_id == popUpPostId
                  ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        var navigationResult = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                EditPostDeals(list[i], _seeDeals),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text("Edit Post",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                      ),
                    )
                  : Container(),
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.all(0),
              onPressed: () async {
                // report();
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _popUpDeleteConfirm(context),
                );
                // Navigator.of(context, rootNavigator: true).pop(context);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Delete Post",
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _seeDeals();
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
    SizeConfig().init(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _seeDeals,
        key: _refresh,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                loading
                    ? Center(child: CircularProgressIndicator())
                    : user_id == widget.model.post_user_id
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final x = list[i];
                              return Stack(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 100,
                                    height: SizeConfig.safeBlockVertical * 55,
                                    child: Image.network(
                                      ImageUrl.imageContent + x.post_img,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 40,
                                    ),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.black, 
                                        // Color.fromRGBO(244, 217, 66, 1),
                                        child: InkWell(
                                          splashColor: Colors.purpleAccent,
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                Icons.arrow_back,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 330,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      // height: 500,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          topLeft: Radius.circular(50),
                                        ),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 30,
                                              right: 30,
                                              left: 20,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: x.user_img == null ?
                                                    placeholder : 
                                                    CircleAvatar(
                                                      child: ClipOval(
                                                        child: Image(
                                                          width: 50,
                                                          height: 50,
                                                          image: NetworkImage(
                                                              ImageUrl.imageProfile +
                                                                  x.user_img),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        x.user_username,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // IconButton(
                                                      //   color: Colors.black,
                                                      //   // Color.fromRGBO(
                                                      //   //     244,
                                                      //   //     217,
                                                      //   //     66,
                                                      //   //     1),
                                                      //   icon: Icon(
                                                      //     Icons.more_vert,
                                                      //   ),
                                                      //   onPressed: () async {
                                                      //     setState(() {
                                                      //       popUpPostId =
                                                      //           x.post_id;
                                                      //       // report_post_img =
                                                      //       //     x.post_img;
                                                      //     });
                                                      //     showDialog(
                                                      //       context: context,
                                                      //       builder: (BuildContext
                                                      //               context) =>
                                                      //           _popUpMore(
                                                      //               context),
                                                      //     );
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 25,
                                                    left: 10,
                                                  ),
                                                  child: Container(
                                                    width: 450,
                                                    height: 2,
                                                    color: Color.fromRGBO(
                                                        244, 217, 66, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 20,
                                              left: 30,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.8,
                                                  child: Text(
                                                    x.post_title,
                                                    style: TextStyle(
                                                      fontSize: 21,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 30,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.8,
                                                  child: Text(
                                                    x.post_description,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              right: 285,
                                            ),
                                            child: Container(
                                              color: Color.fromRGBO(
                                                  244, 217, 66, 1),
                                              width: 50,
                                              height: 2,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 30,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Service',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 30,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.8,
                                                  child: Text(
                                                    x.post_offer,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //     top: 10,
                                          //     left: 30,
                                          //   ),
                                          //   child: Row(
                                          //     children: <Widget>[
                                          //       Text(
                                          //         '• Currently available for projects, \n'
                                          //         'not contracts',
                                          //         style: TextStyle(
                                          //           fontSize: 18,
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //     top: 10,
                                          //     left: 30,
                                          //   ),
                                          //   child: Row(
                                          //     children: <Widget>[
                                          //       Text(
                                          //         '• Have 4 people as my art team for you',
                                          //         style: TextStyle(
                                          //           fontSize: 18,
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            })
                        : list.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                    child: Text("Comment kosong",
                                        style: new TextStyle(fontSize: 30.0))),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, i) {
                                  final x = list[i];
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal *
                                            100,
                                        height:
                                            SizeConfig.safeBlockVertical * 55,
                                        child: Image.network(
                                          ImageUrl.imageContent + x.post_img,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 40,
                                        ),
                                        child: ClipOval(
                                          child: Material(
                                            color: Colors.black,
                                                // Color.fromRGBO(244, 217, 66, 1),
                                            child: InkWell(
                                              splashColor: Colors.purpleAccent,
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: IconButton(
                                                  color: Colors.white,
                                                  icon: Icon(
                                                    Icons.arrow_back,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 330,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          // height: 500,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                            ),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 30,
                                                  right: 30,
                                                  left: 20,
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    ListTile(
                                                      leading: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: x.user_img == null ?
                                                        placeholder : 
                                                        CircleAvatar(
                                                          child: ClipOval(
                                                            child: Image(
                                                              width: 50,
                                                              height: 50,
                                                              image: NetworkImage(
                                                                  ImageUrl.imageProfile +
                                                                      x.user_img),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            x.user_username,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            color: Colors.black,
                                                                // Color.fromRGBO(
                                                                //     244,
                                                                //     217,
                                                                //     66,
                                                                //     1),
                                                            icon: Icon(
                                                              Icons.message,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              var navigationResult =
                                                                  await Navigator
                                                                      .push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Chat(
                                                                              x),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 25,
                                                        left: 10,
                                                      ),
                                                      child: Container(
                                                        width: 450,
                                                        height: 2,
                                                        color: Color.fromRGBO(
                                                            244, 217, 66, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20,
                                                  left: 30,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.8,
                                                      child: Text(
                                                        x.post_title,
                                                        style: TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 30,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.8,
                                                      child: Text(
                                                        x.post_description,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 15,
                                                  right: 285,
                                                ),
                                                child: Container(
                                                  color: Color.fromRGBO(
                                                      244, 217, 66, 1),
                                                  width: 50,
                                                  height: 2,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 15,
                                                  left: 30,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Service',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 15,
                                                  left: 30,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.8,
                                                      child: Text(
                                                        x.post_offer,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     top: 10,
                                              //     left: 30,
                                              //   ),
                                              //   child: Row(
                                              //     children: <Widget>[
                                              //       Text(
                                              //         '• Currently available for projects, \n'
                                              //         'not contracts',
                                              //         style: TextStyle(
                                              //           fontSize: 18,
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     top: 10,
                                              //     left: 30,
                                              //   ),
                                              //   child: Row(
                                              //     children: <Widget>[
                                              //       Text(
                                              //         '• Have 4 people as my art team for you',
                                              //         style: TextStyle(
                                              //           fontSize: 18,
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 30,
                                                  bottom: 30,
                                                ),
                                                child: SizedBox(
                                                  width: 350,
                                                  height: 50,
                                                  child: RaisedButton(
                                                    splashColor:
                                                        Colors.purpleAccent,
                                                    elevation: 2,
                                                    padding: EdgeInsets.all(12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    color:
                                                    Color.fromRGBO(
                                                          250, 185, 32, 1),
                                                    //  Colors.black,
                                                    //  Color.fromRGBO(
                                                    //     244, 217, 66, 1),
                                                    child: Text(
                                                      'COLLABS',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      submit();
                                                      Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (context) =>
                                                              Chat(x),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
