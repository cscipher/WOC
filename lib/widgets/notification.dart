// import 'dart:async';

// import 'package:flutter/material.dart';

// class Item {
//   Item({this.itemId});
//   final String itemId;

//   StreamController<Item> _controller = StreamController<Item>.broadcast();
//   Stream<Item> get onChanged => _controller.stream;

//   String _status;
//   String get status => _status;
//   set status(String value) {
//     _status = value;
//     _controller.add(this);
//   }

//   static final Map<String, Route<void>> routes = <String, Route<void>>{};
//   Route<void> get route {
//     final String routeName = '/detail/$itemId';
//     return routes.putIfAbsent(
//       routeName,
//       () => MaterialPageRoute<void>(
//         settings: RouteSettings(name: routeName),
//         builder: (BuildContext context) => DetailPage(itemId),
//       ),
//     );
//   }
// }


// class FCMnotification extends StatefulWidget {
//   @override
//   FCMnotificationState createState() => FCMnotificationState();
// }

// class FCMnotificationState extends State<FCMnotification> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }