import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gps3g/pages/map/map.dart';
import 'package:gps3g/pages/sign/signout.dart';
import 'package:gps3g/styles/pageMainStyle.dart';
import 'package:gps3g/system/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeScreen extends StatefulWidget {
  const ModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String fullname = "";
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    _getDataSharedPreferences();
  }

  _getDataSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = "";
    setState(() {
      username = prefs.getString('perUsername')!;
      fullname = prefs.getString('perName')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: PageMainStyle(
          widget: Container(
            padding: EdgeInsets.only(top: 10, left: 5),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState!
                            .openDrawer(), // <-- Opens drawer
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            fullname,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamilys.fontFamily,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0),
                      bottomRight: const Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 5, bottom: 20),
                        child: Row(
                          children: [
                            Icon(Icons.sync_outlined),
                            Text(
                              'เลือกโหมด',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: FontFamilys.fontFamily,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                mode: 1,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.green.shade600,
                                  Colors.green.shade300,
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            'Basic Mode',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamilys.fontFamily,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                mode: 2,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.green.shade600,
                                  Colors.green.shade300,
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            'AI Mode',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamilys.fontFamily,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        drawer: drawer(context),
      ),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      fullname,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: FontFamilys.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ),
                      title: Text(
                        'ออกจากระบบ',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: FontFamilys.fontFamily,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignOut(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('คุณแน่ใจไหม?'),
            content: new Text('คุณต้องการออกจากแอป'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('ไม่'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: new Text('ใช่'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
