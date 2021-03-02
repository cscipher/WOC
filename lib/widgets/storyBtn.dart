import 'package:flutter/material.dart';
import '../models/stories_model.dart';
import '../themes/colors.dart';

Widget storyButton(Story story, BuildContext context) {
  return LayoutBuilder(
    builder: (ctx, cnstrnt) {
      print(cnstrnt.maxHeight * 0.3);
      return Container(
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: cnstrnt.maxWidth * 0.8,
                  height: cnstrnt.maxHeight * 0.5,
                  // width: MediaQuery.of(context).size.width * 0.15,
                  // height: MediaQuery.of(context).size.height * 0.06,
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
            Text(story.user.name.split(' ')[0])
          ],
        ),
      );
    },
  );
}
