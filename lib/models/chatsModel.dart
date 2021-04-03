import 'package:flutter/material.dart';

class ChatModel {
  final String message;
  final String senderId;
  final String recieverId;
  final timeStamp;

  ChatModel(
      {@required this.message,
      @required this.recieverId,
      @required this.senderId,
      this.timeStamp});
}
