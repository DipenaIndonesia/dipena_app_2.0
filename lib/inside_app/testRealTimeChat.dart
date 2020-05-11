import 'package:flutter/material.dart';

const String _name = "Roxann";

class ChatMessage extends StatelessWidget {
  final String text;

// constructor to get text from textfield
  ChatMessage({this.text});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Buble(
          message: text,
          isMe: true,
        ),
      ),
    );
  }
}

class Buble extends StatelessWidget {
  final bool isMe;
  final String message;

  Buble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return ListView(
      // primary: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          padding: isMe
              ? EdgeInsets.only(
                  left: 40,
                )
              : EdgeInsets.only(
                  right: 40,
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Color.fromRGBO(244, 217, 66, 1)
                          : Colors.grey[300],
                      borderRadius: isMe
                          ? BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(15),
                            )
                          : BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(0),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message,
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
