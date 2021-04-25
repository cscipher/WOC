import 'dart:io';
import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/popupWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static String name, status, picUrl = '';
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _statusController =
      TextEditingController(text: '');
  // final String uid =
  //     '3xLsJBJgk4a0E2QdZl93S4RGJtv1'; //FirebaseAuth.instance.currentUser.uid;
  final String uid = FirebaseAuth.instance.currentUser.uid;
  File _image;
  bool runner = true;

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
      });
    }
  }

  Future _getDataFromDB() async {
    setState(() {
      runner = false;
    });
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    await ref.doc(uid).get().then((snap) {
      var data = snap.data();
      setState(() {
        name = data['name'];
        status = data['status'];
        picUrl = data['photourl'];
        print('$name::::$status::::$picUrl');
        _nameController.text = name;
        _statusController.text = status;
      });
    });
  }

  Future _updateProfile() async {
    if (_image != null) {
      String ext = _image.path.toString().split('.').last;
      final StorageReference fbStorage =
          FirebaseStorage.instance.ref().child('users/$uid.$ext');
      final StorageUploadTask task = fbStorage.putFile(_image);
      await task.onComplete;
      print('upload complete');
      await fbStorage.getDownloadURL().then((url) {
        setState(() {
          picUrl = url;
          CollectionReference ref =
              FirebaseFirestore.instance.collection('users');
          ref.doc(uid).update({
            'name': name,
            'status': status,
            'photourl': picUrl
          }).then((value) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: const Text('Updated!'),
                duration: const Duration(seconds: 3),
                padding: EdgeInsets.only(bottom: 15, left: 15, top: 5)));
          });
        });
      });
    } else {
      CollectionReference ref = FirebaseFirestore.instance.collection('users');
      ref.doc(uid).update({'name': name, 'status': status}).then((value) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: const Text('Updated!'),
            duration: const Duration(seconds: 3),
            padding: EdgeInsets.only(bottom: 15, left: 15, top: 5)));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runner ? _getDataFromDB() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: picUrl == null || name == null || status == null
            ? Container(
                color: primaryColor.withAlpha(90),
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 50.0,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Stack(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () => createPopup(context, picUrl, ''),
                            child: CircleAvatar(
                              backgroundImage: _image == null
                                  ? CachedNetworkImageProvider(picUrl)
                                  : FileImage(_image),
                              radius: MediaQuery.of(context).size.width * 0.25,
                            ),
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
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: TextField(
                        controller: _nameController,
                        onEditingComplete: () {
                          name = _nameController.text;
                          FocusScope.of(context).unfocus();
                        },
                        onSubmitted: (value) {},
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      onPressed: _updateProfile,
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      color: primaryColor,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
