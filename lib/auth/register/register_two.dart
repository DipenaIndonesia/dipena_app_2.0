import 'dart:convert';

import 'package:dipena/auth/register/register_one.dart';
import 'package:dipena/auth/register/register_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterTwo extends StatefulWidget {
  final String user_fullname, user_email;
  RegisterTwo(this.user_fullname, this.user_email);
  @override
  _RegisterTwoState createState() => _RegisterTwoState();
}

class _RegisterTwoState extends State<RegisterTwo> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  String user_fullname, user_email, user_username;
  // regis_1(){
  //   setState(() {
  //     user_fullname = widget.user_username;
  //     user_email = widget.user_email;
  //   });
  // }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_fullname = widget.user_fullname;
    user_email = widget.user_email;
    print(user_fullname);
    // print(user_fullname);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
      // Navigator.push(
      //   context,
      //   new MaterialPageRoute(
      //     builder: (context) =>
      //         RegisterThree(user_fullname, user_email, user_username),
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
        "https://dipena.com/flutter/api/auth/checkRegisterUsername.php",
        body: {
          // "user_fullname": user_fullname,
          // "user_email": user_email,
          "user_username": user_username,
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
      //   builder: (BuildContext context) => _popUpGallery(context),
      // );
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) =>
              RegisterThree(user_fullname, user_email, user_username),
        ),
      );
      // print(message);
      // _showToast(message);
      // registerToast(message);

    } else {
      // print(message);
      Navigator.pop(context);
      _showToast(messageEnglish);
      // registerToast(message);
    }
  }

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.red,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
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
                        // var navigationResult = await Navigator.push(
                        //   context,
                        //   new MaterialPageRoute(
                        //     builder: (context) => RegisterOne(),
                        //   ),
                        // );
                        // if (navigationResult == true) {
                        //   MaterialPageRoute(
                        //     builder: (context) => RegisterOne(),
                        //   );
                        // }
                        Navigator.pop(context);
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
                          "Add a username.",
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
                                  return "Please insert Username";
                                }
                              },
                              onSaved: (e) => user_username = e,
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
                                hintText: "Username",
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
                                  //     builder: (context) => RegisterThree(),
                                  //   ),
                                  // );
                                  // if (navigationResult == true) {
                                  //   MaterialPageRoute(
                                  //     builder: (context) => RegisterThree(),
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
