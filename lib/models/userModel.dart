import 'package:flutter/material.dart';

class User {
  final String name;
  final int phoneNum;
  final String id;
  final String profileImageUrl;
  final List<String> chatUsers;

  User(
      {@required this.name,
      this.phoneNum,
      this.id,
      @required this.profileImageUrl,
      this.chatUsers});
}
