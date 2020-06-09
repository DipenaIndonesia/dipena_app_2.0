import 'dart:convert';

import 'package:dipena/model/post.dart';
import 'package:dipena/model/seeDeals.dart';
import 'package:dipena/url.dart';
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

class Deal extends StatefulWidget {
  final PostContent model;
  Deal(this.model);
  @override
  _DealState createState() => _DealState();
}

class _DealState extends State<Deal> {
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
      "post_user_id": widget.model.post_user_id,
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

  @override
  void initState() {
    // TODO: implement initState
    _seeDeals();
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var placeholder = CircleAvatar(
        radius: 40, backgroundImage: AssetImage('./img/placeholder.png'));
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
                                      'https://dipena.com/flutter/image_content/' +
                                          x.post_img,
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
                                                    child: x.user_img == null
                                                        ? placeholder
                                                        : CircleAvatar(
                                                            child: ClipOval(
                                                              child: Image(
                                                                width: 50,
                                                                height: 50,
                                                                image: NetworkImage(
                                                                    ImageUrl.imageProfile +
                                                                        x.user_img),
                                                                fit: BoxFit
                                                                    .cover,
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
                                                          child: x.user_img ==
                                                                  null
                                                              ? placeholder
                                                              : CircleAvatar(
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Image(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      image: NetworkImage(
                                                                          ImageUrl.imageProfile +
                                                                              x.user_img),
                                                                    ),
                                                                  ),
                                                                )),
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
                                                  bottom: 30
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
                                                    // Colors.black, 
                                                    // Color.fromRGBO(
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
                                                            builder:
                                                                (context) =>
                                                                    Chat(x)),
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
