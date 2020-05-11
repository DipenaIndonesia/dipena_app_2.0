import 'dart:convert';

import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String user_fullname, user_email, user_password, user_username;
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
      save();
    }
  }

  save() async {
    final response = await http.post(
        BaseUrl.register,
        body: {
          "user_fullname": user_fullname,
          "user_email": user_email,
          "user_username": user_username,
          "user_password": user_password,
        });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String messageEnglish = data['messageEnglish'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      print(message);
      // _showToast(message);
      // registerToast(message);
      
    } else if (value == 2) {
      print(message);
      _showToast(messageEnglish);
      // registerToast(message);
    } else {
      print(message);
      _showToast(messageEnglish);
      // registerToast(message);
    }
  }

  _showToast(String toast){
      final snackbar = SnackBar(
        content: new Text(toast),
        backgroundColor: Colors.red,
      );
      _scaffoldkey.currentState.showSnackBar(snackbar);
    }

  // registerToast(String toast) {
  //   return Fluttertoast.showToast(
  //       msg: toast,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white);
  // }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color.fromRGBO(244, 217, 66, 4),
      body: ListView(
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
                        left: 45,
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
                    child: Form(
                      key: _key,
                      child: Container(
                        width: double.infinity,
                        height: 545,
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
                                left: 130,
                                top: 20,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Sign Up Now!',
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
                                top: 30,
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    validator: (e) {
                                      if (e.isEmpty) {
                                        return "Please insert Full Name";
                                      }
                                    },
                                    onSaved: (e) => user_fullname = e,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    validator: (e) {
                                      if (e.isEmpty) {
                                        return "Please insert Username";
                                      }
                                    },
                                    onSaved: (e) => user_username = e,
                                    // keyboardType: TextInputType.emailAddress,
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
                                top: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    // validator: (e) {
                                    //   if (e.isEmpty) {
                                    //     return "Please insert Email ";
                                    //   }
                                    // },
                                    validator: validateEmail,
                                    onSaved: (e) => user_email = e,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
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
                                  'SIGN UP',
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
                                top: 8,
                              ),
                              width: 200,
                              child: FlatButton(
                                padding: EdgeInsets.all(1),
                                color: Colors.white,
                                child: Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                                onPressed: () async {
                                  var navigationResult = await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                  if (navigationResult == true) {
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
