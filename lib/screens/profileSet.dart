import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:WOC/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import './home_screen.dart';

class NewProfile extends StatefulWidget {
  final phoneNum;

  NewProfile(this.phoneNum);

  @override
  _NewProfileState createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  static String name;
  Map docs;
  static String status;
  String picUrl = '';
  List chatUsers = [];
  final TextEditingController _nameController =
      TextEditingController(text: name);
  final TextEditingController _statusController =
      TextEditingController(text: status);
  File _image;
  String extnsn = '';
  bool submit = false;

  Future _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _cropImage(image);
    }
  }

  Future<Null> _cropImage(File picked) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: picked.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
          // toolbarTitle: 'Cropper',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.original,
          // cropGridColor: primaryColor,
          activeControlsWidgetColor: primaryColor,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      picked = croppedFile;
      setState(() {
        _image = picked;
        extnsn = p.extension(_image.path.toString());
        print('extnsn::$extnsn');
      });
      // Scaffold.of(context).showSnackBar(SnackBar(_nameController.text.isEmpty
      //       content: const Text('snack'),
      //       duration: const Duration(seconds: 1),
      //       action: SnackBarAction(
      //         label: 'dismiss',
      //         onPressed: () { },
      //       ),
      //     ));
    }
  }

  readUser() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');
    await collectionRef.doc(uid).get().then((event) {
      setState(() {
        docs = event.data();
        if (docs != null) {
          name = docs['name'];
          status = docs['status'];
          picUrl = docs['photourl'];
          chatUsers = docs['chatUsers'];
          _nameController.text = name;
          _statusController.text = status;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readUser();
  }

  @override
  Widget build(BuildContext context) {
    Future addUser() async {
      setState(() {
        submit = true;
      });
      Map<String, dynamic> data = {
        'name': name,
        'status': status,
        'authId': uid,
        'phnNo': widget.phoneNum,
        'photourl': picUrl,
        'chatUsers': chatUsers
      };
      if (_image != null) {
        String ext = _image.path.toString().split('.').last;
        final StorageReference fbStorage =
            FirebaseStorage.instance.ref().child('users/$uid.$ext');
        final StorageUploadTask task = fbStorage.putFile(_image);
        await task.onComplete.then((value) {
          print('upload complete');
          fbStorage.getDownloadURL().then((url) {
            setState(() {
              print('url::$url');
              picUrl = url;
              CollectionReference ref =
                  FirebaseFirestore.instance.collection('users');
              ref.doc(uid).set(data).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false);
              });
            });
          });
        });
      } else {
        CollectionReference ref =
            FirebaseFirestore.instance.collection('users');
        ref.doc(uid).update(data).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: submit
          ? Container(
              height: MediaQuery.of(context).size.height,
              child: Container(
                color: Colors.black.withAlpha(100),
                child: SpinKitRing(
                  color: Colors.white,
                  size: 50.0,
                ),
              ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundImage: _image == null
                              ? NetworkImage(picUrl)
                              : FileImage(_image),
                          radius: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.25,
                              vertical:
                                  MediaQuery.of(context).size.width * 0.1),
                          alignment: Alignment.bottomRight,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: FloatingActionButton(
                            backgroundColor: primaryColor,
                            onPressed: _imgFromGallery,
                            child: Icon(Icons.add),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: TextField(
                      controller: _nameController,
                      onEditingComplete: () {
                        name = _nameController.text;
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.6),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: TextField(
                      onEditingComplete: () {
                        status = _statusController.text;
                        FocusScope.of(context).unfocus();
                      },
                      controller: _statusController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Update your status',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.6),
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
                      onPressed: _nameController.text.isEmpty &&
                              _statusController.text.isEmpty
                          ? null
                          : addUser,
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
