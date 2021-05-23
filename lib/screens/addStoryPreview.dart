import 'dart:io';

import 'package:WOC/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddStoryPreview extends StatefulWidget {
  File image;
  AddStoryPreview(this.image);

  @override
  _AddStoryPreviewState createState() => _AddStoryPreviewState();
}

class _AddStoryPreviewState extends State<AddStoryPreview> {
  final TextEditingController _controller = TextEditingController();
  var quote;
  bool tapped = false;
  final String uid = FirebaseAuth.instance.currentUser.uid;

  uploadStory() async {
    setState(() {
      tapped = true;
    });
    String ext = widget.image.path.toString().split('.').last;
    print(ext);
    var imageName = widget.image.path.toString().split('.');
    imageName = imageName[imageName.length - 2].split('/');
    print(imageName.last);

    if (widget.image != null) {
      final StorageReference fbStorage = FirebaseStorage.instance
          .ref()
          .child('stories/$uid/${imageName.last}.$ext');
      final StorageUploadTask task = fbStorage.putFile(widget.image);
      await task.onComplete.then((value) {
        print('upload complete');
        fbStorage.getDownloadURL().then((url) {
          setState(() {
            print('url::$url');
            CollectionReference ref =
                FirebaseFirestore.instance.collection('users');
            ref.doc(uid).get().then((value) {
              List storyArray = value.data()['storiesData'];
              if (storyArray != null && storyArray.isNotEmpty) {
                storyArray.add({'url': url, 'caption': quote ?? ''});
              } else {
                storyArray = [
                  {'url': url, 'caption': quote ?? ''}
                ];
              }
              ref.doc(uid).update({'storiesData': storyArray}).then((value) {
                print('success!');
                Navigator.pop(context);
                tapped = false;
              });
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return tapped
        ? SpinKitRing(
            color: Colors.grey,
            size: 60.0,
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                'Story Preview',
                style: TextStyle(color: accent4, fontWeight: FontWeight.normal),
              ),
              backgroundColor: Colors.black12,
              centerTitle: false,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.send,
                color: accent2,
              ),
              backgroundColor: accent3,
              onPressed: uploadStory,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // height: mq.width,
                      child: Image(
                        // image: NetworkImage('https://picsum.photos/500'),
                        image: FileImage(widget.image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.10,
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: mq.height * 0.06,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: accent4),
                      onEditingComplete: () {
                        quote = _controller.text;
                        FocusScope.of(context).unfocus();
                      },
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusColor: accent4.withOpacity(0.4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.10,
                  ),
                ],
              ),
            ),
          );
  }
}
