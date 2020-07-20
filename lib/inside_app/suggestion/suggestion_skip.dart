import 'package:dipena/inside_app/suggestion/suggestion_model.dart';
import 'package:flutter/material.dart';

class SuggestionSkip extends StatefulWidget {
  @override
  _SuggestionSkipState createState() => _SuggestionSkipState();
}

class _SuggestionSkipState extends State<SuggestionSkip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dipena",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "Poppins Medium",
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              child: Ink.image(
                image: AssetImage(
                  "assets/img/chat_icon.png",
                ),
                width: 25,
                height: 25,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Ut enim ad minim veniam",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Poppins Semibold",
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Duis aute irure dolor in reprehen \n in voluptate velit esse",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins Regular",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Color(0xFFF1F2F6),
                    width: MediaQuery.of(context).size.width / 1,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            "People you might know",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: "Poppins Medium",
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: suggestData.length,
                              itemBuilder: (context, i) => Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.2,
                                    height: MediaQuery.of(context).size.height /
                                        5,
                                    child: Card(
                                      elevation: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            child: ClipOval(
                                              child: Image(
                                                width: 50,
                                                height: 50,
                                                image: AssetImage(
                                                  suggestData[i].icon,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            suggestData[i].name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontFamily: "Poppins Semibold",
                                            ),
                                          ),
                                          Text(
                                            suggestData[i].username,
                                            style: TextStyle(
                                              color: Color(0xFF7F8C8D),
                                              fontSize: 12,
                                              fontFamily: "Poppins Regular",
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            width: 80,
                                            height: 25,
                                            child: OutlineButton(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF39C12),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                "Follow",
                                                style: TextStyle(
                                                  color: Color(0xFFF39C12),
                                                  fontSize: 13,
                                                  fontFamily: "Poppins Regular",
                                                ),
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
