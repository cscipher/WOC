import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/newStory.dart';
import 'package:flutter/material.dart';
import '../models/stories_model.dart';
import '../data/storyData.dart';
import 'storyBtn.dart';

class StoryBar extends StatefulWidget {
  final List<Story> stories = allStories;
  // StoryBar({@required this.stories});
  @override
  _StoryBarState createState() => _StoryBarState();
}

class _StoryBarState extends State<StoryBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            NewStory(),
            ListView.builder(
              
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                return Container(
                    child: storyButton(
                        widget.stories[i], widget.stories[i].user.id, context));
              },
              itemCount: 3,
            ),
          ],
        ),
      ),
      // child: ListView(
      //   scrollDirection: Axis.horizontal,
      //   children: [
      //     NewStory(),

      //     // storyButton(widget.stories[0], widget.stories[0].user.id, context),
      //     // storyButton(widget.stories[1], widget.stories[1].user.id, context),
      //     // storyButton(widget.stories[2], widget.stories[2].user.id, context),
      //   ],
      // )
    );
  }
}
