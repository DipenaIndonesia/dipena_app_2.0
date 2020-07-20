import 'package:flutter/material.dart';

class HomeCollab extends StatefulWidget {
  @override
  _HomeCollabState createState() => _HomeCollabState();
}

class _HomeCollabState extends State<HomeCollab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Collabs",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins Medium",
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          new ListCollabsModel(
            profile: "assets/img/icon_one.jpg",
            name: "Tia Nurmala",
            username: "@ttiamala",
          ),
          new ListCollabsModel(
            profile: "assets/img/icon_two.png",
            name: "Taye",
            username: "@tianurmala_",
          ),
          new ListCollabsModel(
            profile: "assets/img/icon_three.jpg",
            name: "Baby",
            username: "@babyRoxann",
          ),
          new ListCollabsModel(
            profile: "assets/img/icon_four.jpg",
            name: "Mala",
            username: "@keykim",
          ),
          new ListCollabsModel(
            profile: "assets/img/icon_five.jpg",
            name: "Adam",
            username: "@adam_traceurs",
          ),
          new ListCollabsModel(
            profile: "assets/img/icon_six.jpg",
            name: "Joe",
            username: "@joesnadya",
          ),
        ],
      ),
    );
  }
}

class ListCollabsModel extends StatelessWidget {
  ListCollabsModel({this.profile, this.name, this.username});
  final String profile;
  final String name;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: Color(0xFF7F8C8D),
          child: ClipOval(
            child: Image(
              image: AssetImage(profile),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: "Poppins Semibold",
        ),
      ),
      subtitle: Text(
        username,
        style: TextStyle(
          color: Color(0xFF7F8C8D),
          fontSize: 14,
          fontFamily: "Poppins Regular",
        ),
      ),
      onTap: () {},
    );
  }
}
