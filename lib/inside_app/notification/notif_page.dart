import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins Medium",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 40,),
            Text("You don't have any notification yet")
            // new Notify(
            //   profile: "assets/img/icon_one.jpg",
            //   username: "Joseph Buttler",
            //   aktifitas: "commented your post.",
            //   waktu: "4 days ago",
            //   post: 'assets/img/post_one.jpg',
            // ),
            // new Notify(
            //   profile: "assets/img/icon_two.png",
            //   username: "Joseph Buttler",
            //   aktifitas: "wants collab with you.",
            //   waktu: "4 hours ago",
            //   post: 'assets/img/post_two.jpg',
            // ),
          ],
        ),
      ),
    );
  }
}

class Notify extends StatelessWidget {
  Notify({this.profile, this.username, this.aktifitas, this.waktu, this.post});
  final String profile;
  final String username;
  final String aktifitas;
  final String waktu;
  final String post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
        title: RichText(
          text: TextSpan(
            text: username + " ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: "Poppins Semibold",
            ),
            children: <TextSpan>[
              TextSpan(
                text: aktifitas,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Poppins Regular",
                ),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            waktu,
            style: TextStyle(
              fontSize: 13,
              fontFamily: "Poppins Regular",
            ),
          ),
        ),
        trailing: Image(
          image: AssetImage(
            post,
          ),
          width: 50,
          height: 50,
        ),
        onTap: () {},
      ),
    );
  }
}
