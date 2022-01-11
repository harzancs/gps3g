import 'package:flutter/material.dart';
import 'package:gps3g/pages/sign/signin_screen.dart';
import 'package:gps3g/pages/sign/signup_screen.dart';
import 'package:gps3g/system/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  padding:
                      EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  color: Colors.white.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        child: Container(
                          child: Text(
                            "เข้าสู่ระบบ/Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamilys.fontFamily,
                              fontSize: 16,
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
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
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Container(
                          child: Text(
                            "ลงทะเบียน/Registor",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamilys.fontFamily,
                              fontSize: 16,
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
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
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text(
                            "ข้อมูลเกี่ยวกับแอพปลิเคชันนี้",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: FontFamilys.fontFamily,
                                fontWeight: FontWeight.w300),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
