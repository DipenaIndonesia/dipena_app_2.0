import 'package:dipena/inside_app/suggestion/suggestion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFF39C12) : Color(0xFFBDC3C7),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async {
          Future.value(
              false); //return a `Future` with false value so this route cant be popped or closed.
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Image.asset(
                          "assets/img/dipena_logo.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 50,
                        child: FlatButton(
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Color(0xFFF39C12),
                              fontSize: 15,
                              fontFamily: "Poppins Regular",
                            ),
                          ),
                          onPressed: () async {
                            var navigationResult = await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => SuggestionPage(),
                              ),
                            );
                            if (navigationResult == true) {
                              MaterialPageRoute(
                                builder: (context) => SuggestionPage(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                    'assets/img/illustration_one.png',
                                  ),
                                  width: 400,
                                  height: 300,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Share your art!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Poppins Semibold",
                                  ),
                                ),
                                Text(
                                  "Dipena is a place where people \n can share their art",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "Poppins Regular",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage(
                                      'assets/img/illustration_two.png',
                                    ),
                                    width: 400,
                                    height: 300,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Collab with others!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: "Poppins Semibold",
                                    ),
                                  ),
                                  Text(
                                    "It's not only about sharing art, \n but this social network was built \n for you to collaborate with other creators",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Poppins Regular",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage(
                                      'assets/img/illustration_three.png',
                                    ),
                                    width: 400,
                                    height: 300,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Let's do this!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: "Poppins Semibold",
                                    ),
                                  ),
                                  Text(
                                    "Whoever and wherever you are, \n people need you. Go change the world \n in a way you could do it, we got your back",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Poppins Regular",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: _currentPage == _numPages - 1
              ? SizedBox(
                  width: 650,
                  height: 65,
                  child: RaisedButton(
                    color: Color(0xFFF39C12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Poppins Regular",
                      ),
                    ),
                    onPressed: () async {
                      var navigationResult = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => SuggestionPage(),
                        ),
                      );
                      if (navigationResult == true) {
                        MaterialPageRoute(
                          builder: (context) => SuggestionPage(),
                        );
                      }
                    },
                  ),
                )
              : Text(''),
        ));
  }
}
