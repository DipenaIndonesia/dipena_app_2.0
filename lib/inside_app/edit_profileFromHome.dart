import 'dart:convert';
import 'dart:io';

import 'package:dipena/inside_app/navbar.dart';
import 'package:dipena/inside_app/profile.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class EditFromHome extends StatefulWidget {
  // final VoidCallback signOutProfile;
  final LocationModel model;
  EditFromHome(this.model);
  @override
  _EditFromHomeState createState() => _EditFromHomeState();
}

class _EditFromHomeState extends State<EditFromHome> {
  // signOutProfile() {
  //   setState(() {
  //     widget.signOutProfile();
  //   });
  // }

  final _key = new GlobalKey<FormState>();

  String user_username,
      user_bio,
      user_id,
      location_country,
      location_city,
      location_user_id,
      user_img,
      value;
  File _imageFile;

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtBio = TextEditingController();
  TextEditingController txtLocationCountry;
  TextEditingController txtLocationCity;

  setup() {
    txtLocationCountry =
        TextEditingController(text: widget.model.location_country);
    txtLocationCity = TextEditingController(text: widget.model.location_city);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      location_user_id = preferences.getString("user_id");
      user_username = preferences.getString("user_username");
      user_bio = preferences.getString("user_bio");
      user_img = preferences.getString("user_img");
      txtUsername = TextEditingController(text: user_username);
      txtBio = TextEditingController(text: user_bio);
    });
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

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(EditProfileUrl.updateProfile);
      final request = http.MultipartRequest("POST", uri);
      request.fields['user_username'] = user_username;
      request.fields['user_bio'] = user_bio;
      request.fields['user_id'] = user_id;
      request.fields['location_country'] = location_country;
      request.fields['location_city'] = location_city;
      request.fields['location_user_id'] = user_id;

      request.files.add(http.MultipartFile("user_img", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Image uploaded");
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print("Image failed to be upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
    // await getPref();
    // final response = await http
    //     .post("https://dipena.com/flutter/api/updateProfile.php", body: {
    // final response = await http
    //     .post("https://dipena.com/flutter/api/updateProfile.php", body: {
    //   "user_username": user_username,
    //   "user_bio": user_bio,
    //   "user_id": user_id,
    //   "location_country": location_country,
    //   "location_city": location_city,
    //   "location_user_id": user_id
    // });

    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String message = data['message'];
    // String changeProf = data['changeProf'];

    // if (value != 0) {
    //   String user_usernameAPI = data['user_username'];
    //   String user_bioAPI = data['user_bio'];
    //   print(message);
    //   loginToast(message);
    //   alertToast(changeProf);
    //   // SharedPreferences preferences = await SharedPreferences.getInstance();
    //   setState(() {
    //     // getPrefs();
    //     //  savePref(value, user_id, user_username, user_bioAPI);
    //     // widget.reload();
    //     // preferences.setInt("value", value);
    //     //   preferences.setString("user_username", user_username);
    //     //   preferences.setString("user_id", user_id);
    //     //   preferences.setString("user_bio", user_bio);
    //     //   preferences.commit();
    //     Navigator.pop(context);
    //     //  getPrefs();
    //   });
    //   // return true;
    // } else {
    //   print(message);
    //   loginToast(message);
    // }
  }

  // loginToast(String toast) {
  //   return Fluttertoast.showToast(
  //       msg: toast,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 3,
  //       backgroundColor: Colors.yellow,
  //       textColor: Colors.white);
  // }

  // alertToast(String toast) {
  //   return Fluttertoast.showToast(
  //       msg: toast,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 5,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white);
  // }

  // savePref(int value, String user_id, String user_username, String user_bio) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     preferences.setInt("value", value);
  //     preferences.setString("user_username", user_username);
  //     preferences.setString("user_id", user_id);
  //     preferences.setString("user_bio", user_bio);
  //     preferences.commit();
  //   });
  // }

  getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("user_username", user_username);
      preferences.setString("user_bio", user_bio);
      preferences.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    // getPrefs();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    // var placeholder = Container(
    //   width: double.infinity,
    //   height: 150.0,
    //   child: Image.asset('./img/placeholder.png'),
    // );
    var placeholder = CircleAvatar(
        radius: 60, backgroundImage: AssetImage('./img/placeholder.png'));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Color.fromRGBO(244, 217, 66, 1),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(244, 217, 66, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                      child: InkWell(
                    onTap: () {
                      _pilihCamera();
                    },
                    // child: _imageFile == null
                    //     ? placeholder
                    //     : CircleAvatar(
                    //         radius: 60,
                    //         backgroundImage: new FileImage(_imageFile),
                    //         // child: Image.file(
                    //         //   _imageFile,
                    //         //   fit: BoxFit.fill,
                    //         // ),
                    //       ),
                    //   child: _imageFile == null
                    // ? placeholder
                    // : CircleAvatar(
                    //     radius: 60,
                    //     backgroundImage: new FileImage(_imageFile),
                    //     // child: Image.file(
                    //     //   _imageFile,
                    //     //   fit: BoxFit.fill,
                    //     // ),
                    //   ),
                    child: _imageFile == null
                        ? placeholder
                        : CircleAvatar(
                            radius: 60,
                            // backgroundImage: NetworkImage("https://dipena.com/flutter/image_profile/"+user_img),
                            backgroundImage: new FileImage(_imageFile),
                            // child: Image.file(
                            //   _imageFile,
                            //   fit: BoxFit.fill,
                            // ),
                          ),
                  )
                      //                 Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 20,
                      //   ),
                      //   child: CircleAvatar(
                      //     radius: 60,
                      //     backgroundImage: AssetImage(
                      //       'assets/images/Account_Profile.png',
                      //     ),
                      //   ),
                      // ),
                      ),
                ),
                Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        _pilihGallery();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        _pilihCamera();
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 10,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    onSaved: (e) => user_username = e,
                    controller: txtUsername,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 15,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    controller: txtLocationCountry,
                    onSaved: (e) => location_country = e,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      labelText: 'Location Country',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 15,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    controller: txtLocationCity,
                    onSaved: (e) => location_city = e,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      labelText: 'Location City',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 15,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    onSaved: (e) => user_bio = e,
                    controller: txtBio,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.list,
                        size: 30,
                      ),
                      labelText: 'Bio',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 45,
                  ),
                  child: RaisedButton(
                      elevation: 3,
                      splashColor: Colors.purpleAccent,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Color.fromRGBO(244, 217, 66, 1),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        check();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
