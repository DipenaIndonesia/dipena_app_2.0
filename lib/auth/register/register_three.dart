import 'dart:convert';

import 'package:dipena/auth/login/login_page.dart';
import 'package:dipena/auth/register/register_two.dart';
import 'package:dipena/onboarding/onboarding_page.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterThree extends StatefulWidget {
  final String user_fullname, user_email, user_username;
  RegisterThree(this.user_fullname, this.user_email, this.user_username);
  @override
  _RegisterThreeState createState() => _RegisterThreeState();
}

class _RegisterThreeState extends State<RegisterThree> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  String user_fullname, user_email, user_username, user_password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_fullname = widget.user_fullname;
    user_email = widget.user_email;
    user_username = widget.user_username;
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
      //     builder: (context) => RegisterTwo(user_fullname, user_email),
      //   ),
      // );
    }
  }

  save() async {
    final response = await http.post(BaseUrl.register, body: {
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
      // setState(() {
      //   Navigator.pop(context);
      // });
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => _popUpGallery(context),
      // );
      // Navigator.push(
      //   context,
      //   new MaterialPageRoute(
      //     builder: (context) => OnboardingPage(),
      //   ),
      // );
      login();
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

  login() async {
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
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, user_id, user_fullnameAPI, user_username, user_emailAPI, user_bioAPI,
            user_img);
      });
      print(message);
       Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => OnboardingPage(),
        ),
      );
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

  // _showToast(String toast) {
  //   final snackbar = SnackBar(
  //     content: new Text(toast),
  //     backgroundColor: Colors.red,
  //   );
  //   _scaffoldkey.currentState.showSnackBar(snackbar);
  // }

  bool _secureText = true;
  bool _secureTextConfirm = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showHideConfirm() {
    setState(() {
      _secureTextConfirm = !_secureTextConfirm;
    });
  }

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _key,
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
                        Navigator.pop(context);
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
                          "You'll need a password.",
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
                              controller: _pass,
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Password cannot be empty';
                                return null;
                              },
                              obscureText: _secureText,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  color: Color(0xFFF39C12),
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
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
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Color(0xFFBDC3C7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              onSaved: (e) => user_password = e,
                              controller: _confirmPass,
                              validator: (val) {
                                if (val.isEmpty) return 'Empty';
                                if (val != _pass.text)
                                  return 'Password Not Match';
                                return null;
                              },
                              obscureText: _secureTextConfirm,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  color: Color(0xFFF39C12),
                                  onPressed: showHideConfirm,
                                  icon: Icon(_secureTextConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
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
                                hintText: "Confirm Password",
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
                                  "Register",
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
                                  //     builder: (context) => OnboardingPage(),
                                  //   ),
                                  // );
                                  // if (navigationResult == true) {
                                  //   MaterialPageRoute(
                                  //     builder: (context) => OnboardingPage(),
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
