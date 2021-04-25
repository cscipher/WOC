import 'dart:convert';
import 'dart:core';
import 'dart:math' as math;
import 'dart:io';
import 'package:WOC/models/chatsModel.dart';
import 'package:WOC/screens/randomChat.dart';
import 'package:WOC/screens/videoCallScreen.dart';
import 'package:WOC/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// String ip = 'http://192.168.43.79:8080';
String ip = 'http://13.127.251.39:8080';

/*
 * webrtc video
 */
class GetUserMediaSample extends StatefulWidget {
  static String tag = 'get_usermedia_sample';

  @override
  _GetUserMediaSampleState createState() => _GetUserMediaSampleState();
}

class _GetUserMediaSampleState extends State<GetUserMediaSample> {
  List chatData = [];
  //check peer connection
  bool isConn = false;

  //**SOCKETS VAR
  var iamInitiator = false;
  IO.Socket socket;

  //room name
  var roomName = 'n/a';

  //my id
  String myId;
  var answerSDP = 'n/a';

  //receiver uid
  var rId = '';

  //**SOCKETS VAR

  //initialize
  var dataOffer = 'n/a';

  bool _offer = false;
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  final sdpController = TextEditingController();
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder _mediaRecorder;
  int count = 0;

  bool get _isRec => _mediaRecorder != null;

  List<MediaDeviceInfo> _mediaDevicesList;

  Color k1 = Colors.white;
  Color k11 = primaryColor;
  Color k2 = Colors.white;
  Color k22 = primaryColor;
  Color k3 = Colors.white;
  Color k33 = primaryColor;
  Color k4 = Colors.white;
  Color k44 = primaryColor;
  bool connected = false;
  bool imHere;

  @override
  void initState() {
    myId = '';
    setState(() {
      imHere = true;
    });
    super.initState();
    initRenderers();
    _makeCall();
  }

