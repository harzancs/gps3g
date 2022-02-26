import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gps3g/pages/map/future/positionAPI.dart';
import 'package:gps3g/pages/map/model/itemsNewsSocial.dart';
import 'package:gps3g/styles/pageOneStyle.dart';
import 'package:gps3g/system/fonts.dart';
import 'package:linkwell/linkwell.dart';

class NewsSocial extends StatefulWidget {
  final String district;
  final String province;
  const NewsSocial({Key? key, this.district = "", this.province = ""})
      : super(key: key);

  @override
  _NewsSocialState createState() => _NewsSocialState();
}

class _NewsSocialState extends State<NewsSocial> {
  List<ItemsNewsSocial> futureNews = [];
  List<ItemsNewsSocial> futureNewsList = [];
  // Future<bool> onLoadHistoryMe(int _start) async {
  Future<bool> getNewsSocial() async {
    Map _map = {};
    _map.addAll({"district": widget.district, "province": widget.province});
    // _map.addAll({"district": "จะนะ", "province": "สงขลา"});
    await PositionApi().apiGetItemsNewsSocial(_map).then((onValue) {
      setState(() {
        futureNewsList = onValue;
        print("count : " + futureNewsList.length.toString());
        print(futureNewsList[0].DESCRIPTION);
      });
    });
    setState(() {});
    return true;
  }

  setRun() {}

  @override
  void initState() {
    getNewsSocial();
    // TODO: implement initState
    super.initState();
  }

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
                      GestureDetector(
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
                      ),
                      Expanded(
                        child: Container(
                            child: Text(
                          "ข่าวสารในพื้นที่",
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
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                        bottomLeft: const Radius.circular(10.0),
                        bottomRight: const Radius.circular(10.0),
                      ),
                    ),
                    child: futureNewsList.length > 0
                        ? ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: futureNewsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  child: LinkWell(
                                      futureNewsList[index].DESCRIPTION));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          )
                        : Center(
                            child: Text(
                              "- ไมมีเหตุการณ์ -",
                              style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontFamily: FontFamilys.fontFamily),
                            ),
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
