import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';

class NewProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
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
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Update your status',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.6),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: FlatButton(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
