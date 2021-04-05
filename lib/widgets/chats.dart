import 'package:WOC/data/databasehelper.dart';
import 'package:WOC/models/chatContactModel.dart';
import 'package:WOC/screens/chatPage.dart';
import 'package:WOC/screens/contactsList.dart';
import 'package:WOC/widgets/popupWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../themes/colors.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  List<ChatContactModel> chatUsersList = [];
  List contacts = [];

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

    ref.doc(uid).snapshots().listen((snapshot) async {
      if (snapshot.data() != null) {
        List r_uids = snapshot.data()['chatUsers'];
        print('users:::$r_uids');
        // print('contacts::${contacts[0]['id']}');
        for (var id in r_uids) {
          await fetchAllContacts(id);

          name = contacts.first[DatabaseHelper.colName];
          status = contacts.first[DatabaseHelper.colStatus];
          photo = contacts.first[DatabaseHelper.colPic];

          ChatContactModel model = ChatContactModel(
            name: name,
            uid: id,
            status: status,
            photoUrl: photo,
          );
          print('model::$model');
          setState(() {
            chatUsersList.add(model);
          });
        }
      }
    });
  }

  fetchAllContacts(String id) async {
    List _contacts = await DatabaseHelper.db
        .query('SELECT * FROM ${DatabaseHelper.tablename} WHERE id=?', [id]);
    setState(() {
      contacts = _contacts;
      // print(_contacts[1]['id']);
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
                    color: accent2.withAlpha(80),
                  ))),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    onLongPress: () {
                      // deleteAlert(ctx, user.uid);
                    },
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ChatPage(user.uid, user.name))),
                    leading: GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(HeroDialogRoute)
                        createPopup(context, user.photoUrl, user.status);
                      },
                      child: CircleAvatar(
                          child: Container(
                            child: user.photoUrl == '' || user.photoUrl == null
                                ? Container(
                                    // color: primaryColor.withAlpha(90),
                                    child: SpinKitPulse(
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  )
                                : null,
                          ),
                          backgroundColor: accent2,
                          radius: 30,
                          backgroundImage: NetworkImage(user.photoUrl)),
                    ),
                    title: Text(user.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)), //  UserName
                    // subtitle: Text(user.recentMsg,
                    //     style: TextStyle(
                    //         fontSize: 15,
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
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Make your first message..',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       shape: BoxShape.circle, color: primaryColor),
                  //   child: IconButton(
                  //       icon: Icon(Icons.add),
                  //       color: Colors.white,
                  //       onPressed: tempchat),
                  // )
                ],
              ),
            ),
          );
  }
}
