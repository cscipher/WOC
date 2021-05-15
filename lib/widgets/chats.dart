import 'package:WOC/data/databasehelper.dart';
import 'package:WOC/models/chatContactModel.dart';
import 'package:WOC/models/fcm_tokenModel.dart';
import 'package:WOC/screens/chatPage.dart';
import 'package:WOC/screens/contactsList.dart';
import 'package:WOC/widgets/popupWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../themes/colors.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  List<ChatContactModel> chatUsersList = [];
  List contacts = [];
  var msg = '', time;

  bool addcontact(String id) {
    bool check = false;
    for (var c in chatUsersList) {
      if (c.uid == id) {
        check = true;
        break;
      } else {
        check = false;
      }
    }
    return !check;
  }

  getAllChats() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    var name = '', photo = '', status = '';
    final FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();

    final tokenRef = ref.doc(uid).collection('tokens').doc(fcmToken);

    await tokenRef.set(
      TokenModel(token: fcmToken, createdAt: FieldValue.serverTimestamp())
          .toJson(),
    );

    ref.doc(uid).get().then((snapshot) async {
      if (snapshot.data() != null) {
        List r_uids = snapshot.data()['chatUsers'];
        print('users:::$r_uids');
        // print('contacts::${contacts[0]['id']}');
        for (var id in r_uids) {
          await fetchAllContacts(id);
          getRecentMsg(id);
          print('contacts::$contacts');
          name = contacts.first[DatabaseHelper.colName];
          status = contacts.first[DatabaseHelper.colStatus];
          photo = contacts.first[DatabaseHelper.colPic];
          ChatContactModel model = ChatContactModel(
              name: name,
              uid: id,
              status: status,
              photoUrl: photo,
              recentMsg: msg,
              timestamp: time);
          print('model::$model');
          setState(() {
            chatUsersList.add(model);
            print(chatUsersList);
          });
        }
      } else {
        print('nothing from snap!');
      }
    });
  }

  fetchAllContacts(String id) async {
    List _contacts = await DatabaseHelper.db
        .query('SELECT * FROM ${DatabaseHelper.tablename} WHERE id=?', [id]);
    var q = await DatabaseHelper.db.queryAll();
    for (var i in q) {
      print('q???$i');
    }
    setState(() {
      print(_contacts);
      contacts = _contacts;
    });
  }

  getRecentMsg(String id) {
    CollectionReference ref = FirebaseFirestore.instance.collection('chats');
    List<String> finalId = [id, uid];
    finalId.sort();
    String finalSid = finalId[0] + finalId[1];

    ref.doc(finalSid).snapshots().listen((event) {
      var data = event.data()['AllChats'];
      msg = data.last['message'];
      time = data.last['timeStamp'].toDate();
      time = DateFormat.Hm().format(time);
    });
  }

  deleteAlert(BuildContext ctx, String id) {
    return showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Delete Alert'),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            content: Text(
                'Do you want to delete this entire chat with this person?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      chatUsersList = chatUsersList.where((element) {
                        return element.uid != id;
                      }).toList();
                    });
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: neutralRed),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text('Dismiss'))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(child: Text(chatUsersList[2].name.toString()));
    return chatUsersList.length != 0
        ? Container(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                var user = chatUsersList[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: accent2.withOpacity(0.1),
                  ))),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ChatPage(user.uid, user.name))),
                    leading: GestureDetector(
                      onTap: () {
                        createPopup(context, user.photoUrl, user.status);
                      },
                      child: CircleAvatar(
                        backgroundColor: accent2,
                        radius: 30,
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoUrl),
                      ),
                    ),
                    title: Text(user.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)), //  UserName
                    // subtitle: Text(user.recentMsg ?? '',
                    //     style: TextStyle(
                    //         fontSize: 15,  
                    //         color: Colors.red,
                    //         fontWeight:
                    //             FontWeight.w100)), //Last msg in one line
                    // trailing: Text(user.timestamp),
                  ),
                );
              },
              itemCount: chatUsersList.length,
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Center(
              child: Text(
                'Huh! Nothing here! Start Chatting by making new message! 💬',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          );
  }
}
