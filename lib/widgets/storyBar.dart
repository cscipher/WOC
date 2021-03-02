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
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            storyButton(widget.stories[0], context),
            storyButton(widget.stories[1], context),
            storyButton(widget.stories[2], context),
            storyButton(widget.stories[0], context),
            storyButton(widget.stories[1], context),
            storyButton(widget.stories[2], context),
            storyButton(widget.stories[0], context),
            storyButton(widget.stories[1], context),
            storyButton(widget.stories[2], context),
          ],
        ));
  }
}
