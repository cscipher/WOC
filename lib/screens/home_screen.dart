import 'package:firebase_auth/firebase_auth.dart';
import 'package:WOC/data/storyData.dart';
import 'package:WOC/screens/callLogs.dart';
import 'package:WOC/screens/homeChatList.dart';
import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/storyBar.dart';
import '../widgets/BottomBar.dart';
import '../widgets/Stories.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../widgets/chats.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navItem = 0;
  String uid;

  Widget showScreen() {
    if (navItem == 0) return HomeChatList();
    if (navItem == 1) return Scaffold();
    if (navItem == 2)
      return Scaffold(
        body: Text(uid),
      );
    if (navItem == 3) return CallLogs();
    if (navItem == 4) return Scaffold();
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null)
      uid = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text('PROJECT-Y'),
    );
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: ConvexAppBar(
        elevation: 5,
        height: 60,
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        color: accent2,
        curveSize: 100,
        activeColor: primaryColor,
        items: [
          TabItem(
            icon: Icons.chat,
            title: 'Chat',
          ),
          TabItem(icon: Icons.verified_user, title: 'Profile'),
          TabItem(icon: FontAwesomeIcons.solidPlayCircle),
          TabItem(icon: Icons.call, title: 'Logs'),
          TabItem(icon: Icons.settings, title: 'Settings'),
        ],
        initialActiveIndex: 0,
        onTap: (int i) {
          setState(() {
            navItem = i;
          });
        },
      ),
      body: showScreen(),
    );
  }
}
