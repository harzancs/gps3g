import 'package:flutter/material.dart';
import 'package:gps3g/system/fonts.dart';

class PageOneStyle extends StatefulWidget {
  final String title;
  final bool isHaveArrow;
  final Widget widget;

  const PageOneStyle({
    Key? key,
    this.title = "",
    this.isHaveArrow = false,
    required this.widget,
  }) : super(key: key);

  @override
  _PageOneStyleState createState() => _PageOneStyleState();
}

class _PageOneStyleState extends State<PageOneStyle> {
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
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                  child: Row(
                    children: [
                      widget.isHaveArrow
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: Container(
                            child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          style: TextStyle(
                              fontFamily: FontFamilys.fontFamily,
                              fontSize: 18,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
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
                          child: widget.widget),
                    ),
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
