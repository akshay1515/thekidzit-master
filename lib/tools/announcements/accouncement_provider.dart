import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/tools/announcements/announcementmodel.dart';
import 'package:kidzit/utility.dart';

class AnnouncementProvider with ChangeNotifier {
  List<announcementmodel> _items = [];

  List<announcementmodel> get items => _items;

  Future<Map> getAnnouncement(Map details) async {
    var url = Uri.parse(
        '${Utility.Base_Url}${'getAnnouncements/'}${details['userid']}/${details['imei']}');
    Map<String, dynamic> getDetails = {};

    List<announcementmodel> getannouncement = [];

    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;

        getDetails = {
          'ack': data['ack'],
          'message': data['message'],
          'announcement': data['announcement'] as List
        };

        if (getDetails['announcement'].length > 0) {

          for(int i =0;i<getDetails['announcement'].length;i++){
            getannouncement.add(announcementmodel(
              id: getDetails['announcement'][i]['id'],
              image: getDetails['announcement'][i]['image'],
              title: getDetails['announcement'][i]['title']
            ));
          }

          _items = getannouncement;
          notifyListeners();
        }
      }

      return getDetails;
    } catch (error) {
      rethrow;
    }
  }
}
