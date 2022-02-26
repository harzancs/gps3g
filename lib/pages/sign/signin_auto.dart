import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

import 'package:flutter/material.dart';
import 'package:gps3g/pages/mode/modeScreen.dart';
import 'package:gps3g/system/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInAuto extends StatefulWidget {
  final String username;
  final String password;
  final String type;
  const SignInAuto(
      {Key? key,
      required this.username,
      required this.password,
      this.type = "1"})
      : super(key: key);

  @override
  _SignInAutoState createState() => _SignInAutoState();
}

class _SignInAutoState extends State<SignInAuto> {
  @override
  void initState() {
    fetchSignIn(http.Client());
    super.initState();
  }

  //Start -- getShowData From DB
  fetchSignIn(http.Client client) async {
    Map jsonMap = {};
    jsonMap.addAll({"username": widget.username});
    final response = await client.post(Uri.parse(Api.getMember),
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonMap));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      String passMd5 = md5.convert(utf8.encode(widget.password)).toString();
      if (widget.type == '1') {
        if (passMd5 == body[0]['password'] &&
            widget.username == body[0]['username']) {
          SetLogin().save(body[0]['username'], body[0]['fullname'],
              body[0]['email'], body[0]['status'], body[0]['password']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModeScreen(),
            ),
          );
        } else if (passMd5 != body[0]['password'] &&
            widget.username == body[0]['username']) {
          _showMyDialog("Password ของคุณไม่ถูกต้อง");
        } else {
          _showMyDialog("Email หรือ Password ของคุณไม่ถูกต้อง");
        }
      } else if (widget.type == '2') {
        if (widget.password == body[0]['password'] &&
            widget.username == body[0]['username']) {
          SetLogin().save(body[0]['username'], body[0]['fullname'],
              body[0]['email'], body[0]['status'], body[0]['password']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModeScreen(),
            ),
          );
        } else if (passMd5 != body[0]['password'] &&
            widget.username == body[0]['username']) {
          _showMyDialog("Password ของคุณไม่ถูกต้อง");
        } else {
          _showMyDialog("Email หรือ Password ของคุณไม่ถูกต้อง");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class SetLogin {
  save(String username, String name, String email, String status,
      String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('perUsername', username);
    prefs.setString('perName', name);
    prefs.setString('perEmail', email);
    prefs.setString('perStatus', status);
    prefs.setString('perPassword', password);
  }
}
