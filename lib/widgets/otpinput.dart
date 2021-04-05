import 'package:WOC/screens/profileSet.dart';
import 'package:WOC/screens/reg_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../themes/colors.dart';
import '../screens/home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatefulWidget {
  final String phoneNum;

  const OtpInput({Key key, @required this.phoneNum}) : super(key: key);

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  String oid = '';
  String _vfcode;
  bool submit = false;

  checkExist(String myId) async {
    bool check = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .get()
        .then((value) {
      print(value.data());
      // if (value.data() != null)
      //   value.data().isNotEmpty ? check = true : check = false;
    });
    return check;
  }

  _sendOtp() async {
    print('called');
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNum,
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _vfcode = verificationId;
            // _controller.text = verificationId;
          });
          print('codeAutoRetrievalTimeout');
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('called2');
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => NewProfile(widget.phoneNum)));
              // Navigator.pushAndRemoveUntil(context,
              //     MaterialPageRoute(builder: (context) {
              //   var myId = value.user.uid;
              //   checkExist(myId) ? NewProfile(widget.phoneNum) : HomeScreen();
              // }), (route) => false).then((value) => print('done'));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String vfId, int resendToken) {
          setState(() {
            _vfcode = vfId;
            // _controller.text = vfId;
          });
          print('codesent!');
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    return submit
        ? Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              // color: Colors.black.withAlpha(90),
              child: SpinKitRing(
                color: primaryColor,
                size: 50.0,
              ),
            ))
        : Column(
            children: [
              Text(
                "OTP Authentication",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: Text(
                    'An authentication code has been sent to ${widget.phoneNum}\nNot this number? Edit here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: accent2)),
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => RegScreen()));
                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Waiting for auto-detection of OTP',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: SpinKitPouringHourglass(
                      color: primaryColor,
                      size: 35.0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 35,
              ),
              PinCodeTextField(
                length: 6,
                controller: _controller,
                textInputType: TextInputType.numberWithOptions(
                    signed: true, decimal: false),
                onChanged: (a) {
                  print(a);
                },
                onCompleted: (value) {
                  setState(() {
                    oid = value;
                  });
                  print('oid ' + oid);
                },
                pinTheme: PinTheme(
                    fieldWidth: MediaQuery.of(context).size.width * 0.12,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderWidth: 1.0,
                    inactiveColor: accent2.withAlpha(99)),
              ),
              Container(
                margin: EdgeInsets.only(top: 7, bottom: 18),
                child: Text("Didn't got the OTP? Resend Code"),
              ),
              FlatButton(
                height: 50,
                onPressed: oid.isEmpty
                    ? null
                    : () async {
                        try {
                          setState(() {
                            submit = true;
                          });
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: _vfcode, smsCode: oid))
                              .then((value) async {
                            if (value.user != null) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewProfile(widget.phoneNum)),
                                  (route) => false);
                            }
                          });
                        } catch (e) {
                          setState(() {
                            submit = false;
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: const Text('Invalid OTP! Please retry'),
                              duration: const Duration(seconds: 3),
                              padding: EdgeInsets.only(
                                  bottom: 15, left: 15, top: 5)));
                          FocusScope.of(context).unfocus();
                        }
                      },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                minWidth: MediaQuery.of(context).size.width * 0.9,
                color: primaryColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "By Signing up, you agree to our Terms and Conditionss",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
  }
}
