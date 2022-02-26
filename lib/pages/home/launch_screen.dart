import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gps3g/pages/home/home_screen.dart';
import 'package:gps3g/pages/sign/signin_auto.dart';
import 'package:gps3g/pages/sign/signin_screen.dart';
import 'package:gps3g/pages/sign/signup_screen.dart';
import 'package:gps3g/system/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      signInAuto();
    });
  }

  signInAuto() {
    _getDataSignIn();
  }

  _getDataSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = "";
    String password = "";
    setState(() {
      username = prefs.getString('perUsername') ?? '';
      password = prefs.getString('perPassword') ?? '';
      print(username);
    });
    if (username != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SignInAuto(username: username, password: password, type: "2"),
        ),
      );
    } else {
      Timer(Duration(seconds: 3), () {
        print(" This line is execute after 5 seconds");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg/bg-main.jpg'),
                  fit: BoxFit.cover)),
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "ระบบแจ้งเตือนพื้นที่เสี่ยงภัยใน 3 จังหวัดชายแดนภาคใต้",
                            style: TextStyle(
                                fontFamily: FontFamilys.fontFamily,
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                height: 1.2),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
