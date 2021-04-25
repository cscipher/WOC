import 'package:WOC/models/userModel.dart';
import 'package:flutter/material.dart';

enum MediaType { image, video }

class Story {
  final String url;
  // final MediaType media;
  // final Duration duration;
  final User user;

  Story(
      {@required this.url,
      // @required this.duration,
      // @required this.media,
      @required this.user});
}
