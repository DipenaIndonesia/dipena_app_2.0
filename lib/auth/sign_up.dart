import 'dart:convert';

import 'package:dipena/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';
import 'package:flutter/gestures.dart';

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
      showDialog(
        context: context,
        builder: (BuildContext context) => _popUpGallery(context),
      );
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

  _showToast(String toast) {
    final snackbar = SnackBar(
      content: new Text(toast),
      backgroundColor: Colors.red,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Widget _popUpGallery(BuildContext context) {
    return new Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: CupertinoAlertDialog(
            content: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "WELCOME TO DIPENA!",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                user_username,
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ),
            Text(
                "Ready to Share what you could or Take what you should and change the world ?"),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(50)),
                child: Align(
                    alignment: Alignment.bottomCenter, child: Text("Ready")),
              ),
            ) // Container()
          ],
        )),
      ),
    );
  }

  Widget _dataPolicy(BuildContext context) {
    return new Transform.scale(
        scale: 1,
        child: Opacity(
            opacity: 1,
            child: CupertinoAlertDialog(
              content:
                  SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        color: Color.fromRGBO(244, 217, 66, 4),
                        height: MediaQuery.of(context).size.height / 5,
                        child: Center(
                            child: Image.asset(
                                "assets/images/dipena_logo_square2.png"))),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Center(
                          child: Text("Data Policy",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 25.0, right: 25.0),
                        child: Text(
                            "We collect the content, communications and other information you provide when you use dipena, including when you sign up for an account, create or share content, and message or communicate with others. We collect such data as name, email address, country, city, IP address, mobile device ID, and any content and communications through dipena. ",
                            textAlign: TextAlign.justify,
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.black)),
                      ),
                    ),
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 25.0, right: 25.0),
                          child: RichText(
                            text: TextSpan(
                                text:
                                    'Please feel free to have any inquiries regarding on terms of use or data policy on ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'halo@dipena.com',
                                      style: TextStyle(color: Colors.blue)),
                                ]),
                          )
                          ),
                    )
                  ],
                  // )
                  // ],
                ),
              ),
            )));
  }

  Widget _termsOfUse(BuildContext context) {
    return new Transform.scale(
        scale: 1,
        child: Opacity(
            opacity: 1,
            child: CupertinoAlertDialog(
              content:
                  SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        color: Color.fromRGBO(244, 217, 66, 4),
                        height: MediaQuery.of(context).size.height / 5,
                        child: Center(
                            child: Image.asset(
                                "assets/images/dipena_logo_square2.png"))),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Center(
                        child: Text("Terms of Use",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                        "Dear the one who will change the world",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text("Welcome to dipena!"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                          "We, as a social network in the scope of creative industry, are doing our best on connecting people with opportunities. And this terms of use will guide you on how we govern the community of dipena to create a sustainable ecosystem. When you signed up for dipena and join the community, you agree with all the terms of use below.",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 25.0, right: 25.0),
                      child: Text("HOW CAN YOU USE DIPENA?",
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                          "We are providing a platform for creative people can share their art in a way people can see it as an opportunities, not only an art. We are doing our best to connecting creative people to the society on business purposes, because we believe that every single thing need to be shaped beautifully. And dipena is all about connecting an opportunities in the scope of creative industry.",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 35.0, right: 25.0),
                      child: Text("•	For painter, designer, and photographer.",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                          "Share your vision and prove it with your art. We genuinely believe that you are not only deserve likes and comments on every post that have posted in your othe social media, but you should get more project and meet with new potential people that could change your life. And so, being as a social network that push you to express yourself on business purposes is what we’re interested in. You’ll be guided on creating a post that will be implified as an opportunities by the society, because you will fill up your service deals every time you want to post your art. ",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 35.0, right: 25.0),
                      child:
                          Text("•	For everyone", textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                          "We bring you closer to the poeple that might work with you to change the world. And we encourage you to “take deals” on every post that you might interest on and communicate with them on our platform. Help us to create this sustainable ecosystem and together change this messy world to be a better place to live. ",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 25.0, right: 25.0),
                      child: Text("HOW CAN'T YOU USE DIPENA?",
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 35.0, right: 25.0),
                      child: Text("•	We are not e-commerce",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                          "As a social network, it means that we’re connecting the society. Please be conscious that this is not an e-commerce where you can sell goods to your audience and it’s a pleasure for us if you can use it the way it should be. ",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 35.0, right: 25.0),
                      child: Text("•	Content prohibited",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: Text(
                          "We don’t give a tolerance for any content that consist any of :",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 35.0, right: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("1.	Pornographic content",
                                textAlign: TextAlign.justify),
                            Text("2.	Highly explicit nudity",
                                textAlign: TextAlign.justify),
                            Text("3.	Hate speech post or comment",
                                textAlign: TextAlign.justify),
                            Text("4.	Harrassment and threats",
                                textAlign: TextAlign.justify),
                            Text("5.	Illegal activities or goods",
                                textAlign: TextAlign.justify),
                            Text("6.	Graphic violence",
                                textAlign: TextAlign.justify),
                            Text("7.	Spam", textAlign: TextAlign.justify),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 25.0, right: 25.0),
                      child: RichText(
                        text: TextSpan(
                            text:
                                'Please note that we will abolish every post which consist any one of above criteria, and we will act less than 24 hours on ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 13.0),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'report ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text:
                                      'from our users that indicate content prohibited.',
                                  style: TextStyle(color: Colors.black)),
                            ]),
                      ),
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 25.0, right: 25.0),
                      child: Container(),
                    )
                  ],
                  // )
                  // ],
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      key: _scaffoldkey,
      backgroundColor: Color.fromRGBO(244, 217, 66, 4),
      body: ListView(
        primary: true,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
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
                          // top: 170,
                          top: 20
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
                      top: 30,
                      // top: 230,
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
                            Opacity(
                              opacity: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 20,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                      text:
                                          'By signing up your account, you agree with our ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'terms of use ',
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () => showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _termsOfUse(
                                                                context),
                                                      ),
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        TextSpan(
                                            text: 'and have read our ',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: 'data policy',
                                            recognizer:
                                                new TapGestureRecognizer()
                                                  ..onTap = () => showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _dataPolicy(
                                                                context),
                                                      ),
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        TextSpan(
                                            text: '.',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 20,
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
                            Expanded(
                              child: Container(
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
