import 'package:WOC/screens/addStoryPreview.dart';
import 'package:WOC/screens/profileSet.dart';
import 'package:WOC/screens/randomChat.dart';
import 'package:WOC/screens/randomVideoCallScreen.dart';
import 'package:WOC/screens/reg_screen.dart';
import 'package:WOC/screens/videoCallScreen.dart';
import 'package:WOC/widgets/otpinput.dart';
import 'package:WOC/widgets/randomVIdeoCall.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './themes/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String uid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SplashScreen(true);
            } else {
              return SplashScreen(false);
            }
          },
        ),

        // home: RandomChat('abc','xyz'),
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
        ));
  }
}
