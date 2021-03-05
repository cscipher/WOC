import 'package:WOC/data/chatData.dart';
import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatLength = length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cipher'),
        leading: Container(
          decoration: BoxDecoration(boxShadow: [shadow]),
          child: FlatButton(
            child: const Icon(
              Icons.arrow_back_rounded,
              // color: primaryColor,
            ),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.call,
                color: primaryColor,
                size: 30,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.video_call,
                color: primaryColor,
                size: 30,
              ),
              onPressed: () {}),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.12),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  // padding: EdgeInsets.all(20),

                  // decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Align(
                        alignment: chatData[index].senderId == 'Cipher'
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: chatData[index].senderId ==
                                    'Cipher' // this sender denotes to the current Logged in user
                                ? primaryColor
                                : accent4,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            chatData[index].message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: chatData[index].senderId ==
                                        'Cipher' // this sender denotes to the current Logged in user
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Align(
                        alignment: chatData[index].senderId == 'Cipher'
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Text(
                              chatData[index].timeStamp,
                              style: TextStyle(color: accent2.withAlpha(150)),
                            )),
                      )
                    ],
                  ),
                  // width: MediaQuery.of(context).size.width * 0.1,
                );
              },
              itemCount: chatLength,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 90,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        border: Border.all(color: accent2.withAlpha(60)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Enter your message",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.send,
                            color: primaryColor,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                  Container(
                    decoration: BoxDecoration(boxShadow: [shadow]),
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Icon(
                        FontAwesomeIcons.plus,
                        color: primaryColor,
                        size: 25,
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
