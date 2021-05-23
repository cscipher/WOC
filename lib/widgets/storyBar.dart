import 'package:shimmer/shimmer.dart';
import 'package:WOC/data/databasehelper.dart';
import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/Stories.dart';
import 'package:WOC/widgets/newStory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import '../models/stories_model.dart';
import 'storyBtn.dart';

class StoryBar extends StatefulWidget {
  // StoryBar({@required this.stories});
  @override
  _StoryBarState createState() => _StoryBarState();
}

class _StoryBarState extends State<StoryBar> {
  final List stories = [];
  List storyContacts = [];
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final controller = StoryController();
  String pic = '', name = '';
  List selfStories = [];
  List allContactIds = [];

  getUserBtns() async {
    var dbData = await DatabaseHelper.db.queryAll();
    for (var lc in dbData) {
      allContactIds.add({'id': lc['id'], 'localName': lc['contactNames']});
    }

    // allContactIds.sort((a, b) => a['localName'].compareTo(b['localName']));

    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    for (var id in allContactIds) {
      // print('id:::${id.toString()}');
      ref.doc(id['id']).get().then((snap) {
        var data = snap.data();
        print('data:::::$data');
        List storyArray = data['storiesData'];
        if (storyArray.isNotEmpty) {
          setState(() {
            storyContacts.add({
              'name': id['localName'],
              'id': id['id'],
              'photourl': data['photourl']
            });
          });
          print(storyContacts);
        }
      });
    }
    print('st:::$storyContacts');
  }

  getInfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((value) {
      setState(() {
        pic = value.data()['photourl'];
        name = 'Your Story';
        selfStories = value.data()['storiesData'];
      });
    });
  }

  Widget yourStory() {
    return Container(
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) {
              return StoryPageView(id: uid, admin: true);
            }), (route) => false);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.015,
                vertical: 2.5),
            child: Container(
              // width: cnstrnt.maxWidth * 0.8,
              // height: cnstrnt.maxHeight * 0.5,
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              // height: 20,
              // width: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: primaryColor)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(pic),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(name),
      ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
    if (allContactIds.isEmpty) getUserBtns();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              NewStory(),
              if (selfStories != null && selfStories.isNotEmpty) yourStory(),
              ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: storyContacts.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      child: storyButton(storyContacts[i], context),
                    );
                  })
            ],
          ),
        )
        /*
        storyContacts.isEmpty
            ? Shimmer.fromColors(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        minRadius: 30,
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                ),
                baseColor: accent4,
                highlightColor: primaryColor)
            : 
        */
        );
  }
}
