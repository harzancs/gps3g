import 'package:flutter/material.dart';
import 'package:gps3g/pages/map/map.dart';
import 'package:gps3g/pages/mode/modeScreen.dart';
import 'package:gps3g/pages/sign/signin_auto.dart';
import 'package:gps3g/styles/pageOneStyle.dart';
import 'package:gps3g/styles/pageStyle.dart';
import 'package:gps3g/system/fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //Start-----Text Input
  TextEditingController _inputFullname = TextEditingController();
  TextEditingController _inputUsername = TextEditingController();
  TextEditingController _inputPassword = TextEditingController();
  TextEditingController _inputRePassword = TextEditingController();
  TextEditingController _inputEmail = TextEditingController();
  //End-----Text Input
  @override
  Widget build(BuildContext context) {
    return PageOneStyle(
      title: "เข้าสู่ระบบ/Login",
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
                      if (_formkey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInAuto(
                              username: _inputEmail.text,
                              password: _inputPassword.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      child: Text(
                        "เข้าสู่ระบบ",
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
}
