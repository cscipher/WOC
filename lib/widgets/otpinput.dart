import 'package:WOC/screens/profileSet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String oid;
  String _vfcode;

  checkExist(String myId) async {
    bool check = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .get()
        .then((value) {
      print(value.data());
      value.data().isNotEmpty ? check = true : check = false;
    });
    return check;
  }

  _sendOtp() async {
    print('called');
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNum,
        codeAutoRetrievalTimeout: (String verificationId) {
          print('codeAutoRetrievalTimeout');
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('called2');
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                var myId = value.user.uid;
                checkExist(myId) ? NewProfile(widget.phoneNum) : HomeScreen();
              }), (route) => false).then((value) => print('done'));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String vfId, int resendToken) {
          setState(() {
            _vfcode = vfId;
          });
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
    return Column(
      children: [
        Text(
          "OTP Authentication",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text('An authentication code has been sent to ${widget.phoneNum}',
            style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 35,
        ),
        PinCodeTextField(
          length: 6,
          controller: _controller,
          textInputType:
              TextInputType.numberWithOptions(signed: true, decimal: false),
          onChanged: (a) {
            print(a);
          },
          onCompleted: (value) {
            oid = value;
            print('oid' + oid);
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
          onPressed: () async {
            try {
              await FirebaseAuth.instance
                  .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _vfcode, smsCode: oid))
                  .then((value) async {
                if (value.user != null) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewProfile(widget.phoneNum)),
                      (route) => false);
                }
              });
            } catch (e) {
              FocusScope.of(context).unfocus();
              print('invaliddddddddddddd');
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
