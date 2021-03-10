import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/otpinput.dart';
import 'package:flutter/material.dart';
import '../widgets/Numinput.dart';

class RegScreen extends StatefulWidget {
  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(25),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [shadow],
                    borderRadius: BorderRadius.all(Radius.circular(200))),
                child: Center(
                  child: Text(
                    'PROJECT-Y!',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              // NumberInput(formKey: formKey, number: number, controller: controller)
              // OtpInput()
              NumberInput()
            ],
          ),
        ),
      ),
    );
  }
}
