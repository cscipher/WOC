import 'package:flutter/material.dart';

class User {
  final String name;
  final int phoneNum;
  final String authId;
  final String profileImageUrl;
  

  User(
      {@required this.name,
       this.phoneNum,
       this.authId,
      @required this.profileImageUrl});
}
