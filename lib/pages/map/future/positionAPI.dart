import 'dart:convert';

import 'package:gps3g/pages/map/model/itemsPosition.dart';
import 'package:gps3g/system/api.dart';
import 'package:http/http.dart' as http;

final Map<String, String> header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": "true",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "*"
};

class PositionApi {
  PositionApi() : super();
  //---
  Future<List<ItemsPosition>> apiGetItemsPosition() async {
    final response = await http.get(
      Uri.parse(Api.getPositionRisk),
      headers: header,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return ItemsPosition.fromJson(jsonDecode(response.body));
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new ItemsPosition.fromJson(m)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
