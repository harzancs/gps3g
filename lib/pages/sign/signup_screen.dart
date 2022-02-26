import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gps3g/pages/sign/signin_auto.dart';
import 'package:gps3g/styles/pageOneStyle.dart';
import 'package:gps3g/system/api.dart';
import 'package:gps3g/system/fonts.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //Start-----Text Input
  TextEditingController _inputFullname = TextEditingController();
  TextEditingController _inputUsername = TextEditingController();
  TextEditingController _inputPassword = TextEditingController();
  TextEditingController _inputRePassword = TextEditingController();
  TextEditingController _inputEmail = TextEditingController();
  //End-----Text Input
  @override
  void initState() {
    super.initState();
  }

  _getData() {
    var jsonMap = {};
    jsonMap.addAll({
      "username": _inputEmail.text,
      "email": _inputEmail.text,
      "fullname": _inputFullname.text,
      "password": _inputRePassword.text
    });
    postDRegister(http.Client(), json.encode(jsonMap));
  }

  Future<String> postDRegister(http.Client client, jsonMap) async {
    final response = await client.post(Uri.parse(Api.postMember),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var body = json.decode(response.body);
    if (body['status'] == 'true') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInAuto(
            username: _inputEmail.text,
            password: _inputRePassword.text,
          ),
        ),
      );
    } else {
      if (body['massage'] == 'username') {
        _showMyDialog("Email นี้ถูกใช้งานแล้ว");
      } else {
        _showMyDialog("Error มีบ้างอย่างปิดพลาด");
      }
    }

    setState(() {});
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return PageOneStyle(
      title: "ลงทะเบียน/Registor",
      isHaveArrow: true,
      widget: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _inputFullname,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: FontFamilys.fontFamily),
                          decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'ชื่อ สกุล',
                              hintStyle: TextStyle(
                                fontFamily: FontFamilys.fontFamily,
                                color: Colors.grey.shade400,
                              )
                              // labelText: 'Name *',
                              ),
                          validator: (value) {
                            if (value == "") {
                              return "กรุณากรอก ชื่อ สกุล";
                            } else
                              return null;
                          },
                        ),
                        TextFormField(
                          controller: _inputEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontFamily: FontFamilys.fontFamily),
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontFamily: FontFamilys.fontFamily,
                                color: Colors.grey.shade400,
                              )
                              // labelText: 'Name *',
                              ),
                          validator: (value) {
                            if (value == "") {
                              return "กรุณากรอก email";
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _inputPassword,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(fontFamily: FontFamilys.fontFamily),
                          decoration: InputDecoration(
                            icon: Icon(Icons.password),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontFamily: FontFamilys.fontFamily,
                              color: Colors.grey.shade400,
                            ),
                            // labelText: 'Name *',
                          ),
                          validator: (value) {
                            if (value == "") {
                              return "กรุณากรอก password";
                            } else
                              return null;
                          },
                        ),
                        TextFormField(
                          controller: _inputRePassword,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(fontFamily: FontFamilys.fontFamily),
                          decoration: InputDecoration(
                            icon: Icon(Icons.password),
                            hintText: 'ยืนยัน Password',
                            hintStyle: TextStyle(
                              fontFamily: FontFamilys.fontFamily,
                              color: Colors.grey.shade400,
                            ),
                            // labelText: 'Name *',
                          ),
                          validator: (value) {
                            if (value == "") {
                              return "กรุณากรอก password";
                            } else
                              return null;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_inputPassword.text == _inputRePassword.text) {
                        if (_formkey.currentState!.validate()) {
                          _getData();
                        }
                      } else {}
                    },
                    child: Container(
                      child: Text(
                        "ลงทะเบียน",
                        style: TextStyle(
                            fontFamily: FontFamilys.fontFamily,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.green,
                            Colors.green.shade800,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
              },
            ),
          ],
        );
      },
    );
  }
}
