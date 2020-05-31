import 'package:dipena/auth/sign_up.dart';
import 'package:dipena/inside_app/navbar.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
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

  login() async {
    final response = await http.post(BaseUrl.login, body: {
      "user_username": user_username,
      "user_password": user_password,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String messageEnglish = data['messageEnglish'];
    String changeProf = data['changeProf'];
    String user_usernameAPI = data['user_username'];
    String user_bioAPI = data['user_bio'];
    String user_emailAPI = data['user_email'];
    String user_id = data['user_id'];
    String user_img = data['user_img'];

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, user_id, user_username, user_emailAPI, user_bioAPI,
            user_img);
      });
      print(message);
      // _showToast(message);
    } else {
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

  //  void _showToast(BuildContext context) {
  //   final scaffold = Scaffold.of(context);
  //   scaffold.showSnackBar(
  //     SnackBar(
  //       content: const Text('Added to favorite'),
  //       action: SnackBarAction(
  //           label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  //     ),
  //   );
  // }

  // loginToast(String toast) {
  //   return Fluttertoast.showToast(
  //       msg: toast,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white);
  // }

  savePref(int value, String user_id, String user_username, String user_email,
      String user_bio, String user_img) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
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
          backgroundColor: Color.fromRGBO(244, 217, 66, 4),
          body: Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 50,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 90,
                            child: Image.asset(
                              'assets/images/Logo_Size.png',
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 170,
                              // left: 45,
                            ),
                            child: Text(
                              // 'Bergabung bersama yang lainnya!',
                              'Join with others!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 230,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 508,
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
                                  padding: const EdgeInsets.only(
                                    left: 140,
                                    top: 20,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Log In Now!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Times New Roman',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 40,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please Insert Username";
                                          }
                                        },
                                        onSaved: (e) => user_username = e,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 30,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Password Can't be Empty";
                                          }
                                        },
                                        obscureText: _secureText,
                                        onSaved: (e) => user_password = e,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            onPressed: showHide,
                                            icon: Icon(_secureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 50,
                                  ),
                                  width: 250,
                                  child: RaisedButton(
                                    elevation: 5,
                                    splashColor: Colors.purpleAccent,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    color: Color.fromRGBO(244, 217, 66, 1),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      check();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 12,
                                  ),
                                  width: 200,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(1),
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Doesn\'t have an account?',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            "Sign Up/Register Here!",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    onPressed: () async {
                                      var navigationResult =
                                          await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => SignUp(),
                                        ),
                                      );
                                      if (navigationResult == true) {
                                        MaterialPageRoute(
                                          builder: (context) => SignUp(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return HomePage(signOut);
//        return ProfilePage(signOut);
        break;
    }
  }
}
