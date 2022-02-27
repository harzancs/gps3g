import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gps3g/pages/mode/modeScreen.dart';
import 'package:gps3g/pages/sign/signin_auto.dart';
import 'package:gps3g/styles/pageOneStyle.dart';
import 'package:gps3g/styles/pageTwoStyle.dart';
import 'package:gps3g/system/api.dart';
import 'package:gps3g/system/fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();
  //Start-----Text Input
  TextEditingController _inputFullname = TextEditingController();
  TextEditingController _inputUsername = TextEditingController();
  TextEditingController _inputPassword = TextEditingController();
  TextEditingController _inputPasswordDe = TextEditingController();
  TextEditingController _inputPasswordNews = TextEditingController();
  TextEditingController _inputRePassword = TextEditingController();
  TextEditingController _inputEmail = TextEditingController();
  //End-----Text Input
  String _pass = "";
  @override
  void initState() {
    super.initState();
    _getDataSharedPreferences();
  }

  _getDataSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = "";
    setState(() {
      _inputFullname.text = prefs.getString('perName')!;
      _inputEmail.text = prefs.getString('perEmail')!;
      _pass = prefs.getString('perPassword')!;

      print(_pass);
    });
  }

//----
  _getDataProfile() {
    var jsonMap = {};
    jsonMap.addAll({
      "username": _inputEmail.text,
      "name": _inputFullname.text,
    });
    updateProfile(http.Client(), json.encode(jsonMap));
  }

  Future<String> updateProfile(http.Client client, jsonMap) async {
    final response = await client.post(Uri.parse(Api.updateMemberProfile),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var body = json.decode(response.body);
    if (body[0]['status'] == 'true') {
      _showMyDialog("บันทึกเรียบร้อย");
      UpdateSharedPreferences().updateName(_inputFullname.text);
    } else {
      _showMyDialog("Error มีบ้างอย่างปิดพลาด " + body[0]['status']);
    }

    setState(() {});
    return "";
  }

  //---
  _getDataPassword() {
    var jsonMap = {};
    String passMd5 = md5.convert(utf8.encode(_inputRePassword.text)).toString();
    jsonMap.addAll({
      "username": _inputEmail.text,
      "password": passMd5,
    });
    updatePassword(http.Client(), json.encode(jsonMap));
  }

  Future<String> updatePassword(http.Client client, jsonMap) async {
    final response = await client.post(Uri.parse(Api.updateMemberPassword),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var body = json.decode(response.body);
    if (body[0]['status'] == 'true') {
      _showMyDialog("บันทึกเรียบร้อย");
      String passMd5 =
          md5.convert(utf8.encode(_inputRePassword.text)).toString();
      UpdateSharedPreferences().updatePassword(passMd5);
    } else {
      _showMyDialog("Error มีบ้างอย่างปิดพลาด");
    }

    setState(() {});
    return "";
  }
  //---

  @override
  Widget build(BuildContext context) {
    return PageTwoStyle(
      title: "แก้ไขข้อมูลส่วนตัว",
      isHaveArrow: true,
      backpage: ModeScreen(),
      widget: Column(
        children: [
          Container(
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
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Form(
                        key: _formkey1,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _inputEmail,
                              enabled: false,
                              keyboardType: TextInputType.emailAddress,
                              style:
                                  TextStyle(fontFamily: FontFamilys.fontFamily),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    fontFamily: FontFamilys.fontFamily,
                                    color: Colors.grey.shade400,
                                  )
                                  // labelText: 'Name *',
                                  ),
                            ),
                            TextFormField(
                              controller: _inputFullname,
                              keyboardType: TextInputType.text,
                              style:
                                  TextStyle(fontFamily: FontFamilys.fontFamily),
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '* ไม่สามารถแก้ไข Email ได้',
                        style: TextStyle(
                            fontFamily: FontFamilys.fontFamily,
                            color: Colors.red,
                            height: 1,
                            fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formkey1.currentState!.validate()) {
                            _getDataProfile();
                          }
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: Container(
                          child: Text(
                            "บันทึก",
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
          SizedBox(
            height: 20,
          ),
          Container(
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
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'แก้ไขรหัสผ่าน',
                          style: TextStyle(
                              fontFamily: FontFamilys.fontFamily,
                              color: Colors.grey.shade600,
                              fontSize: 18),
                        ),
                      ),
                      Divider(),
                      Form(
                        key: _formkey2,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'รหัสผ่านเดิม',
                                style: TextStyle(
                                    fontFamily: FontFamilys.fontFamily,
                                    color: Colors.grey,
                                    height: 1,
                                    fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              controller: _inputPasswordDe,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style:
                                  TextStyle(fontFamily: FontFamilys.fontFamily),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.password_sharp),
                                  hintText: 'รหัสผ่านเดิม',
                                  hintStyle: TextStyle(
                                    fontFamily: FontFamilys.fontFamily,
                                    color: Colors.grey.shade400,
                                  )
                                  // labelText: 'Name *',
                                  ),
                              validator: (value) {
                                if (value == "") {
                                  return "กรุณากรอกรหัสผ่านเดิม";
                                } else
                                  return null;
                              },
                            ),
                            Divider(),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'รหัสผ่านใหม่',
                                style: TextStyle(
                                    fontFamily: FontFamilys.fontFamily,
                                    color: Colors.grey,
                                    height: 1,
                                    fontSize: 15),
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _inputPasswordNews,
                              keyboardType: TextInputType.visiblePassword,
                              style:
                                  TextStyle(fontFamily: FontFamilys.fontFamily),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.password_sharp),
                                  hintText: 'ตั้งรหัสผ่านใหม่',
                                  hintStyle: TextStyle(
                                    fontFamily: FontFamilys.fontFamily,
                                    color: Colors.grey.shade400,
                                  )
                                  // labelText: 'Name *',
                                  ),
                              validator: (value) {
                                if (value == "") {
                                  return "กรุณากรอก ตั้งรหัสผ่าน";
                                } else
                                  return null;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _inputRePassword,
                              keyboardType: TextInputType.visiblePassword,
                              style:
                                  TextStyle(fontFamily: FontFamilys.fontFamily),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.password_sharp),
                                  hintText: 'ยืนยันรหัสผ่านใหม่',
                                  hintStyle: TextStyle(
                                    fontFamily: FontFamilys.fontFamily,
                                    color: Colors.grey.shade400,
                                  )
                                  // labelText: 'Name *',
                                  ),
                              validator: (value) {
                                if (value == "") {
                                  return "กรุณากรอกยืนยันรหัสผ่าน";
                                } else
                                  return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                          if (_formkey2.currentState!.validate()) {
                            String passMd5 = md5
                                .convert(utf8.encode(_inputPasswordDe.text))
                                .toString();
                            print(passMd5);
                            if (_pass == passMd5) {
                              if (_inputPasswordNews.text ==
                                  _inputRePassword.text) {
                                _getDataPassword();
                              } else {
                                _showMyDialog("ยืนยันรหัสผ่านใหม่ ไม่ตรงกัน !");
                              }
                            } else {
                              _showMyDialog("รหัสผ่านเดิมไม่ถูกต้อง !");
                            }
                          }
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        child: Container(
                          child: Text(
                            "บันทึก",
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
        ],
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

class UpdateSharedPreferences {
  updateName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('perName', name);
  }

  updatePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('perPassword', password);
  }
}
