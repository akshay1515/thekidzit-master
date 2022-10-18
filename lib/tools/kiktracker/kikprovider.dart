import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kidzit/tools/kiktracker/kikmodel.dart';
import 'package:kidzit/utility.dart';
import 'package:http/http.dart' as http;

class KikProvider with ChangeNotifier{

  List<kikModel> _items =[];

  List<kikModel> get items => _items;

  Future<Map> insertkik(Map waterdetails) async {
    var url = Uri.parse(
        '${Utility.Base_Url}${'insertKiks/'}${waterdetails['userid']}/${waterdetails['deviceid']}');
    Map<String, dynamic>? waterdata = Map();
    List<kikModel> waterlist = [];
    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;

        waterdata = {
          'ack': decode['ack'],
          'message': decode['message'],
          'kikdata': decode['kikdata'] as List
        };


        for (int i = 0; i < waterdata['kikdata'].length; i++) {
          waterlist.add(kikModel(
            id: waterdata['kikdata'][i]['id'],
            userId: waterdata['kikdata'][i]['userId'],
            date: waterdata['kikdata'][i]['date'],
            kiks: waterdata['kikdata'][i]['kiks'],
          ));
        }
        _items = waterlist;
      }
      notifyListeners();
      return waterdata;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> getWater(Map waterdetails) async {
    var url = Uri.parse(
        '${Utility.Base_Url}${'getKiks/'}${waterdetails['userid']}/${waterdetails['deviceid']}');
    Map<String, dynamic>? waterdata = Map();
    List<kikModel> waterlist = [];
    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;

        waterdata = {
          'ack': decode['ack'],
          'message': decode['message'],
          'kikdata': decode['kikdata'] as List
        };


        for (int i = 0; i < waterdata['kikdata'].length; i++) {
          waterlist.add(kikModel(
            id: waterdata['kikdata'][i]['id'],
            userId: waterdata['kikdata'][i]['userId'],
            date: waterdata['kikdata'][i]['date'],
            kiks: waterdata['kikdata'][i]['kiks'],
          ));
        }
        _items = waterlist;
      }
      notifyListeners();
      return waterdata;
    } catch (error) {
      rethrow;
    }
  }
}