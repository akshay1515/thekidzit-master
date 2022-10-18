import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/tools/prayers/prayer_model.dart';
import 'package:kidzit/utility.dart';

class PrayerProvider with ChangeNotifier {
  List<PrayerModel> _items = [];

  List<PrayerModel> get items => _items;

  Future<Map> getPrayers() async {
    var url =
        Uri.parse('https://www.thekidzit.in/admin/index.php/API/getPrayers');
    Map prayer = Map();
    List<PrayerModel> getmyPrayers = [];
    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body) as Map;

        prayer = {
          'ack': data['ack'],
          'message': data['message'],
          'prayers': data['prayers'] as List,
        };
        if (prayer['prayers'].length > 0) {
          for (int i = 0; i < prayer['prayers'].length; i++) {
            getmyPrayers.add(PrayerModel(
                id: prayer['prayers'][i]['id'],
                title: prayer['prayers'][i]['title'],
                image: prayer['prayers'][i]['image'],
                audio: prayer['prayers'][i]['audio']));
          }
          _items = getmyPrayers;
          notifyListeners();
        }
      }
      return prayer;
    } catch (error) {
      rethrow;
    }
  }
}
