import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chatContactModel.dart';
import '../models/chatsModel.dart';

final String uid = FirebaseAuth.instance.currentUser.uid;
List<ChatContactModel> contactList;

getAllChats() {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  ref.doc(uid).snapshots().listen((snapshot) {
    var r_uids = snapshot.data()['chatUsers'];
    var name = [];
    r_uids.asMap().map((e) {
      ref.doc(e).get().then((value) {
        name.add(value['name']);
      });
    });
    print('names..${name}');
    print('rUids..${r_uids}');
  });
}



// final List<ChatModel> chatList = [

// ChatModel(
//     timeStamp: '20:40',
//     message: 'how are you!',
//     senderId: 'Cipher',
//     recieverId: 'Harsh'),
// ChatModel(
//     timeStamp: '20:40',
//     message: 'rasengan!',
//     senderId: 'Cipher',
//     recieverId: 'sasuke'),
// ChatModel(
//     timeStamp: '20:40',
//     message: 'chidori',
//     senderId: 'Cipher',
//     recieverId: 'Rin'),
// ChatModel(
//     timeStamp: '20:40',
//     message: 'Tsukoyomi',
//     senderId: 'Cipher',
//     recieverId: 'Itachi'),
// ChatModel(
//     timeStamp: '20:40',
//     message: 'Uchiha no monoha',
//     senderId: 'Cipher',
//     recieverId: 'Tobirama'),
// ChatModel(
//     timeStamp: '20:40',
//     message: 'chidori',
//     senderId: 'Cipher',
//     recieverId: 'Rin'),
// ChatModel(
//     timeStamp: '20:40',
//     message: "You're alive!",
//     senderId: 'Cipher',
//     recieverId: 'Fish')
// ];

// List <ChatModel> getChatsFromFirebase(){
//   FirebaseFirestore.instance.collection('chats').get()
// }
