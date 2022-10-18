import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/calender/taskmodel.dart';
import 'package:kidzit/utility.dart';

class CalendarProvider with ChangeNotifier {
  List<TaskModel> _items = [];

  List<TaskModel> get items {
    _items.sort((object, object1) {
      var adata = object.date;
      var bdata = object1.date;
      return adata!.compareTo(bdata!);
    });
    return _items;
  }

  List<TaskModel> _recentitems = [];

  List<TaskModel> get recentitems {
    _recentitems.sort((object, object1) {
      var adata = object.date;
      var bdata = object1.date;
      return adata!.compareTo(bdata!);
    });
    return _recentitems;
  }

  Future<Map> addNewTask(Map taskDetails) async {
    Map events = {};
    List<TaskModel> task = [];

    var details = {
      'apiVersion': '1.0',
      'imei': taskDetails['imei'],
      'userId': taskDetails['userid'],
      'date': taskDetails['date'],
      'title': taskDetails['title'],
      'description': taskDetails['content']
    };

    var url = Uri.parse('${Utility.Base_Url}${'insertEvent'}');

    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders, body: json.encode(details));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;
        events = {
          'ack': data['ack'],
          'message': data['message'],
          'events': data['events'] as List
        };

        if (events['events'].length > 0) {
          for (int i = 0; i < events['events'].length; i++) {
            task.add(TaskModel(
                id: events['events'][i]['id'],
                userId: events['events'][i]['userId'],
                title: events['events'][i]['title'],
                description: events['events'][i]['description'],
                date: events['events'][i]['date'],
                createdAt: events['events'][i]['createdAt']));
          }
          _items = task;
          addtoRecent();
          notifyListeners();
        }
      }
      return events;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> getTask(Map taskDetails) async {
    Map events = {};
    List<TaskModel> task = [];

    var url = Uri.parse(
        '${Utility.Base_Url}${'getEvents/'}${taskDetails['userid']}/${taskDetails['imei']}');
    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;
        events = {
          'ack': data['ack'],
          'message': data['message'],
          'events': data['events'] as List
        };

        if (events['events'].length > 0) {
          for (int i = 0; i < events['events'].length; i++) {
            task.add(TaskModel(
                id: events['events'][i]['id'],
                userId: events['events'][i]['userId'],
                title: events['events'][i]['title'],
                description: events['events'][i]['description'],
                date: events['events'][i]['date'],
                createdAt: events['events'][i]['createdAt']));
          }
          _items = task;
          addtoRecent();
          notifyListeners();
        }
      }

      return events;
    } catch (error) {
      rethrow;
    }
  }

  addtoRecent() {
    List<TaskModel> recent = [];

    for (int i = 0; i < _items.length; i++) {
      if (DateTime.now()
              .difference(DateTime.parse(_items[i].date.toString()))
              .inDays <
          8) {
        recent.add(TaskModel(
            id: _items[i].id,
            userId: _items[i].userId,
            title: _items[i].title,
            description: _items[i].description,
            date: _items[i].date,
            createdAt: _items[i].createdAt));
      }
    }
    _recentitems = recent;
    notifyListeners();
  }
}
