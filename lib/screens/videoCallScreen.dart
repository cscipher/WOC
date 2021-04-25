// import 'package:WOC/themes/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   final RTCVideoRenderer _localRenderer;
//   final RTCVideoRenderer _remoteRenderer;
//   VideoCallScreen(this._localRenderer, this._remoteRenderer);
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   Color k1 = Colors.white;
//   Color k11 = primaryColor;
//   Color k2 = Colors.white;
//   Color k22 = primaryColor;
//   Color k3 = Colors.white;
//   Color k33 = primaryColor;
//   // Color k4 = Colors.white;
//   // Color k44 = primaryColor;
//   List<MediaDeviceInfo> _mediaDevicesList;
//   MediaStream _localStream;
//
//   startLocalCam() async {
//     final Map<String, dynamic> mediaConstraints = {
//       'audio': true,
//       'video': {
//         'mandatory': {
//           'minWidth':
//           '640', // Provide your own width, height and frame rate here
//           'minHeight': '480',
//           'minFrameRate': '30',
//         },
//         'facingMode': 'user',
//         'optional': [],
//       }
//     };
//     try {
//       var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
//       _localStream = stream;
//       widget._localRenderer.srcObject = _localStream;
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   Widget loaderContainer() {
//     return Container(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Waiting for someone to connect...', style: TextStyle(fontSize: 16),),
//           SizedBox(width: 10),
//           SpinKitRing(color: primaryColor, size: 30),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     startLocalCam();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//               child: Stack(
//             children: [
//               Container(
//                 // color: neutralRed,
//                 child: widget._remoteRenderer.renderVideo ? RTCVideoView(
//                   widget._remoteRenderer,
//                 ) : loaderContainer(),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 10, top: 20),
//                 child: Card(
//                   elevation: 5,
//                   // color: neutralOrange,
//                   child: RTCVideoView(
//                     widget._localRenderer,
//                     mirror: true,
//                   ),
//                 ),
//                 width: 120,
//                 height: 184,
//               )
//             ],
//           )),
//           Stack(children: [
//             Container(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.15,
//               decoration: BoxDecoration(boxShadow: [shadow], color: accent3),
//             ),
//             Column(
//               children: [
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // RaisedButton(
//                       //   padding: EdgeInsets.all(20),
//                       //   // splashColor: Colors.white,
//                       //   textColor: k44,
//                       //   shape: CircleBorder(
//                       //       side: BorderSide(color: Colors.white, width: 0)),
//                       //   // iconSize: 40,
//                       //   elevation: 4,
//                       //   child: Icon(
//                       //     Icons.camera_alt,
//                       //     size: 30,
//                       //   ),
//                       //   color: k4,
//                       //   onPressed: () {
//                       //     setState(() {
//                       //       k4 == primaryColor
//                       //           ? k4 = Colors.white
//                       //           : k4 = primaryColor;
//                       //       k44 == primaryColor
//                       //           ? k44 = Colors.white
//                       //           : k44 = primaryColor;
//                       //     });
//                       //   },
//                       // ),
//                       RaisedButton(
//                         padding: EdgeInsets.all(20),
//                         // splashColor: Colors.white,
//                         textColor: k11,
//                         shape: CircleBorder(
//                             side: BorderSide(color: Colors.white, width: 0)),
//                         // iconSize: 40,
//                         elevation: 4,
//                         child: Icon(
//                           Icons.switch_camera_outlined,
//                           size: 30,
//                         ),
//                         color: k1,
//                         onPressed: () {
//                           setState(() {
//                             k1 == primaryColor
//                                 ? k1 = Colors.white
//                                 : k1 = primaryColor;
//                             k11 == primaryColor
//                                 ? k11 = Colors.white
//                                 : k11 = primaryColor;
//                           });
//                         },
//                       ),
//                       // SizedBox(width: 20),
//                       RaisedButton(
//                         padding: EdgeInsets.all(20),
//                         textColor: Colors.white,
//                         shape: CircleBorder(
//                             side: BorderSide(color: neutralRed, width: 0)),
//                         // iconSize: 40,
//                         elevation: 4,
//                         child: Icon(
//                           Icons.call_end,
//                           size: 30,
//                         ),
//                         color: neutralRed,
//                         onPressed: () {},
//                       ),
//                       // SizedBox(width: 20),
//                       RaisedButton(
//                         padding: EdgeInsets.all(20),
//                         textColor: k22,
//                         shape: CircleBorder(
//                             side: BorderSide(color: Colors.white, width: 0)),
//                         // iconSize: 40,
//                         elevation: 4,
//                         child: Icon(
//                           Icons.mic_off,
//                           size: 30,
//                         ),
//                         color: k2,
//                         onPressed: () {
//                           setState(() {
//                             k2 == primaryColor
//                                 ? k2 = Colors.white
//                                 : k2 = primaryColor;
//                             k22 == primaryColor
//                                 ? k22 = Colors.white
//                                 : k22 = primaryColor;
//                           });
//                         },
//                       ),
//                       // SizedBox(width: 20),
//                       RaisedButton(
//                         padding: EdgeInsets.all(20),
//                         textColor: k33,
//                         shape: CircleBorder(
//                             side: BorderSide(color: Colors.white, width: 0)),
//                         // iconSize: 40,
//                         elevation: 4,
//                         child: Icon(
//                           Icons.arrow_forward_ios,
//                           size: 30,
//                         ),
//                         color: k3,
//                         onPressed: () {},
//                       ),
//                     ],
//                     // IconButton(icon: Icon(Icons.),),
//                   ),
//                 )
//               ],
//             )
//           ]),
//         ],
//       ),
//
//     );
//   }
// }
