// import 'package:WOC/data/chatData.dart';
import 'package:WOC/models/chatsModel.dart';
import 'package:WOC/screens/home_screen.dart';
import 'package:WOC/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String rUid;
  final String headName;
  ChatPage(this.rUid, this.headName);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List chatData = [];

  final String uid = FirebaseAuth.instance.currentUser.uid;
  final TextEditingController _msgControl = TextEditingController();
  String msg;
  CollectionReference ref = FirebaseFirestore.instance.collection('chats');
  ScrollController _scrollController;

  CollectionReference reference =
      FirebaseFirestore.instance.collection('users');

  getChatData() {
    print('intitate');
    List docSort = [uid, widget.rUid];
    docSort.sort();
    String docid = '${docSort[0]}${docSort[1]}';
    print(docid);
    ref.doc(docid).snapshots().listen((snapshot) {
      setState(() {
        print(snapshot.data());
        chatData = snapshot.data()['AllChats'];
        scrollToBottom();
      });
    });

    // print(chatData[0]['timeStamp'].);
  }

  addChatData() async {
    List docSort = [uid, widget.rUid];
    docSort.sort();
    String docid = '${docSort[0]}${docSort[1]}';

    print('data before...${chatData}');
    await ref.doc(docid).get().then((snapshot) {
      setState(() {
        chatData = snapshot.data() == null ? [] : snapshot.data()['AllChats'];
        chatData.add({
          'message': msg,
          'recieverId': widget.rUid,
          'senderId': uid,
          'timeStamp': Timestamp.now()
        });
        print('db me set');
        ref
            .doc(docid)
            .set({'AllChats': chatData}).then((value) => print('vafafdaf'));
        updateChatUsersList();
        _msgControl.clear();
      });
    });
    // await updateChatUsersList();
  }

  updateChatUsersList() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    await ref.doc(uid).get().then((snap) {
      var chatUsers = snap.data()['chatUsers'];
      print('chatusers:::$chatUsers');
      bool flag = false;
      if (chatUsers != null) {
        for (var user in chatUsers) {
          if (user == widget.rUid) {
            flag = true;
            break;
          }
        }
      }
      if (!flag || chatUsers == null) {
        if (chatUsers == null) chatUsers = [];
        chatUsers.add(widget.rUid);
        ref.doc(uid).update({'chatUsers': chatUsers}).then(
            (value) => print('updated!'));
      }
    });
    await ref.doc(widget.rUid).get().then((snap) {
      var chatUsers1 = snap.data()['chatUsers1'];
      print('chatusers1:::$chatUsers1');
      bool flag = false;
      if (chatUsers1 != null) {
        for (var user in chatUsers1) {
          if (user == widget.rUid) {
            flag = true;
            break;
          }
        }
      }
      if (!flag || chatUsers1 == null) {
        if (chatUsers1 == null) chatUsers1 = [];
        chatUsers1.add(uid);
        ref.doc(widget.rUid).update({'chatUsers': chatUsers1}).then(
            (value) => print('updated!'));
      }
    });
  }

  scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    print('dfkjasdlkjsdf');
    getChatData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headName),
        leading: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: primaryColor,
                // size: 20,
              ),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
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
              controller: _scrollController,
              itemBuilder: (ctx, index) {
                var timestamp = chatData[index]['timeStamp'].toDate();
                timestamp = DateFormat.Hm().format(timestamp);
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  // padding: EdgeInsets.all(20),

                  // decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Align(
                        alignment: chatData[index]['senderId'] == uid
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: chatData[index]['senderId'] ==
                                    uid // this sender denotes to the current Logged in user
                                ? primaryColor
                                : accent4,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            chatData[index]['message'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: chatData[index]['senderId'] ==
                                        uid // this sender denotes to the current Logged in user
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Align(
                        alignment: chatData[index]['senderId'] == uid
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Text(
                              timestamp.toString(),
                              style: TextStyle(color: accent2.withAlpha(150)),
                            )),
                      )
                    ],
                  ),
                  // width: MediaQuery.of(context).size.width * 0.1,
                );
              },
              itemCount: chatData.length,
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
                            onChanged: (c) {
                              setState(() {
                                msg = c;
                              });
                            },
                            controller: _msgControl,
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
                          onPressed:
                              _msgControl.text == '' ? null : addChatData,
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
