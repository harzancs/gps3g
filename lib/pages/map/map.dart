import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_place/google_place.dart';
import 'package:gps3g/pages/map/future/positionAPI.dart';
import 'package:gps3g/pages/map/model/itemsPosition.dart';
import 'package:gps3g/system/fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Timer? timer;

  Completer<GoogleMapController> _controller = Completer();
  final Geolocator _geolocator = Geolocator();
  late GoogleMapController mapController;
  Set<Marker> markers = {};
// For storing the current position
  late Position _currentPosition;
  double _latitudedFrist = 0.0;
  double _longitudeFrist = 0.0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  double _latitudeEnd = 0.0;
  double _longitudeEnd = 0.0;
  String _nameEnd = "";

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBjoCjlaNTlclyoY3FQq30VGNNcMJ7s5gA";
  List<AutocompletePrediction> predictionsList = [];
  bool _hiddenSearch = false;
  bool _hiddenLine = false;
  bool _hiddenGo = false;
  late Set<Circle> circles;

//location
  var location = "";
  String Lat = "";
  String Lng = "";
  // ///----- วาดเส้นทาง
  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_latitude, _longitude),
      PointLatLng(_latitudeEnd, _longitudeEnd),
      // travelMode: TravelMode.driving,
    );
    print("MSG Poliline : " + result.errorMessage.toString());
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    startMarker = Marker(
      markerId: MarkerId('positionStart'),
      position: LatLng(_latitude, _longitude),
      icon: BitmapDescriptor.defaultMarker,
    );
    markers.add(startMarker);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_latitude, _longitude),
          zoom: 15.0,
        ),
      ),
    );
    _addPolyLine();
  }

  _addPolyLine() {
    setState(() {
      polylines.clear();
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
          polylineId: id, color: Colors.blue, points: polylineCoordinates);
      polylines[id] = polyline;
    });

    setState(() {});
  }

  _circle() {
    setState(() {
      circles = Set.from([
        Circle(
            circleId: CircleId('id'),
            center: LatLng(_latitude, _longitude),
            radius: 10000,
            strokeColor: Colors.blue.shade200.withOpacity(0.5),
            fillColor: Colors.blue.shade100.withOpacity(0.3),
            strokeWidth: 2),
      ]);
    });
  }
  // ///----- วาดเส้นทาง

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14.4746,
  );

  // CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  Marker startMarker = Marker(
    markerId: MarkerId('1'),
    position: LatLng(
      0.0,
      0.0,
    ),
    icon: BitmapDescriptor.defaultMarker,
  );
  _getLatLongNow() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("ตำแหน่งปัจจุบัน " +
        _currentPosition.latitude.toString() +
        ' : ' +
        _currentPosition.longitude.toString());
    setState(() {
      _latitude = _currentPosition.latitude;
      _longitude = _currentPosition.longitude;
      if (_latitudedFrist == 0.0 && _longitudeFrist == 0.0) {
        _latitudedFrist = _currentPosition.latitude;
        _longitudeFrist = _currentPosition.longitude;
      }
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_latitude, _longitude),
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  List<ItemsPosition> futurePosition = [];
  List<ItemsPosition> futurePositionList = [];
  Future<bool> _getPositionRisk() async {
    await PositionApi().apiGetItemsPosition().then((onValue) {
      double totalDistance = 0;
      setState(() {
        setState(() async {
          if (onValue.length > 0) {
            futurePosition = onValue;
            for (int i = 0; i < futurePosition.length; i++) {
              totalDistance = Geolocator.distanceBetween(
                  _latitude,
                  _longitude,
                  double.parse(futurePosition[i].LATITUDE),
                  double.parse(futurePosition[i].LONGITUDE));
              print("ตำแหน่งที่ {$i} ห่างที่คุณอยู่ " +
                  totalDistance.toString() +
                  " เมตร");
              if (totalDistance <= 10000) {
                futurePositionList.add(futurePosition[i]);
                if (futurePosition[i].TYPE == "ระเบิด") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-1.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "ยิง") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-2.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "ก่อกวน") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-3.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "พบศพ") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-4.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "พบระเบิด") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-5.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "ซุ่มโจมตี") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-6.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "วางเพลิง") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-7.png'));
                  markers.add(startMarker);
                } else if (futurePosition[i].TYPE == "ตรวจเก็บวัตถุพยาน") {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-8.png'));
                  markers.add(startMarker);
                } else {
                  startMarker = Marker(
                      markerId: MarkerId('point{$i}'),
                      position: LatLng(double.parse(futurePosition[i].LATITUDE),
                          double.parse(futurePosition[i].LONGITUDE)),
                      infoWindow: InfoWindow(
                        title: futurePosition[i].TYPE,
                        snippet: futurePosition[i].RISK +
                            " - " +
                            futurePosition[i].DISTRICT +
                            " " +
                            futurePosition[i].PROVINCE,
                      ),
                      icon: await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(30, 30)),
                          'assets/images/icon/icon-9.png'));
                  markers.add(startMarker);
                }
              }
            }
          }
        });
      });
    });
    setState(() {});
    return true;
    // double totalDistance = 0;
    // setState(() {
    //   futurePosition = PositionApi().apiGetItemsPosition();
    // });
    // for (int i = 0;i < futurePosition.;i++) {}
    // totalDistance = Geolocator.distanceBetween(
    //     _latitude, _longitude, widget.myLat, widget.myLng);
  }

  runTimePosition() {
    if (_hiddenGo) {
      setState(() {
        futurePositionList.clear();
        _getLatLongNow();
        print("markers ตำแหน่งทั้งหมด :" + markers.length.toString());
        //----
        markers.clear();
        print("markers เคลียร์ตำแหน่ง :" + markers.length.toString());
        startMarker = Marker(
          markerId: MarkerId('positionStart'),
          position: LatLng(_latitudedFrist, _longitudeFrist),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add(startMarker);
        startMarker = Marker(
          markerId: MarkerId('positionEnd'),
          position: LatLng(_latitudeEnd, _longitudeEnd),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add(startMarker);
        //----
        _circle();

        _getPositionRisk();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLatLongNow();
    // _getPositionRisk();
    timer =
        Timer.periodic(Duration(seconds: 60), (Timer t) => runTimePosition());
    // _getPolyline();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              markers: markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
              },
              circles: _hiddenGo ? circles : {},
              // onTap: (val) {
              //   print("ตำแหน่งที่เลือก " +
              //       val.latitude.toString() +
              //       ' : ' +
              //       val.longitude.toString());
              //   setState(() {
              //     markers.add(Marker(
              //       markerId: MarkerId('2'),
              //       position: LatLng(val.latitude, val.longitude),
              //       icon: BitmapDescriptor.defaultMarker,
              //     ));
              //     // _getPolyline(_currentPosition, val);
              //   });
              // },
            ),
            Container(
              child: SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.pin_drop),
                                        hintText: 'ตำแหน่งปลายทาง',
                                        hintStyle: TextStyle(
                                          fontFamily: FontFamilys.fontFamily,
                                          color: Colors.grey.shade400,
                                        ),
                                        // labelText: 'Name *',
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          _hiddenSearch = true;
                                          _hiddenLine = false;
                                          autoCompleteSearch(value);
                                        } else {
                                          _hiddenSearch = false;
                                          if (predictionsList.length > 0 &&
                                              mounted) {
                                            setState(() {
                                              predictionsList = [];
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: _hiddenSearch,
                                    child: Container(
                                      height: 200,
                                      color: Colors.white,
                                      child: ListView.builder(
                                        itemCount: predictionsList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.green,
                                              child: Icon(
                                                Icons.pin_drop,
                                                color: Colors.white,
                                              ),
                                            ),
                                            title: Text(predictionsList[index]
                                                .description
                                                .toString()),
                                            onTap: () {
                                              _hiddenSearch = false;
                                              _hiddenLine = true;
                                              _nameEnd = predictionsList[index]
                                                  .description!;
                                              getDetils(predictionsList[index]
                                                  .placeId
                                                  .toString());
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _hiddenLine,
                                    child: Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _hiddenLine = false;
                                                  _circle();
                                                  _hiddenGo = true;
                                                  _getPolyline();
                                                  _getPositionRisk();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Icon(
                                                          Icons.map_rounded,
                                                          color: Colors.white,
                                                        )),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          'แสดงเส้นทางจากตำแหน่งของคุณมายัง "' +
                                                              _nameEnd +
                                                              '"',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontFamilys
                                                                      .fontFamily,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              height: 1),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _hiddenGo
                ? SlidingUpPanel(
                    panel: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: Colors.amber,
                                size: 40,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "เหตุการณ์ที่เคยเกิดขึ้น รัศมี 10 กิโลเมตร",
                                      style: TextStyle(
                                          fontFamily: FontFamilys.fontFamily,
                                          fontSize: 16,
                                          height: 1)),
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          Expanded(
                            child: Container(
                              child: futurePositionList.length > 0
                                  ? ListView.separated(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: futurePositionList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        double totalDistance = 0;
                                        totalDistance =
                                            Geolocator.distanceBetween(
                                                _latitude,
                                                _longitude,
                                                double.parse(
                                                    futurePositionList[index]
                                                        .LATITUDE),
                                                double.parse(
                                                    futurePositionList[index]
                                                        .LONGITUDE));
                                        return Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    futurePositionList[index]
                                                        .TYPE,
                                                    style: TextStyle(
                                                        fontFamily: FontFamilys
                                                            .fontFamily,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    "ห่างออกไป " +
                                                        (totalDistance / 1000)
                                                            .toStringAsFixed(
                                                                2) +
                                                        " กม.",
                                                    style: TextStyle(
                                                        fontFamily: FontFamilys
                                                            .fontFamily,
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  "ระดับความเสี่ยง : " +
                                                      futurePositionList[index]
                                                          .RISK,
                                                  style: TextStyle(
                                                      fontFamily: FontFamilys
                                                          .fontFamily,
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      height: 1)),
                                              Row(
                                                children: [
                                                  Text(
                                                      "" +
                                                          futurePositionList[
                                                                  index]
                                                              .DISTRICT +
                                                          " " +
                                                          futurePositionList[
                                                                  index]
                                                              .PROVINCE,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontFamilys
                                                                  .fontFamily,
                                                          fontSize: 16,
                                                          color: Colors.grey,
                                                          height: 1)),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
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
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  //แผนที่
  // void showPlacePicker() async {
  //   LocationResult result = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => PlacePicker(googleAPiKey),
  //     ),
  //   );

  //   // Handle the result in your way
  //   print(result);
  //   print("==================== your way result ====================");
  //   print(result.latLng!.latitude.toString());
  // }

  void autoCompleteSearch(String value) async {
    var googlePlace = GooglePlace(googleAPiKey);
    var result = await googlePlace.autocomplete.get(value);
    print("status GooglePlace" + result!.status.toString());
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictionsList = result.predictions!;
      });
    }
  }

  void getDetils(String placeId) async {
    var googlePlace = GooglePlace(googleAPiKey);
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      double _lat = 0.0;
      double _long = 0.0;
      setState(() {
        _lat = result.result!.geometry!.location!.lat!;
        _long = result.result!.geometry!.location!.lng!;
        _latitudeEnd = result.result!.geometry!.location!.lat!;
        _longitudeEnd = result.result!.geometry!.location!.lng!;
        markers.clear();
        startMarker = Marker(
          markerId: MarkerId('positionEnd'),
          position: LatLng(_lat, _long),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add(startMarker);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_lat, _long),
              zoom: 18.0,
            ),
          ),
        );
      });
    }
  }
}
