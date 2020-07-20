import 'dart:convert';
import 'dart:io';

import 'package:dipena/inside_app/profile/profile_page.dart';
import 'package:dipena/model/location.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

// void main() => runApp(EditProfile());

class EditProfile extends StatefulWidget {
  final LocationModel model;
  final VoidCallback reload;
  EditProfile(this.model, this.reload);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();

  String user_username,
      user_fullname,
      user_bio,
      user_email,
      user_id,
      location_country,
      location_city,
      location_user_id,
      user_img,
      user_img_user,
      value;
  File _imageFile;

  TextEditingController txtFullname = TextEditingController();
  TextEditingController txtBio = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
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
      user_fullname = preferences.getString("user_fullname");
      user_email = preferences.getString("user_email");
      user_bio = preferences.getString("user_bio");
      user_img = preferences.getString("user_img");
      user_img_user = preferences.getString("user_img");
      txtFullname = TextEditingController(text: user_fullname);
      txtBio = TextEditingController(text: user_bio);
      txtEmail = TextEditingController(text: user_email);
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
    if (_imageFile == null && user_img == null) {
      showDialog(
        barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) =>
                      _loading(context),
                );
      try {
        // var stream =
        //     http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
        // var length = await _imageFile.length();
        var uri = Uri.parse("https://dipena.com/flutter/api/updateProfileImageNull2_0.php");
        final request = http.MultipartRequest("POST", uri);
        request.fields['user_username'] = user_username;
        request.fields['user_fullname'] = user_fullname;
        request.fields['user_email'] = user_email;
        request.fields['user_bio'] = user_bio;
        request.fields['user_id'] = user_id;
        request.fields['location_country'] = location_country;
        request.fields['location_city'] = location_city;
        request.fields['location_user_id'] = user_id;
        // request.fields['user_img'] = user_img_user;

        // request.files.add(http.MultipartFile("user_img", stream, length,
        //     filename: path.basename(_imageFile.path)));
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        if (response.statusCode > 2) {
          final data = jsonDecode(respStr);
          // final data = jsonDecode(uri.toString());
          String bio = data['bio'];
          // String location_country = data['location_country'];
          // print(bio);
          String user_imgApi = data['user_img'];
          String message = data['message'];
          String user_fullnameApi = data['user_fullname'];
          String user_emailApi = data['user_email'];
          savePref(bio, user_imgApi, user_fullname, user_email);
          print(user_bio);
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
          _showToast(message);
        } else {
          print("Image failed to be upload");
        }
      } catch (e) {
        debugPrint("Error $e");
      }
    } else if (user_img != null && _imageFile == null) {
      showDialog(
        barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) =>
                      _loading(context),
                );
      try {
        // await getPref();
        // var stream =
        //     http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
        // var length = await _imageFile.length();
        var uri = Uri.parse("https://dipena.com/flutter/api/updateProfileOnly2_0.php");
        final request = http.MultipartRequest("POST", uri);
        request.fields['user_username'] = user_username;
        request.fields['user_fullname'] = user_fullname;
        request.fields['user_email'] = user_email;
        request.fields['user_bio'] = user_bio;
        request.fields['user_id'] = user_id;
        request.fields['location_country'] = location_country;
        request.fields['location_city'] = location_city;
        request.fields['location_user_id'] = user_id;
        request.fields['user_img'] = user_img;

        // request.files.add(http.MultipartFile("user_img", stream, length,
        //     filename: path.basename(_imageFile.path)));
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        if (response.statusCode > 2) {
          final data = jsonDecode(respStr);
          // final data = jsonDecode(uri.toString());
          String bio = data['bio'];
          // String location_country = data['location_country'];
          // print(bio);
          String user_imgApi = data['user_img'];
          String message = data['message'];
          String user_fullnameApi = data['user_fullname'];
          String user_emailApi = data['user_email'];
          // savePref(bio, user_imgApi);
          savePref(bio, user_imgApi, user_fullname, user_email);
          print(user_bio);
          setState(() {
            widget.reload();
            Navigator.pop(context);
            _showToast(message);
          });
        } else {
          print("Image failed to be upload");
        }
      } catch (e) {
        debugPrint("Error $e");
      }
    } else {
      showDialog(
        barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) =>
                      _loading(context),
                );
      try {
        var stream =
            http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
        var length = await _imageFile.length();
        var uri = Uri.parse("https://dipena.com/flutter/api/updateProfile2_0.php");
        final request = http.MultipartRequest("POST", uri);
        request.fields['user_username'] = user_username;
        request.fields['user_fullname'] = user_fullname;
        request.fields['user_email'] = user_email;
        request.fields['user_bio'] = user_bio;
        request.fields['user_id'] = user_id;
        request.fields['location_country'] = location_country;
        request.fields['location_city'] = location_city;
        request.fields['location_user_id'] = user_id;

        request.files.add(http.MultipartFile("user_img", stream, length,
            filename: path.basename(_imageFile.path)));
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        if (response.statusCode > 2) {
          final data = jsonDecode(respStr);
          // final data = jsonDecode(uri.toString());
          String bio = data['bio'];
          // String location_country = data['location_country'];
          // print(bio);
          String user_imgApi = data['user_img'];
          String message = data['message'];
          String user_fullnameApi = data['user_fullname'];
          String user_emailApi = data['user_email'];
          // savePref(bio, user_imgApi);
          savePref(bio, user_imgApi, user_fullname, user_email);
          print("Image uploaded");
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
          _showToast(message);
        } else {
          print("Image failed to be upload");
        }
      } catch (e) {
        debugPrint("Error $e");
      }
      //
    }
  }

  savePref(String user_bio, String user_img, String user_fullname,
      String user_email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      // preferences.setInt("value", value);
      preferences.setString("user_bio", user_bio);
      preferences.setString("user_img", user_img);
      preferences.setString("user_fullname", user_fullname);
      preferences.setString("user_email", user_email);
      preferences.commit();
    });
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.green,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    setup();
    print(user_fullname);
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

  show_cat() {
    // if (user_img != null) {
    //   return CircleAvatar(
    //     radius: 60,
    //     backgroundImage: NetworkImage(
    //         "https://dipena.com/flutter/image_profile/" + user_img),
    //   );
    // }
    if (_imageFile != null) {
      return CircleAvatar(
        radius: 60,
        // backgroundImage: NetworkImage("https://dipena.com/flutter/image_profile/"+user_img),
        backgroundImage: new FileImage(_imageFile),
      );
    } else if (user_img != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(
            "https://dipena.com/flutter/image_profile/" + user_img),
      );
    } else if (_imageFile == null) {
      return placeholder;
      // backgroundImage: new FileImage(_imageFile),;
    }
  }

  var placeholder = CircleAvatar(
      radius: 60, backgroundImage: AssetImage('assets/img/user_search.png'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontFamily: "Poppins Regular"),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 15),
            // child: Form(
            // key: _key,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: show_cat()
                    // CircleAvatar(
                    //   radius: 60,
                    //   backgroundImage: AssetImage(
                    //     'assets/img/icon_two.png',
                    //   ),
                    // ),
                    ),
                FlatButton(
                  child: Text(
                    'Change Profile Image',
                    style: TextStyle(
                        color: Colors.blue[400],
                        fontSize: 16,
                        letterSpacing: 1,
                        fontFamily: "Poppins Regular"),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _popUpImage(context),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: txtFullname,
                    onSaved: (e) => user_fullname = e,
                    style:
                        TextStyle(fontSize: 18, fontFamily: "Poppins Regular"),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelStyle: TextStyle(
                          color: Colors.black, fontFamily: "Poppins Regular"
                          // fontWeight: FontWeight.bold,
                          ),
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
                    controller: txtLocationCity,
                    onSaved: (e) => location_city = e,
                    style:
                        TextStyle(fontSize: 18, fontFamily: "Poppins Regular"),
                    decoration: InputDecoration(
                      labelText: 'Location City',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelStyle: TextStyle(
                          color: Colors.black, fontFamily: "Poppins Regular"
                          // fontWeight: ? FontWeight.bold : FontWeight.normal,
                          ),
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
                    controller: txtLocationCountry,
                    onSaved: (e) => location_country = e,
                    style:
                        TextStyle(fontSize: 18, fontFamily: "Poppins Regular"),
                    decoration: InputDecoration(
                      labelText: 'Location Country',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelStyle: TextStyle(
                          color: Colors.black, fontFamily: "Poppins Regular"
                          // fontWeight: ? FontWeight.bold : FontWeight.normal,
                          ),
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
                    onSaved: (e) => user_email = e,
                    controller: txtEmail,
                    style:
                        TextStyle(fontSize: 18, fontFamily: "Poppins Regular"),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelStyle: TextStyle(
                          color: Colors.black, fontFamily: "Poppins Regular"
                          // fontWeight: FontWeight.bold,
                          ),
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
                    maxLength: 100,
                    onSaved: (e) => user_bio = e,
                    controller: txtBio,
                    style:
                        TextStyle(fontSize: 18, fontFamily: "Poppins Regular"),
                    decoration: InputDecoration(
                      labelText: 'About',
                      labelStyle: TextStyle(
                          color: Colors.black, fontFamily: "Poppins Regular"
                          // fontWeight: FontWeight.bold,
                          ),
                      // suffixText: '0/100',

                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15.0, top: 35, left: 15, right: 15),
                  child: Center(
                    // widthFactor: 400.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("Save Changes",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: "Poppins Regular")),
                        color: new Color(0xFFF39C12),
                        splashColor: Colors.black,
                        onPressed: () async {
                          // var navigationResult = await Navigator.push(
                          //   context,
                          //   new MaterialPageRoute(
                          //     builder: (context) => Profile(),
                          //   ),
                          // );
                          // if (navigationResult == true) {
                          //   MaterialPageRoute(
                          //     builder: (context) => Profile(),
                          //   );
                          // }
                          print(user_img);
                          print(_imageFile);
                          print(user_bio);
                          print(user_fullname);
                          print(user_email);
                          check();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
