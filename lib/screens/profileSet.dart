import 'package:WOC/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './home_screen.dart';

class NewProfile extends StatefulWidget {
  final phoneNum;

  NewProfile(this.phoneNum);

  @override
  _NewProfileState createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _statusController = TextEditingController();

  String name;

  String status;

  @override
  Widget build(BuildContext context) {
    Map docs;
    addUser() async {
      //uid
      String uid = FirebaseAuth.instance.currentUser.uid;

      // Data
      Map<String, dynamic> data = {
        'name': name,
        'status': status,
        // 'authId': uid,
        'phnNo': widget.phoneNum,
        'photourl': 'https://picsum.photos/500'
      };

      // Adds user to db collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');

      await collectionRef.doc(uid).set(data).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      });
    }

    readUser() {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');
      collectionRef.snapshots().listen((snap) {
        setState(() {
          docs = snap.docs[0].data();
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(200))),
              child: Center(
                child: Text(
                  'PROJECT-Y!',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                controller: _nameController,
                onEditingComplete: () => name = _nameController.text,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                onEditingComplete: () => status = _statusController.text,
                controller: _statusController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Update your status',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: FlatButton(
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                onPressed: addUser,
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                minWidth: MediaQuery.of(context).size.width * 0.9,
                color: primaryColor,
              ),
            ),
            FlatButton(onPressed: readUser, child: Text('read!')),
            Container(child: Text(docs.toString()))
          ],
        ),
      ),
    );
  }
}
