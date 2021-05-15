import 'dart:io';

import 'package:WOC/screens/addStoryPreview.dart';
import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class NewStory extends StatefulWidget {
  @override
  _NewStoryState createState() => _NewStoryState();
}

class _NewStoryState extends State<NewStory> {
  // File _image;

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
            // toolbarWidgetColor: Colors.white,
            // initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
            // title: 'Cropper',
            ));
    if (croppedFile != null) {
      picked = croppedFile;
      // setState(() {
      //   _image = picked;
      // });
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => AddStoryPreview(picked)));
    }
  }

  _addStory() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.015,
                vertical: 2.5),
            child: GestureDetector(
              onTap: () => _imgFromGallery(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: primaryColor)),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text('New Story!'),
      ],
    );
  }
}
