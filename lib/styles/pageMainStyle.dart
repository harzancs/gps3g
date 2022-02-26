import 'package:flutter/material.dart';
import 'package:gps3g/system/fonts.dart';

class PageMainStyle extends StatefulWidget {
  final Widget widget;

  const PageMainStyle({
    Key? key,
    required this.widget,
  }) : super(key: key);

  @override
  _PageMainStyleState createState() => _PageMainStyleState();
}

class _PageMainStyleState extends State<PageMainStyle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage('assets/images/bg/bg-main.jpg'),
              fit: BoxFit.cover),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade600,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Container(child: widget.widget),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
