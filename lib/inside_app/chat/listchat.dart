import 'dart:convert';

import 'package:dipena/inside_app/chat/chat_page.dart';
import 'package:dipena/model/listChat.dart';
import 'package:dipena/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListChat extends StatefulWidget {
  @override
  _ListChatState createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  String user_id, valuee, follow_user_one, user_username;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString("user_id");
      user_username = preferences.getString("user_username");
      // follow_user_one = preferences.getString("user_id");
    });
  }

  var loading = false;
  final list = new List<ListChatModels>();
  Future<void> _listChat() async {
    await getPref();
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post("https://dipena.com/flutter/api/chat/listChat2_0.php", body: {
      "user_id": user_id,
    });
    if (response.contentLength == 2) {
      //   await getPref();
      // final response =
      //     await http.post("https://dipena.com/flutter/api/updateProfile.php");
      //   "user_id": user_id,
      //   "location_country": location_country,
      //   "location_city": location_city,
      //   "location_user_id": user_id
      // });

      // final data = jsonDecode(response.body);
      // int value = data['value'];
      // String message = data['message'];
      // String changeProf = data['changeProf'];
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ListChatModels(
            api['chat_content'],
            api['chat_time'],
            api['user_username'],
            api['user_fullname'],
            api['user_img'],
            api['chat_user_two'],
            api['chat_user_one'],
            api['user_username_from'],
            api['user_fullname_from'],
            api['user_img_from']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _listChat();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = CircleAvatar(
      backgroundColor: Color(0xFF7F8C8D),
      child: ClipOval(
        child: Image(
          image: AssetImage("assets/img/user_search.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
    return Scaffold(
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
          "Chats",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Poppins Medium",
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          final x = list[i];
          return x.user_username != user_username ? 
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: x.user_img == null
                  ? placeholder
                  : CircleAvatar(
                      backgroundColor: Color(0xFF7F8C8D),
                      // child: ClipOval(
                      // child: Image(
                      // image: NetworkImage(ImageUrl.imageProfile + x.user_img_from),
                      // fit: BoxFit.cover
                      backgroundImage:
                          NetworkImage(ImageUrl.imageProfile + x.user_img),
                      minRadius: 40,
                    ),
              // ),
              // ),
            ),
            title: Text(
              // name,
              x.user_fullname,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: "Poppins Semibold",
              ),
            ),
            subtitle: Text(
              // chat,
              x.chat_content,
              style: TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 15,
                fontFamily: "Poppins Regular",
              ),
            ),
            trailing: Text(
              // time,
              x.chat_time,
              style: TextStyle(
                color: new Color(0xFF7F8C8D),
                fontFamily: "Poppins Regular",
              ),
            ),
            onTap: () async {
              var navigationResult = await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => Chat(x),
                ),
              );
            },
          ) : 
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: x.user_img_from == null
                  ? placeholder
                  : CircleAvatar(
                      backgroundColor: Color(0xFF7F8C8D),
                      // child: ClipOval(
                      // child: Image(
                      // image: NetworkImage(ImageUrl.imageProfile + x.user_img_from),
                      // fit: BoxFit.cover
                      backgroundImage:
                          NetworkImage(ImageUrl.imageProfile + x.user_img_from),
                      minRadius: 40,
                    ),
              // ),
              // ),
            ),
            title: Text(
              // name,
              x.user_fullname_from,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: "Poppins Semibold",
              ),
            ),
            subtitle: Text(
              // chat,
              x.chat_content,
              style: TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 15,
                fontFamily: "Poppins Regular",
              ),
            ),
            trailing: Text(
              // time,
              x.chat_time,
              style: TextStyle(
                color: new Color(0xFF7F8C8D),
                fontFamily: "Poppins Regular",
              ),
            ),
            onTap: () async {
              var navigationResult = await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => Chat(x),
                ),
              );
            },
          );
        },
        // children: <Widget>[
        // new ListChatModel(
        //   profile: "assets/img/icon_one.jpg",
        //   name: "Tia Nurmala",
        //   chat: "Ini adalah isi chatnya",
        //   time: "05.00",
        // ),
        // new ListChatModel(
        //   profile: "assets/img/icon_two.png",
        //   name: "Taye",
        //   chat: "Ini adalah isi chatnya",
        //   time: "06.00",
        // ),
        // new ListChatModel(
        //   profile: "assets/img/icon_three.jpg",
        //   name: "Baby",
        //   chat: "Ini adalah isi chatnya",
        //   time: "07.00",
        // ),
        // new ListChatModel(
        //   profile: "assets/img/icon_four.jpg",
        //   name: "Mala",
        //   chat: "Ini adalah isi chatnya",
        //   time: "08.00",
        // ),
        // new ListChatModel(
        //   profile: "assets/img/icon_five.jpg",
        //   name: "Roxann",
        //   chat: "Ini adalah isi chatnya",
        //   time: "09.00",
        // ),
        // new ListChatModel(
        //   profile: "assets/img/icon_six.jpg",
        //   name: "Joe",
        //   chat: "Ini adalah isi chatnya",
        //   time: "12.00",
        // ),
        // ],
      ),
    );
  }
}

// class ListChatModel extends StatelessWidget {
//   ListChatModel({this.profile, this.name, this.chat, this.time});
//   final String profile;
//   final String name;
//   final String chat;
//   final String time;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       leading: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//         child: CircleAvatar(
//           backgroundColor: Color(0xFF7F8C8D),
//           child: ClipOval(
//             child: Image(
//               image: AssetImage(profile),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//       title: Text(
//         name,
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 16,
//           fontFamily: "Poppins Semibold",
//         ),
//       ),
//       subtitle: Text(
//         chat,
//         style: TextStyle(
//           color: Color(0xFF7F8C8D),
//           fontSize: 15,
//           fontFamily: "Poppins Regular",
//         ),
//       ),
//       trailing: Text(
//         time,
//         style: TextStyle(
//           color: new Color(0xFF7F8C8D),
//           fontFamily: "Poppins Regular",
//         ),
//       ),
//       onTap: () async {
//         var navigationResult = await Navigator.push(
//           context,
//           new MaterialPageRoute(
//             builder: (context) => Chat(),
//           ),
//         );
//         if (navigationResult == true) {
//           MaterialPageRoute(
//             builder: (context) => Chat(),
//           );
//         }
//       },
//     );
//   }
// }
