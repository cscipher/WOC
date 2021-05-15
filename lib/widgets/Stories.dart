import 'package:WOC/screens/homeChatList.dart';
import 'package:WOC/screens/home_screen.dart';
import 'package:WOC/screens/temp.dart';
import 'package:WOC/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:story_view/story_view.dart';
import 'package:swipedetector/swipedetector.dart';

class StoryPageView extends StatefulWidget {
  final String id;
  final bool admin;

  StoryPageView({this.id, this.admin = false});

  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  List<StoryItem> stories = [];
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final controller = StoryController();

  getAllStoriesData() async {
    print('id:::::::::::::::::::::::::::::::${widget.id}');
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(widget.id).snapshots().listen((snap) {
      var data = snap.data();
      var storyData = data['storiesData'];
      print('STT::::$storyData');
      int k = 0;
      for (var st in storyData) {
        StoryItem obj = StoryItem.pageImage(
            url: st['url'], controller: controller, caption: st['caption']);
        setState(() {
          stories.add(obj);
          print('STORIES:::::::::::${st[0]}');
        });
      }
      k = 0;
    });
  }

  deleteAlert(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Delete Alert'),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            content: Text(
                'This will delete your last recent story. You wish to continue?'),
            actions: [
              FlatButton(
                  onPressed: _deleteStory,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: neutralRed),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text('Dismiss'))
            ],
          );
        });
  }

  _deleteStory() {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(widget.id).get().then((value) {
      List storyList = value.data()['storiesData'];
      var lst = storyList.removeLast();
      lst = lst['url'].toString();
      // print('lst::::::::::::${lst["url"]}');
      ref.doc(widget.id).update({'storiesData': storyList}).then((value) async {
        StorageReference fbStorage = await FirebaseStorage.instance
            .ref()
            .getStorage()
            .getReferenceFromUrl(lst);
        fbStorage.delete().whenComplete(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (ctx) => HomeScreen(showSnack: 'Story deleted!')));
        });
      });
    });
  }

/*
Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (ctx) => HomeScreen(showSnack: 'Story deleted!')))
                  */

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStoriesData();
  }

  popPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SwipeDetector(
        onSwipeDown: popPage,
        child: Stack(children: [
          StoryView(
            storyItems: stories,
            onComplete: popPage,
            controller: controller,
            inline: false,
            repeat: true,
          ),
          if (widget.admin)
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.08),
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                textColor: accent3,
                color: primaryColor,
                padding: EdgeInsets.all(15),
                shape: CircleBorder(
                    side: BorderSide(color: primaryColor, width: 0)),
                // iconSize: 40,
                elevation: 4,
                child: Icon(Icons.delete),
                onPressed: () => deleteAlert(context),
              ),
            )
        ]),
      ),
    );
  }
}

