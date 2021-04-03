import 'package:WOC/widgets/chats.dart';
import 'package:WOC/widgets/storyBar.dart';
import 'package:flutter/material.dart';

class HomeChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            // child: StoryBar(),
            height: MediaQuery.of(context).size.height * 0.13,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ChatList(),
            ),
          ),
        ],
      ),
    );
  }
}