  // @override
  // void deactivate() {
  //   super.deactivate();
  //   if (_inCalling) {
  //     _hangUp();
  //   }
  //   _localRenderer.dispose();
  //   _remoteRenderer.dispose();
  // }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _makeCall() async {
    // var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      if (_localStream == null) {
        var stream =
            await navigator.mediaDevices.getUserMedia(mediaConstraints);
        _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
        _localStream = stream;
        _localRenderer.srcObject = _localStream;
      }
    } catch (e) {
      print(e.toString());
    }
    // _remoteRenderer.initialize();
    if (!mounted) return;

    setState(() {
      _inCalling = true;

      //start peer
      _createPeerConnection().then((pc) {
        _peerConnection = pc;

        //start socket
        mSocket();
      });
      //start peer
    });
  }

  void _hangUp() async {
    //initialize for recall
    iniForRecall();

    try {
      // await _localStream?.dispose();
      setState(() {
        // _localRenderer.srcObject = null;
        _inCalling = false;
        isConn = false;
      });
    } catch (e) {
      print(e.toString());
    }
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

  disposeRenderers() {
    // await _localStream?.dispose();
    _localStream.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    if (socket != null) {
      socket.disconnect();
      socket.clearListeners();
      socket.close();
    }
    if (_peerConnection != null) {
      // _peerConnection.removeStream(_localStream);
      // _localStream.getTracks().forEach((element) => element.stop());
      _peerConnection.close().then((value) => Navigator.pop(context));
    }
  }

  onChatScreen() {
    // sendChatData('dfhslfjsdhlfalfj!!!!!!');
    setState(() {
      imHere = false;
    });
    print('sendingdata:::$myId,:::$roomName,:::$chatData');
    setState(() {
      count = 0;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => RandomChat(
                myId: myId,
                socket: socket,
                roomName: roomName,
                chatData: chatData)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Container(
                // color: neutralRed,
                child: _remoteRenderer.srcObject != null
                    ? RTCVideoView(
                        _remoteRenderer,
                      )
                    : loaderContainer(),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 20),
                child: Card(
                  elevation: 5,
                  // color: neutralOrange,
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: true,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.165,
              )
            ],
          )),
          Stack(children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(boxShadow: [shadow], color: accent3),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        // splashColor: Colors.white,
                        textColor: k44,
                        shape: CircleBorder(
                            side: BorderSide(color: Colors.white, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(
                            Icons.exit_to_app,
                            size: 30,
                          ),
                        ),

                        color: k4,
                        onPressed: disposeRenderers,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        textColor: k22,
                        shape: CircleBorder(
                            side: BorderSide(color: Colors.white, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.mic_off,
                          size: 30,
                        ),
                        color: k2,
                        onPressed: () {
                          // mute logic here...
                          setState(() {
                            _localRenderer != null
                                ? _localRenderer.muted = !_localRenderer.muted
                                : null;
                            k2 == primaryColor
                                ? k2 = Colors.white
                                : k2 = primaryColor;
                            k22 == primaryColor
                                ? k22 = Colors.white
                                : k22 = primaryColor;
                          });
                        },
                      ),
                      // SizedBox(width: 20),
                      Stack(
                        children: <Widget>[
                          RaisedButton(
                            padding: EdgeInsets.all(20),
                            textColor: k11,
                            shape: CircleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 0)),
                            // iconSize: 40,
                            elevation: 4,
                            child: Icon(
                              Icons.chat_bubble_outlined,
                              size: 30,
                            ),
                            color: k1,
                            onPressed: _remoteRenderer.srcObject != null
                                ? onChatScreen
                                : null,
                          ),
                          count > 0
                              ? Positioned(
                                  right: 11,
                                  // top: 4,
                                  child: new Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 25,
                                      minHeight: 25,
                                    ),
                                    child: Center(
                                      child: Text(
                                        (count).toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              : new Container()
                        ],
                      ),

                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        textColor: k33,
                        shape: CircleBorder(
                            side: BorderSide(color: Colors.white, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                        ),
                        color: k3,
                        onPressed: () {
                          _hangUp();
                          _makeCall();
                        },
                      ),
                    ],
                    // IconButton(icon: Icon(Icons.),),
                  ),
                )
              ],
            )
          ]),
        ],
      ),
    );
  }

  //**Webrtc
  //here we create offer
  void _createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp);
    dataOffer = json.encode(session);
    print(dataOffer);
    _offer = true;

    _peerConnection.setLocalDescription(description);

    //**SOCKET
    //send offer
    sendOfferSOCKET(dataOffer);
    // sendChatData('ddasdasda!!');
  }

  //here we create answer
  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp);
    print(json.encode(session));
    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    _peerConnection.setLocalDescription(description);

    //**SOCKET
    //set answer sdp
    answerSDP = json.encode(session);
    sendAnswerSOCKET(answerSDP);
  }

  //set remote description
  void _setRemoteDescription(jsonString) async {
    //String jsonString = sdpController.text;
    //dynamic session = await jsonDecode('$jsonString');

    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    // RTCSessionDescription description =
    //     new RTCSessionDescription(session['sdp'], session['type']);
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);

    //**SOCKETS
    //our desc is set, now create answer
    _createAnswer();
  }

  //set remote description
  void _setRemoteDescriptionAndCandidate(jsonString) async {
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    //  RTCSessionDescription description =
    //    new RTCSessionDescription(session['sdp'], session['type']);
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  //here we add candidate
  void _addCandidate(jsonString) async {
    // String jsonString = sdpController.text;

    dynamic session = await jsonDecode('$jsonString');
    print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection.addCandidate(candidate);
  }

  //CREATE PEER CONNECTION
  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},

        // turn server configuration example.
        // {
        //   'url': 'turn:123.45.67.89:3478',
        //   'username': 'change_to_real_user',
        //   'credential': 'change_to_real_secret'
        // },
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    //_localStream = await _getUserMedia();
    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    // if (pc != null) print(pc);
    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        var mCandidate = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        });
        print(mCandidate);

        //**SOCKET
        //send answer
        if (iamInitiator == false) {
          sendCandidateSOCKET(mCandidate);
        }
      }
    };

    pc.onIceConnectionState = (e) {
      print('conn state:::$e');
      //**Both peers connected
      // print('RTC connected');
      //now reload widgets
      setState(() {
        isConn = true;
      });
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      rId = stream.id;
      _remoteRenderer.srcObject = stream;
    };

    pc.onConnectionState = (getConnState) {
      //on disconnect
      if (RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ==
          getConnState) {
        //chat is ended
        //remove remote peer video
        setState(() {
          _remoteRenderer.srcObject = null;
          // _remoteRenderer.dispose();
        });
        // _hangUp();
        // _makeCall();
      }
    };

    return pc;
  }

  //**Webrtc

  // void sendChatData(chatData) {
  //   print('::::::::::::::;;inititate:::::::::::');
  //   var mPayload = {
  //     // 'senderId': myId,
  //     'message': chatData,
  //     'id': myId,
  //     // 'receiverId':rId
  //   };
  //   socket.emit('chat', {'setRoomName': roomName, 'payload': mPayload});
  // }

  //**Sockets
  void mSocket() {
    //http://192.168.1.13:3000
    socket = IO.io(ip, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    //**events
    //on connect
    socket.onConnect((_) {
      if (this.mounted)
        setState(() {
          myId = socket.id;
        });
      print('connect: ' + myId);
    });
    //on disconnect
    socket.onDisconnect((data) {
      if (this.mounted)
        setState(() {
          _remoteRenderer.srcObject = null;
          chatData.clear();
          myId = '';
        });
      print('disconnected..');
    });

    //receive room name
    socket.on('roomName', (data) {
      if (this.mounted)
        setState(() {
          roomName = data;
        });
      print('room_name: ' + data);
    });

    // ChatData getting from server
    socket.on('chat', (data) {
      var mEncodeJson = jsonEncode(data);
      var getMsg = jsonDecode(mEncodeJson);
      print('MESSAAA:::$getMsg');
      if (this.mounted)
        setState(() {
          chatData.add(getMsg);
          count++;
        });
      print('CHAT:::$chatData');
    });
    //receive msg
    socket.on('msg', (data) {
      var mEncodeJson = jsonEncode(data);
      var getMsg = jsonDecode(mEncodeJson);

      //**check payload type
      //offer
      if (getMsg['type'] == 'offer') {
        print('offer: ' + getMsg['message']);
        //set description by adding offer
        _setRemoteDescription(getMsg['message']);
      }

      //answer
      if (getMsg['type'] == 'answer') {
        print('answer: ' + getMsg['message']);
        //print( 'candidate' + getMsg['candidate'] );
        //set description by adding answer, and add candidate
        _setRemoteDescriptionAndCandidate(getMsg['message']);
      }

      //candidate
      if (getMsg['type'] == 'candidate') {
        print('candidate' + getMsg['message']);
        //set description by adding answer, and add candidate
        _addCandidate(getMsg['message']);
      }
    });

    //only creator of room is receive true
    socket.on('toRoomCreator', (data) {
      iamInitiator = true;
      print("Someone is joined please start chat");

      //**Here we start signaling
      //create offer
      _createOffer();
    });
  }

  //socket functions
  void sendOfferSOCKET(getOfferData) {
    var mPayload = {
      'type': 'offer',
      // 'senderId': myId,
      'message': getOfferData
    };
    socket.emit('msg', {'setRoomName': roomName, 'payload': mPayload});
  }

  void sendAnswerSOCKET(getAnswerData) {
    var mPayload = {
      'type': 'answer',
      // 'senderId': myId,
      'message': getAnswerData,
    };
    socket.emit('msg', {'setRoomName': roomName, 'payload': mPayload});
  }

  void sendCandidateSOCKET(getCandidateData) {
    var mPayload = {
      'type': 'candidate',
      // 'senderId': myId,
      'message': getCandidateData,
    };
    socket.emit('msg', {'setRoomName': roomName, 'payload': mPayload});
  }

  //**Sockets

  //init for recall
  void iniForRecall() {
    //on hang up close peer conn
    _peerConnection.close();
    // setState(() {
    //   _remoteRenderer.srcObject = null;
    // });
    //dispose
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();

    //close socket
    socket.disconnect();
    socket.clearListeners();
    socket.close();

    //**Initialize all variables
    //init rendrers
    // initRenderers();
    _remoteRenderer.initialize();
    //**SOCKETS VAR
    iamInitiator = false;
    //room name
    roomName = 'n/a';
    //my id
    answerSDP = 'n/a';
    //**SOCKETS VAR

    //initialize
    dataOffer = 'n/a';

    _offer = false;
    _inCalling = false;
    _isTorchOn = false;
  }
}