// import 'package:WOC/data/storyData.dart';
// import 'package:WOC/screens/home_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import '../models/userModel.dart';
// // import 'package:story_view/story_view.dart';
// import 'package:video_player/video_player.dart';
// import '../models/stories_model.dart';
//
// class StoryScreen extends StatefulWidget {
//   final List<Story> stories;
//
//   const StoryScreen({@required this.stories});
//
//   @override
//   _StoryScreenState createState() => _StoryScreenState();
// }
//
// class _StoryScreenState extends State<StoryScreen>
//     with SingleTickerProviderStateMixin {
//   PageController _pageController;
//   AnimationController _animController;
//   VideoPlayerController _videoController;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _animController = AnimationController(vsync: this);
//
//     final firstStory = widget.stories.first;
//     _loadStory(story: firstStory, animateToPage: false);
//
//     _animController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animController.stop();
//         _animController.reset();
//         setState(() {
//           if (_currentIndex + 1 < widget.stories.length) {
//             _currentIndex += 1;
//             _loadStory(story: widget.stories[_currentIndex]);
//           } else {
//             // Out of bounds - loop story
//             // You can also Navigator.of(context).pop() here
//             _currentIndex = 0;
//             _loadStory(story: widget.stories[_currentIndex]);
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Story story = widget.stories[_currentIndex];
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTapDown: (details) => _onTapDown(details, story),
//         child: Stack(
//           children: <Widget>[
//             PageView.builder(
//               controller: _pageController,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: widget.stories.length,
//               itemBuilder: (context, i) {
//                 final Story story = widget.stories[i];
//                 return CachedNetworkImage(
//                   imageUrl: story.url,
//                   fit: BoxFit.cover,
//                 );
//
//                 // switch (story.media) {
//                 //   case MediaType.image:
//                 //     return CachedNetworkImage(
//                 //       imageUrl: story.url,
//                 //       fit: BoxFit.cover,
//                 //     );
//                 //   case MediaType.video:
//                 //     if (_videoController != null &&
//                 //         _videoController.value.initialized) {
//                 //       return FittedBox(
//                 //         fit: BoxFit.cover,
//                 //         child: SizedBox(
//                 //           width: _videoController.value.size.width,
//                 //           height: _videoController.value.size.height,
//                 //           child: VideoPlayer(_videoController),
//                 //         ),
//                 //       );
//                 //     }
//                 // }
//                 return const SizedBox.shrink();
//               },
//             ),
//             Positioned(
//               top: 40.0,
//               left: 10.0,
//               right: 10.0,
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     children: widget.stories
//                         .asMap()
//                         .map((i, e) {
//                           return MapEntry(
//                             i,
//                             AnimatedBar(
//                               animController: _animController,
//                               position: i,
//                               currentIndex: _currentIndex,
//                             ),
//                           );
//                         })
//                         .values
//                         .toList(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 1.5,
//                       vertical: 10.0,
//                     ),
//                     child: UserInfo(user: story.user),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onTapDown(TapDownDetails details, Story story) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double dx = details.globalPosition.dx;
//     if (dx < screenWidth / 3) {
//       setState(() {
//         if (_currentIndex - 1 >= 0) {
//           _currentIndex -= 1;
//           _loadStory(story: widget.stories[_currentIndex]);
//         }
//       });
//     } else if (dx > 2 * screenWidth / 3) {
//       setState(() {
//         if (_currentIndex + 1 < widget.stories.length) {
//           _currentIndex += 1;
//           _loadStory(story: widget.stories[_currentIndex]);
//         } else {
//           // Out of bounds - loop story
//           // You can also Navigator.of(context).pop() here
//           _currentIndex = 0;
//           _loadStory(story: widget.stories[_currentIndex]);
//         }
//       });
//     } else {
//       // if (story.media == MediaType.video) {
//       //   if (_videoController.value.isPlaying) {
//       //     _videoController.pause();
//       //     _animController.stop();
//       //   } else {
//       //     _videoController.play();
//       //     _animController.forward();
//       //   }
//       // }
//       _videoController.play();
//       _animController.forward();
//     }
//   }
//
//   void _loadStory({Story story, bool animateToPage = true}) {
//     _animController.stop();
//     _animController.reset();
//     _animController.duration = Duration(milliseconds: 8000);
//     _animController.forward();
//     // switch (story.media) {
//     //   case MediaType.image:
//     //     _animController.duration = story.duration;
//     //     _animController.forward();
//     //     break;
//     //   case MediaType.video:
//     //     _videoController = null;
//     //     _videoController?.dispose();
//     //     _videoController = VideoPlayerController.network(story.url)
//     //       ..initialize().then((_) {
//     //         setState(() {});
//     //         if (_videoController.value.initialized) {
//     //           _animController.duration = Duration(seconds: 5);
//     //           _videoController.play();
//     //           _animController.forward();
//     //         }
//     //       });
//     //     break;
//     // }
//     if (animateToPage) {
//       _pageController.animateToPage(
//         _currentIndex,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
// }
//
// class AnimatedBar extends StatelessWidget {
//   final AnimationController animController;
//   final int position;
//   final int currentIndex;
//
//   const AnimatedBar({
//     Key key,
//     @required this.animController,
//     @required this.position,
//     @required this.currentIndex,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1.5),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               children: <Widget>[
//                 _buildContainer(
//                   double.infinity,
//                   position < currentIndex
//                       ? Colors.white
//                       : Colors.white.withOpacity(0.5),
//                 ),
//                 position == currentIndex
//                     ? AnimatedBuilder(
//                         animation: animController,
//                         builder: (context, child) {
//                           return _buildContainer(
//                             constraints.maxWidth * animController.value,
//                             Colors.white,
//                           );
//                         },
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Container _buildContainer(double width, Color color) {
//     return Container(
//       height: 5.0,
//       width: width,
//       decoration: BoxDecoration(
//         color: color,
//         border: Border.all(
//           color: Colors.black26,
//           width: 0.8,
//         ),
//         borderRadius: BorderRadius.circular(3.0),
//       ),
//     );
//   }
// }
//
// class UserInfo extends StatelessWidget {
//   final User user;
//
//   const UserInfo({
//     Key key,
//     @required this.user,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         CircleAvatar(
//           radius: 20.0,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: CachedNetworkImageProvider(
//             user.profileImageUrl,
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Expanded(
//           child: Text(
//             user.name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.close,
//             size: 30.0,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomeScreen())),
//           // onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen())
//         ),
//       ],
//     );
//   }
// }
