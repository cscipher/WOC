import 'package:flutter/material.dart';

class ChatContactModel {
  final String name;
  final String uid;
  final String recentMsg;
  final String timestamp;
  final String photoUrl;
  final String status;

  ChatContactModel(
      {@required this.name,
      @required this.uid,
      this.recentMsg,
      this.timestamp,
      this.photoUrl,
      this.status});
}
