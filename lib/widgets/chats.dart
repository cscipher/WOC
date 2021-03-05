import 'package:WOC/screens/chatPage.dart';
import 'package:flutter/material.dart';
import '../data/userListData.dart';
import '../models/chatsModel.dart';
import '../themes/colors.dart';

class ChatList extends StatefulWidget {
  final List<ChatModel> allChats = chatList;
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // get allChats => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: accent2.withAlpha(80),
            ))),
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
            child: ListTile(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => ChatPage())),
              leading: CircleAvatar(
                backgroundColor: accent2,
                radius: 30,
                child: Text(
                  widget.allChats[index].recieverId[0].toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                backgroundImage: NetworkImage('https://picsum.photos/500'),
              ),
              title: Text(widget.allChats[index].recieverId,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)), //  UserName
              subtitle: Text(widget.allChats[index].message,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100)), //Last msg in one line
              trailing: Text(widget.allChats[index].timeStamp),
            ),
          );
        },
        itemCount: chatList.length,
      ),
    );
  }
}
