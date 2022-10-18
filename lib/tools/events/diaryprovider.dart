import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/tools/events/diarymodel.dart';
import 'package:kidzit/utility.dart';

class DiaryProvider with ChangeNotifier {
  List<Diarymodel> _items = [];

  List<Diarymodel> get items => _items;

  Future<Map> getDiary(Map userDetails) async {
    Map diary = Map();
    List<Diarymodel> getDiary = [];
    var url = Uri.parse(
        '${Utility.Base_Url}${'getDailyDiary/'}${userDetails['userid']}/${userDetails['imei']}');

    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        diary = {
          'ack': data['ack'],
          'message': data['message'],
          'diary': data['dailyDiary'] != null
              ? data['dailyDiary'] as List
              : data['dailyDiary']
        };

       if(diary['diary'] != null){
         if (diary['diary'].length > 0) {
           for (int i = 0; i < diary['diary'].length; i++) {
             getDiary.add(Diarymodel(
                 id: diary['diary'][i]['id'],
                 userId: diary['diary'][i]['userId'],
                 date: diary['diary'][i]['date'],
                 text: diary['diary'][i]['text']));
           }
         }
         _items = getDiary;
         notifyListeners();

       }
       }
      return diary;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> addDiary(Map userDetails) async {
    var bodyMatter = {
      "apiVersion": "1.0",
      "imei": userDetails['imei'],
      "userId": userDetails['userid'],
      "date": userDetails['data'],
      "description": userDetails['note']
    };

    Map diary = Map();
    List<Diarymodel> getDiary = [];
    var url = Uri.parse('${Utility.Base_Url}${'insertDailyDiary'}');


    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders, body: json.encode(bodyMatter));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        diary = {
          'ack': data['ack'],
          'message': data['message'],
          'diary': data['dailyDiary'] as List
        };

        if (diary['diary'].length > 0) {
          for (int i = 0; i < diary['diary'].length; i++) {
            getDiary.add(Diarymodel(
                id: diary['diary'][i]['id'],
                userId: diary['diary'][i]['userId'],
                date: diary['diary'][i]['date'],
                text: diary['diary'][i]['text']));
          }
          _items = getDiary;
          notifyListeners();
        }
      }
      return diary;
    } catch (error) {
      rethrow;
    }
  }
}
