import 'package:flutter/material.dart';

class ListCollabs extends StatefulWidget {
  @override
  _ListCollabsState createState() => _ListCollabsState();
}

class _ListCollabsState extends State<ListCollabs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Collabs",
          style: TextStyle(color: Colors.black, fontFamily: "Poppins Regular"),
        ),
      ),
      body: ListView(
        children: <Widget>[
          new List(
            profile:
                'https://dipena.com/flutter/assets/images/Profile_Icon_7.jpg',
            name: "Tia Nurmala",
            username: "@ttiamala",
          ),
          new List(
            profile:
                'https://dipena.com/flutter/assets/images/Profile_Icon_4.jpg',
            name: "Taye",
            username: "@tianurmala_",
          ),
          new List(
            profile:
                'https://dipena.com/flutter/assets/images/Profile_Icon_5.jpg',
            name: "Baby",
            username: "@babyRoxann",
          ),
          new List(
            profile:
                'https://dipena.com/flutter/assets/images/Profile_Icon_2.jpg',
            name: "Mala",
            username: "@keykim",
          ),
          new List(
            profile:
                'https://dipena.com/flutter/assets/images/Profile_Icon_6.jpg',
            name: "Adam",
            username: "@adam_traceurs",
          ),
          new List(
            profile:
                'https://dipena.com/flutter/assets/images/Profile_Icon_3.jpg',
            name: "Joe",
            username: "@joesnadya",
          ),
        ],
      ),
    );
  }
}

class List extends StatelessWidget {
  List({this.profile, this.name, this.username});
  final String profile;
  final String name;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        // dense: true,
        leading: Container(
          padding: EdgeInsets.all(0),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image(
                image: NetworkImage(profile),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(fontFamily: "Poppins Bold"),
        ),
        subtitle: Text(username,
            style:
                TextStyle(color: Colors.black, fontFamily: "Poppins Regular")),
        onTap: () {});
  }
}
