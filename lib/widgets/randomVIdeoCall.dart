import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:WOC/screens/videoCallScreen.dart';
import 'package:WOC/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/*
 * webrtc video
 */
class GetUserMediaSample extends StatefulWidget {
  static String tag = 'get_usermedia_sample';

  @override
  _GetUserMediaSampleState createState() => _GetUserMediaSampleState();
}

class _GetUserMediaSampleState extends State<GetUserMediaSample> {
  //**SOCKETS VAR
  var iamInitiator = false;
  IO.Socket socket;
  //room name
  var roomName = 'n/a';
  //my id
  var myId = 'n/a';
  var answerSDP = 'n/a';
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
  bool get _isRec => _mediaRecorder != null;

  List<MediaDeviceInfo> _mediaDevicesList;

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_inCalling) {
      _hangUp();
    }
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _makeCall() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
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
      await _localStream?.dispose();
      _localRenderer.srcObject = null;
      setState(() {
        _inCalling = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // return VideoCallScreen(_localRenderer, _remoteRenderer);
    Color k1 = Colors.white;
    Color k11 = primaryColor;
    Color k2 = Colors.white;
    Color k22 = primaryColor;
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Stack(
            children: [
              Container(
                // color: neutralRed,
                child: RTCVideoView(
                  _remoteRenderer,
                ),
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
                width: 120,
                height: 214,
              )
            ],
          )),
          Stack(children: [
            Container(
              child: Card(
                // child: Text('fsdfosd'),
                elevation: 0,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(boxShadow: [shadow]),
            ),
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        // splashColor: Colors.white,
                        textColor: k11,
                        shape: CircleBorder(
                            side: BorderSide(color: Colors.white, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.switch_camera_outlined,
                          size: 30,
                        ),
                        color: k1,
                        onPressed: () {
                          setState(() {
                            k1 == primaryColor
                                ? k1 = Colors.white
                                : k1 = primaryColor;
                            k11 == primaryColor
                                ? k11 = Colors.white
                                : k11 = primaryColor;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        padding: EdgeInsets.all(20),
                        textColor: Colors.white,
                        shape: CircleBorder(
                            side: BorderSide(color: neutralRed, width: 0)),
                        // iconSize: 40,
                        elevation: 4,
                        child: Icon(
                          Icons.call_end,
                          size: 30,
                        ),
                        color: neutralRed,
                        onPressed: () {},
                      ),
                      SizedBox(width: 20),
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
                          setState(() {
                            k2 == primaryColor
                                ? k2 = Colors.white
                                : k2 = primaryColor;
                            k22 == primaryColor
                                ? k22 = Colors.white
                                : k22 = primaryColor;
                          });
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
      floatingActionButton: FloatingActionButton(
        onPressed: _inCalling ? _hangUp : _makeCall,
        tooltip: _inCalling ? 'Hangup' : 'Call',
        child: Icon(_inCalling ? Icons.call_end : Icons.phone),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Video Calling'),
    //     actions: _inCalling ? <Widget>[] : nuemll,
    //   ),

    //   body: Container(
    //       child: Column(children: [
    //     // videoRenderers(),
    //     videoRender()
    //   ])),

    //   //Make call and hang btn
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _inCalling ? _hangUp : _makeCall,
    //     tooltip: _inCalling ? 'Hangup' : 'Call',
    //     child: Icon(_inCalling ? Icons.call_end : Icons.phone),
    //   ),
    // );
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
        {
          'url': 'turn:123.45.67.89:3478',
          'username': 'change_to_real_user',
          'credential': 'change_to_real_secret'
        },
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
      print(e);
      //**Both peers connected
      print('RTC connected');
      //now reload widgets
      setState(() {});
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      _remoteRenderer.srcObject = stream;
    };

    return pc;
  }
  //**Webrtc

  //**Video rendrer
  SizedBox videoRenderers() => SizedBox(
      height: 300,
      child: Row(children: [
        Flexible(
          child: new Container(
              key: new Key("local"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(_localRenderer, mirror: true)),
        ),
        Flexible(
          child: new Container(
              key: new Key("remote"),
              margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: new BoxDecoration(color: Colors.black),
              child: new RTCVideoView(_remoteRenderer)),
        )
      ]));
  //**Video rendrer

  //**Sockets
  void mSocket() {
    //http://192.168.1.13:3000
    socket = IO.io('http://192.168.1.13:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    //**events
    //on connect
    socket.onConnect((_) {
      myId = socket.id;
      print('connect: ' + myId);
    });
    //on disconnect
    socket.onDisconnect((data) {
      print('disconnected..');
    });

    //receive room name
    socket.on('roomName', (data) {
      roomName = data;
      print('room_name: ' + data);
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
    //dispose
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    //close socket
    socket.clearListeners();
    socket.close();

    //**Initialize all variables
    //init rendrers
    initRenderers();
    //**SOCKETS VAR
    iamInitiator = false;
    //room name
    roomName = 'n/a';
    //my id
    myId = 'n/a';
    answerSDP = 'n/a';
    //**SOCKETS VAR

    //initialize
    dataOffer = 'n/a';

    _offer = false;
    _inCalling = false;
    _isTorchOn = false;
  }
}
