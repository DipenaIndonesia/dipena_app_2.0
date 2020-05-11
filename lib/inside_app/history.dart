import 'package:flutter/material.dart';

import 'chat.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Deals Taken',
          style: TextStyle(
            color: Color.fromRGBO(244, 217, 66, 1),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(244, 217, 66, 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          right: 10,
          left: 10,
        ),
        child: Container(
          color: Colors.white,
          width: 375,
          height: 200,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          child: ClipOval(
                            child: Image(
                              width: 50,
                              height: 50,
                              image: AssetImage(
                                'assets/images/Profile_Icon_1.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        'TAYEEE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Color.fromRGBO(244, 217, 66, 1),
                        ),
                        onPressed: ()  async {
                        // var navigationResult = await Navigator.push(
                        //   context,
                        //   new MaterialPageRoute(
                        //     builder: (context) => Chat(),
                        //   ),
                        // );
                      },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color.fromRGBO(244, 217, 66, 1),
                width: 300,
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 15,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            'assets/images/Post_1.jpg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Summer Breeze',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Lorem ipsum dolor sit amet ey...',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timer,
                                ),
                                Text(
                                  '1h ago',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}