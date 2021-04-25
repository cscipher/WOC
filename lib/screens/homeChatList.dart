import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/chats.dart';
import 'package:WOC/widgets/storyBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: StoryBar(),
          color: Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.13,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.white,
            child: ChatList(),
          ),
        ),
      ],
    );
  }
}
