import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Color k1 = Colors.white;
  Color k11 = primaryColor;
  Color k2 = Colors.white;
  Color k22 = primaryColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Stack(
            children: [
              Container(
                color: neutralRed,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 20),
                child: Card(
                  elevation: 5,
                  color: neutralOrange,
                ),
                width: 120,
                height: 214,
              )
            ],
          )),
          Stack(children: [
            Container(
              child: Card(
                // child: Text('fsdfosd'),
                elevation: 0,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(boxShadow: [shadow]),
            ),
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        // splashColor: Colors.white,
                        textColor: k11,
                        shape: CircleBorder(
                            side: BorderSide(color: Colors.white, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.switch_camera_outlined,
                          size: 30,
                        ),
                        color: k1,
                        onPressed: () {
                          setState(() {
                            k1 == primaryColor
                                ? k1 = Colors.white
                                : k1 = primaryColor;
                            k11 == primaryColor
                                ? k11 = Colors.white
                                : k11 = primaryColor;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        textColor: Colors.white,
                        shape: CircleBorder(
                            side: BorderSide(color: neutralRed, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.call_end,
                          size: 30,
                        ),
                        color: neutralRed,
                        onPressed: () {},
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        textColor: k22,
                        shape: CircleBorder(
                            side: BorderSide(color: Colors.white, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.mic_off,
                          size: 30,
                        ),
                        color: k2,
                        onPressed: () {
                          setState(() {
                            k2 == primaryColor
                                ? k2 = Colors.white
                                : k2 = primaryColor;
                            k22 == primaryColor
                                ? k22 = Colors.white
                                : k22 = primaryColor;
                          });
                        },
                      ),
                    ],
                    // IconButton(icon: Icon(Icons.),),
                  ),
                )
              ],
            )
          ])
        ],
      ),
    );
  }
}
