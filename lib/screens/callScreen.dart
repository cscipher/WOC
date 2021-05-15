import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
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
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25,
                  vertical: MediaQuery.of(context).size.width * 0.50),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://picsum.photos/200'),
                    radius: MediaQuery.of(context).size.width * 0.24,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cipher Codes',
                    style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '04:34',
                    style: TextStyle(
                        fontSize: 14,
                        color: accent2,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ),
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
                          Icons.volume_up,
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
