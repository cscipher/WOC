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
    var name='',photo='',status='';

    ref.doc(uid).snapshots().listen((snapshot) async {
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
          photoUrl: photo,);
        print('model::$model');
        setState(() {
          chatUsersList.add(model);
        });
        // ref.doc(id).get().then((event) {
        //   print(event.data());
        //   name = event.data()['name'];
        //   status = event.data()['status'];
        //   photo = event.data()['photourl'];
        //   ChatContactModel model = ChatContactModel(
        //       name: name,
        //       uid: id,
        //       status: status,
        //       photoUrl: photo,);
        //   print('model::$model');
        //   setState(() {
        //     chatUsersList.add(model);
        //   });
        // });
      }
    });
  }


  fetchAllContacts(String id) async {
    List _contacts = await DatabaseHelper.db.query('SELECT * FROM ${DatabaseHelper.tablename} WHERE id=?', [id]);
    setState(() {
      contacts = _contacts;
      // print(_contacts[1]['id']);
    });
  }


  Future tempchat() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    CollectionReference ref2 = FirebaseFirestore.instance.collection('chats');
    ref2.snapshots().listen((event) {
      event.docs.map((e) async {
        var doc = e.data();
        var name, photo, recentMessage, time;
        setState(() {
          recentMessage = doc['AllChats'].last['message'];
          time = doc['AllChats'].last['timeStamp'].toDate();
          time = DateFormat.Hm().format(time).toString();
        });
        if (doc['AllChats'][0]['recieverId'] == uid) {
          await ref
              .doc(doc['AllChats'][0]['senderId'])
              .get()
              .then((value) => setState(() {
                    name = value.data()['name'];
                    photo = value.data()['photourl'];
                  }));
          setState(() {
            print('message....$recentMessage');
            print('Time....$time');
            addcontact(doc['AllChats'][0]['senderId'])
                ? chatUsersList.add(ChatContactModel(
                    name: name,
                    uid: doc['AllChats'][0]['senderId'],
                    recentMsg: recentMessage,
                    photoUrl: photo,
                    timestamp: time))
                : null;
            print(chatUsersList);
            // ref.doc(uid).get().then((value) {
            //   var updateValue = value.data();
            //   updateValue['chatUsers'].add(doc['AllChats'][0]['senderId']);
            //   ref.doc(uid).update(updateValue);
            // });
          });
        } else {
          print('nothing....${doc['AllChats'][0]['recieverId']}::::$uid');
        }
      }).toList();
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ChatPage(user.uid,
                                user.name))),
                    leading: GestureDetector(
                      onTap: (){
                        // Navigator.of(context).push(HeroDialogRoute)
                        createPopup(context, user.photoUrl, user.status);
                      },
                      child: CircleAvatar(
                        child: Container(
                          child: user.photoUrl == '' || user.photoUrl == null ? Container(
                            // color: primaryColor.withAlpha(90),
                            child: SpinKitPulse(
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ) : null,
                        ),
                          backgroundColor: accent2,
                          radius: 30,
                          backgroundImage:
                              NetworkImage(user.photoUrl)
                      ),
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
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: tempchat),
                  )
                ],
              ),
            ),
          );
  }
}

// ref2.snapshots().listen((event) {
//   var data = event.docs;
//   print('mydataa:::$data');
//   data.map((chatCollection) {
//     var idsort = [uid, id];
//     idsort.sort();
//     var idsortstring = '${idsort[0]}${idsort[1]}';
//     print('sortid:::$idsortstring');
//     print('cid::::${chatCollection.id}');
//
//     if(chatCollection.id == idsortstring){
//       recentMessage = chatCollection.data()['AllChats'].last['message'];
//       time = chatCollection.data()['AllChats'].last['timeStamp'].toDate();
//       time = DateFormat.Hm().format(time).toString();
//       ChatContactModel model = ChatContactModel(
//           name: name,
//           uid: idsortstring,
//           recentMsg: recentMessage,
//           photoUrl: photo,
//           timestamp: time);
//       print('model::$model');
//       setState(() {
//               chatUsersList.add(model);
//             });
//     }
//     // print('id::${chatCollection.id}');
//   }).toList();
// });