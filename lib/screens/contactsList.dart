import 'package:WOC/data/databasehelper.dart';
import 'package:WOC/screens/chatPage.dart';
import 'package:WOC/screens/home_screen.dart';
import 'package:WOC/themes/colors.dart';
import 'package:WOC/widgets/popupWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact> contacts = [], filteredContacts = [];
  SearchBar searchBar;
  Map<String, String> updtContact;
  TextEditingController _searchControl;
  bool isOpen = false;
  List<Contact> appUserContacts = [];
  List<Contact> switchContact = [];
  bool present = false;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: accent1),
        title: new Text('New Message'),
        leading: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // DatabaseHelper.db.deleteDatabase();
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen(nav: 1,)));
              appUserContacts.clear();
              getAllContacts();
            }),
        actions: [searchBar.getSearchAction(context)]);
  }

  void filterContacts(String searched) {
    setState(() {
      filteredContacts = appUserContacts;
    });
    var filter = filteredContacts.where((contact) {
      return contact.displayName.toLowerCase().contains(searched.toLowerCase());
    }).toList();
    setState(() {
      filteredContacts = filter;
    });
  }

  _ContactsListState() {
    searchBar = SearchBar(
        inBar: false,
        controller: _searchControl,
        setState: setState,
        // onClosed: (){
        //   setState(() {
        //     _searchControl.text = '';
        //     filteredContacts.clear();
        //   });
        // },
        onSubmitted: (value) {
          filteredContacts.clear();
        },
        onChanged: (value) {
          filterContacts(value);
        },
        showClearButton: true,
        buildDefaultAppBar: buildAppBar);
  }

  getStatus() async {
    print('exe');
    // List<Map<String, dynamic>> dbData = [];
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    contacts.map((cntct) async {
      var pc = cntct.phones.first.value;
      pc = pc.split(' ').join();
      print('fddfd');
      var dbData = await DatabaseHelper.db.queryAll();
      print('dbData::$dbData');

      if (dbData.length != 0) {
        print('local');
        for (var localContact in dbData) {
          print('lc:::$localContact....pc:::${pc}');
          if (pc == localContact['contactNum']) {
            print('kya!');
            setState(() {
              appUserContacts.add(Contact(
                  phones: [Item(value: localContact['contactNum'])],
                  jobTitle: localContact['contactStatus'],
                  androidAccountName: localContact['id'],
                  prefix: localContact['contactPic'],
                  displayName: cntct.displayName));
              print('Contafcts:::$appUserContacts');
            });
            break;
          } else if (cntct.phones.isNotEmpty) {
            var lcnt = pc.split(' ').join();

            await ref.where('phnNo', isEqualTo: lcnt).get().then((value) async {
              var contactMap = value.docs;
              if (contactMap.length != 0 && contactMap != null) {
                print('not::');
                print(contactMap);
                var map = contactMap.first.data();
                print('from db///${map['phnNo']}');
                // setState(() {
                //   appUserContacts.add(Contact(
                //       phones: [Item(value: map['phnNo'])],
                //       jobTitle: map['status'],
                //       androidAccountName: map['authId'],
                //       displayName: cntct.displayName));
                //   print('add');
                // });
                var tempQuery = await DatabaseHelper.db.queryAll();
                bool flag = true;
                for (var tc in tempQuery) {
                  if (map['authId'] == tc['id']) {
                    flag = false;
                    break;
                  }
                }
                if (flag)
                  DatabaseHelper.db.insert({
                    DatabaseHelper.colId: map['authId'],
                    DatabaseHelper.colPic: map['photourl'],
                    DatabaseHelper.colNum: map['phnNo'],
                    DatabaseHelper.colStatus: map['status'],
                    DatabaseHelper.colName: cntct.displayName
                  }).then((value) => print('db insert....'));
              }
            });
          }
        }
      } else {
        print(':::::::::::::::::::::::::;;');
        var lcnt = pc.split(' ').join();

        await ref.where('phnNo', isEqualTo: lcnt).get().then((value) {
          var contactMap = value.docs;
          if (contactMap.length != 0) {
            print('not::');
            print(contactMap);
            var map = contactMap.first.data();
            print('from db///${map['phnNo']}');
            // setState(() {
            //   appUserContacts.add(Contact(
            //       phones: [Item(value: map['phnNo'])],
            //       jobTitle: map['status'],
            //       androidAccountName: map['authId'],
            //       displayName: cntct.displayName));
            //   print('add');
            // });
            DatabaseHelper.db.insert({
              DatabaseHelper.colId: map['authId'],
              DatabaseHelper.colNum: map['phnNo'],
              DatabaseHelper.colStatus: map['status'],
              DatabaseHelper.colPic: map['photourl'],
              DatabaseHelper.colName: cntct.displayName
            }).then((value) async {
              print('db insert');
              var t = await DatabaseHelper.db.queryAll();
              print(t);
            });
          }
        });
      }
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }

  static Future<PermissionStatus> _contactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  static Future<bool> contactPermissionsGranted() async {
    PermissionStatus contactsPermissionsStatus = await _contactsPermissions();
    if (contactsPermissionsStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = contactPermissionsGranted() != null
        ? (await ContactsService.getContacts(withThumbnails: false)).toList()
        : [];
    setState(() {
      contacts = _contacts;
    });
    await getStatus();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // switchContact = appUserContacts;
      print('length:::${appUserContacts}');
      switchContact =
          filteredContacts.length == 0 ? appUserContacts : filteredContacts;
    });
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
        child: appUserContacts.isEmpty
            ? Container(
                color: primaryColor.withAlpha(90),
                child: SpinKitFadingCube(
                  color: Colors.white,
                  size: 50.0,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(18.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var user = switchContact[index];
                    // var items = contacts[index].phones;
                    // bool check = items.isEmpty;
                    return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: accent2.withAlpha(80),
                        ))),
                        // padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                        // child: FlatButton(
                        //   child: Text('reset'),
                        //   onPressed: DatabaseHelper.db.deleteDatabase,
                        // ),
                        child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(HeroDialogRoute)
                                createPopup(
                                    context, user.prefix, user.jobTitle);
                              },
                              child: CircleAvatar(
                                  child: Container(
                                    child:
                                        user.prefix == '' || user.prefix == null
                                            ? Container(
                                                // color: primaryColor.withAlpha(90),
                                                child: SpinKitPulse(
                                                  color: Colors.white,
                                                  size: 30.0,
                                                ),
                                              )
                                            : null,
                                  ),
                                  backgroundColor: accent2,
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(user.prefix ?? '')),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ChatPage(
                                        user.androidAccountName, //uid
                                        user.displayName))),
                            title: Text(user.displayName.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(user.jobTitle ?? '',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w100))));
                  },
                  itemCount: switchContact.length,
                ),
              ),
      ),
    );
  }
}

/*
TextField(
          cursorColor: Colors.white,
          // onEditingComplete: () => status = _statusController.text,
          // controller: _statusController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusColor: Colors.white,
            labelText: 'Search a contact...',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              borderSide: BorderSide(color: Colors.white, width: 0.6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              borderSide: BorderSide(color: Colors.white, width: 0.6),
            ),
          ),
        ),
        */
