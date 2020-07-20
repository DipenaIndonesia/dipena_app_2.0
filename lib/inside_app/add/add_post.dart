import 'dart:convert';
import 'dart:io';

import 'package:dipena/auth/login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class Cat {
  const Cat(this.name);

  final String name;
}

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _key = new GlobalKey<FormState>();
  String user_id,
      post_user_id,
      post_cat_id,
      post_sub_cat_id,
      post_title,
      post_offer,
      post_description,
      post_location;
  File _imageFile;
  // Cat selectedCat;
  // List<Cat> users = <Cat>[
  //   const Cat("Painter"),
  //   const Cat("Designer"),
  //   const Cat("Photography"),
  //   const Cat("Other"),
  // ];

  FocusNode myFocusNode = new FocusNode();

  String _mySelection;

  final String url = "http://dipena.com/flutter/api/post/selectCat.php";

  List data = List();

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      post_user_id = preferences.getString("user_id");
      user_id = preferences.getString("user_id");
    });
  }

  Widget _loading(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
          title: Text("Please Wait..."),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                // height: 50,
                // width: 50,
                child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }

  // bool loading;
  submit() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => _loading(context),
    );
    // setState(() {
    //   loading = true;
    // });
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse("https://dipena.com/flutter/api/post/addPost.php");
      final request = http.MultipartRequest("POST", uri);
      request.fields['post_user_id'] = user_id;
      request.fields['user_id'] = user_id;
      // request.fields['post_title'] = post_title;
      // request.fields['post_location'] = post_location;
      request.fields['post_offer'] = post_offer;
      request.fields['post_description'] = post_description;
      request.fields['post_cat_id'] = _mySelection;

      request.files.add(http.MultipartFile("post_img", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Image uploaded");
        setState(() {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => LoginPage()));
          // loading = false;
          // widget.response();
          // Navigator.pop(context);
          // Navigator.popUntil(context, => HomePage());
          // Navigator.of(context).popUntil((route) => route.isFirst);
        });
      } else {
        print("Image failed to be upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }

    // await getPref();
    // final response = await http
    //     .post("http://dipena.com/flutter/api/post/addPost.php", body: {
    //   "post_user_id": user_id,
    //   "user_id": user_id,
    //   // "post_cat_id" : post_cat_id,
    //   "post_title": post_title,
    //   "post_location": post_location,
    //   "post_offer": post_offer,
    //   "post_description": post_description,
    // });
    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String pesan = data['message'];
    // if (value == 1) {
    //   print(pesan);
    //   setState(() {
    //     Navigator.pop(context);
    //   });
    // } else {
    //   print(pesan);
    // }
  }

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

  String hintText;
  serviceHint() {
    if (_mySelection == "1") {
      return "Painter";
    } else if (_mySelection == "2") {
      return "Designer";
    } else if (_mySelection == "3") {
      return "Photographer";
    } else {
      return "Others";
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getSWData();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: MediaQuery.of(context).size.width / 3.8,
      height: MediaQuery.of(context).size.height / 7,
      color: Colors.white,
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/img/add.png",
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "Add",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins Medium",
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.05,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    // barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _popUpImage(context),
                                  );
                                },
                                child: _imageFile == null
                                    ? placeholder
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.8,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                7,
                                        color: Colors.grey,
                                        // foregroundDecoration: BoxDecoration(
                                        //   image: DecorationImage(
                                        //     image: AssetImage(
                                        //       "assets/img/post_two.jpg",
                                        //     ),
                                        //     fit: BoxFit.fill,
                                        //   ),
                                        // ),
                                        child: Image.file(_imageFile)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Please select a category.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "Poppins Medium",
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 180,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonHideUnderline(
                                          // child: DropdownButton<Cat>(
                                          //   hint: new Text("Category"),
                                          //   value: selectedCat,
                                          //   onChanged: (Cat newValue) {
                                          //     setState(() {
                                          //       selectedCat = newValue;
                                          //     });
                                          //   },
                                          //   items: users.map(
                                          //     (Cat cat) {
                                          //       return new DropdownMenuItem<Cat>(
                                          //         value: cat,
                                          //         child: new Text(
                                          //           cat.name,
                                          //           style: new TextStyle(
                                          //             color: Colors.black,
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //   ).toList(),
                                          // ),
                                          child: DropdownButton(
                                            hint: new Text("Category"),
                                            value: _mySelection,
                                            onChanged: (newVal) {
                                              setState(() {
                                                _mySelection = newVal;
                                              });
                                            },
                                            items: data.map((item) {
                                              return new DropdownMenuItem(
                                                child: new Text(
                                                    item['category_name']),
                                                value: item['category_id']
                                                    .toString(),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please Insert Descriptions";
                              }
                            },
                            onSaved: (e) => post_description = e,
                            focusNode: myFocusNode,
                            decoration: InputDecoration(
                              labelText: "Descriptions",
                              hintText: "Write something ...",
                              labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Colors.black
                                    : Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Medium",
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          // Text(
                          //   "Services",
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 15,
                          //     fontFamily: "Poppins Medium",
                          //   ),
                          // ),
                          // FlatButton(
                          //   child: Text(
                          //     "+ add another services",
                          //     style: TextStyle(
                          //       color: Color(0xFFF39C12),
                          //       fontSize: 13,
                          //       fontFamily: "Poppins Medium",
                          //     ),
                          //   ),
                          //   onPressed: () {},
                          // ),
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please Insert Services";
                              }
                            },
                            onSaved: (e) => post_offer = e,
                            // focusNode: myFocusNode,
                            decoration: InputDecoration(
                              labelText: "Services",
                              hintText: serviceHint(),
                              // hintText: "Write something ...",
                              labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Colors.black
                                    : Colors.black,
                                fontSize: 15,
                                fontFamily: "Poppins Medium",
                              ),
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
                                "POST",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins Medium",
                                ),
                              ),
                              onPressed: () {
                                check();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
