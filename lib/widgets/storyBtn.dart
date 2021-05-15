import 'package:WOC/widgets/Stories.dart';
import 'package:flutter/material.dart';
import '../models/stories_model.dart';
import '../themes/colors.dart';

Widget storyButton(var storyCntct, BuildContext context) {
  return true //storyCntct != null
      ? Container(
          child: Column(children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_) {
                  print("id::::${storyCntct['id']}");
                  return StoryPageView(id: storyCntct['id']);
                }), (route) => false);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.015,
                    vertical: 2.5),
                child: Container(
                  // width: cnstrnt.maxWidth * 0.8,
                  // height: cnstrnt.maxHeight * 0.5,
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: primaryColor)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image: NetworkImage(storyCntct['photourl']),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(storyCntct['name'].split(' ')[0]),
          ]),
        )
      : Container();
}
