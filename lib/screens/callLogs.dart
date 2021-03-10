import 'package:WOC/themes/colors.dart';
import 'package:flutter/material.dart';

class CallLogs extends StatefulWidget {
  @override
  _CallLogsState createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call Logs')),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 5.0)
                  ]),
              // elevation: 0,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              padding: EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: accent2,
                  foregroundColor: Colors.white,
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: FittedBox(child: Text('H')),
                  ),
                ),
                title: Text(
                  'demo call text',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text('Yesterday, 5pm'),
                // subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
                trailing: IconButton(
                  icon: Icon(Icons.call),
                  disabledColor: primaryColor,
                  onPressed: null,
                ),
              ),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
