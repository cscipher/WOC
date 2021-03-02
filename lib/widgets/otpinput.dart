import 'package:flutter/material.dart';
import '../themes/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({
    Key key,
  }) : super(key: key);

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
        Text('An authentication code has been sent to ',
            style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 35,
        ),
        PinCodeTextField(
          length: 6,
          onChanged: (_) {},
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          onPressed: () {},
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
