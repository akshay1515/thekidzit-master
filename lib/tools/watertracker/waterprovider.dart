import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/tools/watertracker/watermodel.dart';
import 'package:kidzit/utility.dart';

class WaterProvider with ChangeNotifier {
  List<Watergalassdata> _items = [];

  List<Watergalassdata> get items=>_items;

  Future<Map> drinkWater(Map waterdetails) async {
    var url = Uri.parse(
        '${Utility.Base_Url}${'insertGlassWater/'}${waterdetails['userid']}/${waterdetails['deviceid']}');
    Map<String, dynamic>? waterdata = Map();
    List<Watergalassdata> waterlist = [];
    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;

        waterdata = {
          'ack': decode['ack'],
          'message': decode['message'],
          'watergalassdata': decode['watergalassdata'] as List
        };


        for (int i = 0; i < waterdata['watergalassdata'].length; i++) {
          waterlist.add(Watergalassdata(
            id: waterdata['watergalassdata'][i]['id'],
            userId: waterdata['watergalassdata'][i]['userId'],
            date: waterdata['watergalassdata'][i]['date'],
            noOfGlasses: waterdata['watergalassdata'][i]['noOfGlasses'],
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
        '${Utility.Base_Url}${'getGlassWater/'}${waterdetails['userid']}/${waterdetails['deviceid']}');
    Map<String, dynamic>? waterdata = Map();
    List<Watergalassdata> waterlist = [];
    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;

        waterdata = {
          'ack': decode['ack'],
          'message': decode['message'],
          'watergalassdata': decode['watergalassdata'] as List
        };


        for (int i = 0; i < waterdata['watergalassdata'].length; i++) {
          waterlist.add(Watergalassdata(
            id: waterdata['watergalassdata'][i]['id'],
            userId: waterdata['watergalassdata'][i]['userId'],
            date: waterdata['watergalassdata'][i]['date'],
            noOfGlasses: waterdata['watergalassdata'][i]['noOfGlasses'],
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
