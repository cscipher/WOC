import 'package:WOC/screens/randomChat.dart';
import 'package:WOC/screens/videoCallScreen.dart';
import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/randomVIdeoCall.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RandomVideoCallScreen extends StatefulWidget {
  @override
  _RandomVideoCallScreenState createState() => _RandomVideoCallScreenState();
}

class _RandomVideoCallScreenState extends State<RandomVideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    var MQ = MediaQuery.of(context).size;
    return Container(
        color: accent3,
        child: Column(
          children: [
            Container(
              // height: MQ.height * 0.35,
              margin: EdgeInsets.symmetric(vertical: MQ.height * 0.1),
              width: MQ.width * 0.8,
              child: Text(
                "Let's Connect to Random Faces! :)",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MQ.height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.all(15),
                    // splashColor: Colors.white,
                    textColor: accent3,
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.white, width: 0)),
                    // iconSize: 40,
                    elevation: 4,
                    child: Text(
                      '💬',
                      style: TextStyle(fontSize: 24),
                    ),

                    color: primaryColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RandomChat(
                              isStandalone: true,
                            ),
                          ));
                    },
                  ),
                  Text(
                    'OR',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(15),
                    // splashColor: Colors.white,
                    textColor: accent3,
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.white, width: 0)),
                    // iconSize: 40,
                    elevation: 4,
                    child: Text(
                      '🎥',
                      style: TextStyle(fontSize: 24),
                    ),

                    color: primaryColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetUserMediaSample(),
                          ));
                    },
                  ),
                ],
              ),
            )
            // Text('Video Calling?'),
            // Padding(
            //   padding: EdgeInsets.only(bottom: MQ.height * 0.05, top: 10),
            //   child: ButtonTheme(
            //     minWidth: MQ.width * 0.3,
            //     height: 60,
            //     child: RaisedButton(
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => GetUserMediaSample(),
            //             ));
            //       },
            //       child: Text(
            //         'Start Here! 🚀',
            //         style: TextStyle(fontSize: 25),
            //       ),
            //       textColor: accent3,
            //       color: primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)),
            //     ),
            //   ),
            // ),
            ,
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                // color: neutralOrange,
                child: Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_cxxm75em.json',
                    fit: BoxFit.cover),
              ),
            )
          ],
        ));
  }
}
