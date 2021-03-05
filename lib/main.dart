import 'package:WOC/data/storyData.dart';
import 'package:WOC/screens/callLogs.dart';
import 'package:WOC/screens/callScreen.dart';
import 'package:WOC/screens/chatPage.dart';
import 'package:WOC/screens/home_screen.dart';
import 'package:WOC/screens/profileSet.dart';
import 'package:WOC/screens/videoCallScreen.dart';
import 'package:WOC/widgets/Stories.dart';
import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './themes/colors.dart';
import './screens/reg_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: VideoCallScreen(
            // stories: allStories,
            ),
        theme: ThemeData(
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0,
              centerTitle: true,
              textTheme: TextTheme(
                  headline6: TextStyle(
                      color: accent1,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
          // textTheme: TextTheme(
          //   bodyText1: TextStyle(fontFamily: 'Roboto'),
          //   caption: TextStyle(fontFamily: 'Roboto'),
          // )),
        ));
  }
}
