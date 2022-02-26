import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

import 'package:flutter/material.dart';
import 'package:gps3g/pages/home/launch_screen.dart';
import 'package:gps3g/pages/mode/modeScreen.dart';
import 'package:gps3g/system/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignOut extends StatefulWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  _SignOutState createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  void initState() {
    _signOut();
    super.initState();
  }

  _signOut() {
    _getDataSignIn();
  }

  _getDataSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaunchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
