import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: FlatButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.chat), Text("Chat")],
          ),
        )),
        Expanded(
            child: FlatButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.play_arrow_rounded), Text("Stream!")],
          ),
        )),
        Expanded(
            child: FlatButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.call), Text("Logs")],
          ),
        )),
        Expanded(
            child: FlatButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.settings), Text("Settings")],
          ),
        )),
      ],
    );
  }
}
