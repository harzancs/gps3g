import 'package:flutter/material.dart';
import 'package:gps3g/pages/map/map.dart';
import 'package:gps3g/styles/pageOneStyle.dart';
import 'package:gps3g/styles/pageStyle.dart';
import 'package:gps3g/system/fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
                      if (_formkey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                      }
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
}
