// import 'package:WOC/data/chatData.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RandomChat extends StatefulWidget {
  String myId;
  IO.Socket socket;
  String roomName;
  List chatData;
  final bool isStandalone;

  RandomChat(
      {this.myId,
      this.socket,
      this.roomName,
      this.chatData,
      this.isStandalone = false});

  @override
  _RandomChatState createState() => _RandomChatState();
}

class _RandomChatState extends State<RandomChat> {
  List chat;
  final TextEditingController _msgControl = TextEditingController();
  String msg;
  ScrollController _scrollController;
  // String ip = 'http://192.168.43.79:8080';
  String ip = 'http://13.127.251.39:8080';
  var countUsers = 0;

  //SocketIo Client instance

  void sendChatData(chatval) {
    print('::::::::::::::;;inititate:::::::::::');
    var mPayload = {
      // 'senderId': myId,
      'message': chatval,
      'id': widget.myId,
      // 'receiverId':rId
    };
    widget.socket
        .emit('chat', {'setRoomName': widget.roomName, 'payload': mPayload});
    if (this.mounted)
      setState(() {
        widget.chatData.add(mPayload);
      });
    scrollToBottom();
  }

  scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // scrollToBottom();
      final bottomOffset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        bottomOffset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  startSockets() {
    //**events
    //on connect
    widget.socket.onConnect((_) {
      if (this.mounted)
        setState(() {
          widget.myId = widget.socket.id;
        });
      print('connect: ' + widget.myId);
    });
    //on disconnect
    widget.socket.onDisconnect((data) {
      if (this.mounted)
        setState(() {
          widget.chatData.clear();
          widget.myId = '';
        });
      print('disconnected..');
    });

    widget.socket.on('roomName', (data) {
      if (this.mounted)
        setState(() {
          widget.roomName = data;
        });
      print('room_name: ' + data);
    });

    widget.socket.on('getCount', (data) {
      if (this.mounted)
        setState(() {
          print('data::::$data');
          countUsers = data;
        });
    });
  }

  sock() {
    // widget.isStandalone ? skt = widget.socket : skt = widget.socket;
    widget.socket.on('chat', (data) {
      var mEncodeJson = jsonEncode(data);
      var getMsg = jsonDecode(mEncodeJson);
      print('MESSAAA:::$getMsg');
      if (this.mounted)
        setState(() {
          widget.chatData.add(getMsg);
        });
      scrollToBottom();
      print('CHAT:::${widget.chatData}');
    });

    if (!widget.isStandalone)
      widget.socket.onDisconnect((data) {
        print('discon!!');
        if (this.mounted)
          setState(() {
            widget.chatData.clear();
          });
        // Navigator.pop(context);
      });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.isStandalone) {
      widget.chatData = [];
      widget.myId = '';
      widget.roomName = '';
      widget.socket = IO.io(ip, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      widget.socket.connect();
      startSockets();
      print('id is:::::::::::::::::::::::::::::${widget.myId}');
    }
    sock();
  }

  Widget loaderContainer() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Waiting for someone to connect...',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(width: 10),
          SpinKitRing(color: primaryColor, size: 30),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stranger!'),
        // title: Text('Stranger!::$countUsers::${widget.myId}'),
        leading: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: widget.isStandalone
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(
                        Icons.exit_to_app,
                        // size: 30,
                      ),
                    )
                  : Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                      // size: 20,
                    ),
              onPressed: () {
                if (widget.isStandalone) {
                  widget.socket.disconnect();
                }
                Navigator.pop(context);
              }),
        ),
        actions: widget.isStandalone
            ? [
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                      // size: 20,
                    ),
                    onPressed: () {
                      //Skip logic
                      widget.socket.disconnect();
                      widget.socket.clearListeners();
                      widget.socket.close();
                      sock();
                    }),
              ]
            : [],
      ),
      body: countUsers % 2 != 0
          ? loaderContainer()
          : Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.12),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment:
                                  widget.chatData[index]['id'] == widget.myId
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: widget.chatData[index]['id'] ==
                                          widget
                                              .myId // this sender denotes to the current Logged in user
                                      ? primaryColor
                                      : primaryColor.withAlpha(50),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  widget.chatData[index]['message'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: widget.chatData[index]['id'] ==
                                              widget
                                                  .myId // this sender denotes to the current Logged in user
                                          ? Colors.white
                                          : accent1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // width: MediaQuery.of(context).size.width * 0.1,
                      );
                    },
                    itemCount: widget.chatData.length,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 90,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                              border: Border.all(color: accent2.withAlpha(60)),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.68,
                                child: TextField(
                                  onChanged: (c) {
                                    if (this.mounted)
                                      setState(() {
                                        msg = c;
                                      });
                                  },
                                  controller: _msgControl,
                                  decoration: InputDecoration(
                                      hintText: "Enter your message",
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                onPressed: _msgControl.text == ''
                                    ? null
                                    : () {
                                        sendChatData(msg);
                                        // sock();
                                        _msgControl.clear();
                                      },
                                icon: Icon(
                                  Icons.send,
                                  color: primaryColor,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
