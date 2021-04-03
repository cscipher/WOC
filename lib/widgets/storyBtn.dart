import 'package:WOC/widgets/Stories.dart';
import 'package:flutter/material.dart';
import '../models/stories_model.dart';
import '../themes/colors.dart';

Widget storyButton(Story story, String uid, BuildContext context) {
  return Container(
    child: Column(children: [
      InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
            return StoryScreen();
          }), (route) => false);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // width: cnstrnt.maxWidth * 0.8,
            // height: cnstrnt.maxHeight * 0.5,
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: primaryColor)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(story.url), fit: BoxFit.cover)),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 6,
      ),
      Text(story.user.name.split(' ')[0]),
    ]),
  );
}
