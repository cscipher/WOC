import 'package:flutter/material.dart';
import '../themes/colors.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({
    Key key,
    @required this.formKey,
    @required this.number,
    @required this.controller,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final PhoneNumber number;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your phone number to verify. A confirmation OTP will be sent after requesting.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Form(
          key: formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  // onInputValidated: (bool value) {
                  //   print(value);
                  // },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                FlatButton(
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Get OTP',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  color: primaryColor,
                )
                // RaisedButton(
                //   onPressed: () {
                //     formKey.currentState.validate();
                //   },
                //   child: Text('Validate'),
                // ),
                // RaisedButton(
                //   onPressed: () {
                //     getPhoneNumber('+15417543010');
                //   },
                //   child: Text('Update'),
                // ),
                // RaisedButton(
                //   onPressed: () {
                //     formKey.currentState.save();
                //   },
                //   child: Text('Save'),
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
