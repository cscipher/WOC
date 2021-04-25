import 'package:WOC/screens/contactsList.dart';
import 'package:WOC/screens/randomVideoCallScreen.dart';
import 'package:WOC/screens/reg_screen.dart';
import 'package:WOC/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int nav;
  final String showSnack;
  HomeScreen({this.nav = 0, this.showSnack = 'ffff'});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid;

  logout() {
    setState(() {
      FirebaseAuth.instance.signOut();
      print(FirebaseAuth.instance.currentUser.uid);
    });
  }

  Widget showScreen() {
    if (widget.nav == 0) return HomeChatList();
    if (widget.nav == 1) return ContactsList();
    if (widget.nav == 2) return RandomVideoCallScreen();
    if (widget.nav == 3) return CallLogs();
    if (widget.nav == 4) return Settings();
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
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: logout,
        )
      ],
    );
    return FirebaseAuth.instance.currentUser != null
        ? Scaffold(
            appBar: widget.nav == 0 ? appBar : null,
            bottomNavigationBar: ConvexAppBar(
              elevation: 5,
              height: 60,
              style: TabStyle.fixedCircle,
              backgroundColor: Colors.white,
              color: accent2,
              curveSize: 100,
              activeColor: primaryColor,
              items: [
                TabItem(icon: Icons.chat, title: 'Chat'),
                TabItem(icon: FontAwesomeIcons.comment, title: 'New Chat'),
                TabItem(icon: FontAwesomeIcons.solidPlayCircle),
                TabItem(icon: Icons.call, title: 'Logs'),
                TabItem(icon: Icons.settings, title: 'Settings'),
              ],
              initialActiveIndex: 0,
              onTap: (int i) {
                setState(() {
                  widget.nav = i;
                });
              },
            ),
            body: showScreen(),
          )
        : RegScreen();
  }
}
