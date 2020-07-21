import 'dart:convert';

import 'package:dipena/auth/register/register_one.dart';
import 'package:dipena/navbar.dart';
import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String user_username, user_password;
  final _key = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
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

  login() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => _loading(context),
    );
    final response = await http.post(BaseUrl.login, body: {
      "user_username": user_username,
      "user_password": user_password,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String messageEnglish = data['messageEnglish'];
    // String changeProf = data['changeProf'];
    String user_fullnameAPI = data['user_fullname'];
    String user_usernameAPI = data['user_username'];
    String user_bioAPI = data['user_bio'];
    String user_emailAPI = data['user_email'];
    String user_id = data['user_id'];
    String user_img = data['user_img'];

    if (value == 1) {
      Navigator.pop(context);
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, user_id, user_fullnameAPI, user_username, user_emailAPI, user_bioAPI,
            user_img);
      });
      print(message);
      // _showToast(message);
    } else {
      Navigator.pop(context);
      print("fail");
      print(message);
      _showToast(messageEnglish);
    }
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.red,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  savePref(int value, String user_id, String user_fullname, String user_username, String user_email,
      String user_bio, String user_img) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("user_fullname", user_fullname);
      preferences.setString("user_username", user_username);
      preferences.setString("user_email", user_email);
      preferences.setString("user_id", user_id);
      preferences.setString("user_bio", user_bio);
      preferences.setString("user_img", user_img);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          key: _scaffoldkey,
          backgroundColor: Colors.white,
          body: Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/img/dipena_logo.png",
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Welcome to Dipena",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Poppins Medium",
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Whoever you are, make your                                 \nmom proud.",
                                style: TextStyle(
                                  color: Color(0xFFBDC3C7),
                                  fontSize: 14,
                                  fontFamily: "Poppins Regular",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset("assets/img/wave.png"),
                        SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please Insert Username";
                                  }
                                },
                                onSaved: (e) => user_username = e,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(13),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                  ),
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFBDC3C7),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xFFBDC3C7),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Password Can't be Empty";
                                  }
                                },
                                obscureText: _secureText,
                                onSaved: (e) => user_password = e,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    color: Color(0xFFF39C12),
                                            onPressed: showHide,
                                            icon: Icon(_secureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                  contentPadding: const EdgeInsets.all(13),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFBDC3C7),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xFFBDC3C7),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
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
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "Poppins Medium",
                                    ),
                                  ),
                                  onPressed: () async {
                                    check();
                                    // var navigationResult = await Navigator.push(
                                    //   context,
                                    //   new MaterialPageRoute(
                                    //     builder: (context) => NavBar(),
                                    //   ),
                                    // );
                                    // if (navigationResult == true) {
                                    //   MaterialPageRoute(
                                    //     builder: (context) => NavBar(),
                                    //   );
                                    // }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 13,
                        fontFamily: "Poppins Medium",
                      ),
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 13,
                        fontFamily: "Poppins Medium",
                      ),
                    ),
                    onPressed: () async {
                      var navigationResult = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => RegisterOne(),
                        ),
                      );
                      if (navigationResult == true) {
                        MaterialPageRoute(
                          builder: (context) => RegisterOne(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return NavBar(signOut);
        break;
    }
  }
}
