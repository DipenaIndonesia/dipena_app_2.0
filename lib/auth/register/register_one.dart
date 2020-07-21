import 'dart:convert';

import 'package:dipena/auth/login/login_page.dart';
import 'package:dipena/auth/register/register_two.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterOne extends StatefulWidget {
  @override
  _RegisterOneState createState() => _RegisterOneState();
}

class _RegisterOneState extends State<RegisterOne> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String user_fullname, user_email;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
      // Navigator.push(
      //   context,
      //   new MaterialPageRoute(
      //     builder: (context) => RegisterTwo(user_fullname, user_email),
      //   ),
      // );
    }
  }

  save() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => _loading(context),
      );
    final response = await http.post(
        "https://dipena.com/flutter/api/auth/checkRegisterEmail.php",
        body: {
          // "user_fullname": user_fullname,
          "user_email": user_email,
          // "user_username": user_username,
          // "user_password": user_password,
        });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String messageEnglish = data['messageEnglish'];
    if (value == 1) {
      // setState(() {
      //   Navigator.pop(context);
      // });
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => _loading(context),
      // );
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => RegisterTwo(user_fullname, user_email),
        ),
      );
      print(message);
      
      // _showToast(message);
      // registerToast(message);

    } else {
      Navigator.pop(context);
      print(message);
      _showToast(messageEnglish);
      // registerToast(message);
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

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.red,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  // TextEditingController userFullnameTxt = TextEditingController();
  // TextEditingController userEmailTxt = TextEditingController();

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
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Poppins Regular",
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        var navigationResult = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                        if (navigationResult == true) {
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Image(
                            image: AssetImage(
                              "assets/img/dipena_logo.png",
                            ),
                            height: 115,
                            width: 115,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Create your account.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please insert Full Name";
                                }
                              },
                              onSaved: (e) => user_fullname = e,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16),
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
                                hintText: "Full Name",
                                hintStyle: TextStyle(
                                  color: Color(0xFFBDC3C7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              validator: validateEmail,
                              onSaved: (e) => user_email = e,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16),
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
                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                  color: Color(0xFFBDC3C7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(),
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
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Poppins Medium",
                                  ),
                                ),
                                onPressed: () async {
                                  check();
                                  // var navigationResult = await Navigator.push(
                                  //   context,
                                  //   new MaterialPageRoute(
                                  //     builder: (context) => RegisterTwo(),
                                  //   ),
                                  // );
                                  // if (navigationResult == true) {
                                  //   MaterialPageRoute(
                                  //     builder: (context) => RegisterTwo(),
                                  //   );
                                  // }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
