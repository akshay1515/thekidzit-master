import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/utility.dart';

class UserProvider with ChangeNotifier {
  final Map _userdetails = {};

  Map get userdetails => _userdetails;

  final Map _userDate = {};

  Map get userDate => _userDate;

  Future<Map> getUserdetails(Map usercred) async {
    Map detail = {};
    var url = Uri.parse(
        '${Utility.Base_Url}${'getUserDetails/'}${usercred['userid']}/${usercred['imei']}');

    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        detail = {
          "id": data['result']['id'],
          "name": data['result']['name'],
          "mobile": data['result']['mobile'],
          "email": data['result']['email'],
          "city": data['result']['city'],
          "location": data['result']['location'],
          "status": data['result']['motherOrFather'],
          "type": data['result']['type'],
          "ovulation": data['result']['ovulationDate'],
          "period": data['result']['periodDate'],
        };
        _userdetails.addAll(detail);
      }
      notifyListeners();
      return detail;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> getUserDate(Map details) async {
    Map detail = {};
    var url = Uri.parse('${Utility.Base_Url}${'getCycleCal'}');
    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders, body: json.encode(details));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        detail = {
          'date': [
            {
              'type': 'safe',
              'from': data['result']['safeDate']['From'],
              'to': data['result']['safeDate']['To']
            },
            {
              'type': 'fertile',
              'from': data['result']['fertileWindow']['From'],
              'to': data['result']['fertileWindow']['To']
            },
            {
              'type': 'ovulation',
              'from': data['result']['ovulationDate']['From'],
              'to': data['result']['ovulationDate']['To']
            },
            {
              'type': 'postovulation',
              'from': data['result']['postOvulationDate']['From'],
              'to': data['result']['postOvulationDate']['To']
            },
            {'type': 'nextdate', 'date': data['result']['nextDate']}
          ]
        };
        userdetails.update('period', (value) => details['date']);
        _userDate.addAll(detail);
      }
      notifyListeners();
      return detail;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> updateUser(Map usercred) async {
    final details = {
      "apiVersion": "1.0",
      "imei": usercred['imei'],
      "userId": usercred['userid'],
      "name": usercred['name'],
      "mobile": usercred['mobile'],
      "email": usercred['email'],
      "city": usercred['city']
    };

    Map detail = {};
    var url = Uri.parse('${Utility.Base_Url}${'updateUserDetails'}');

    try {
      final response = await http.post(url,
          body: json.encode(details), headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        detail = {
          "id": data['data'][0]['id'],
          "name": data['data'][0]['name'],
          "mobile": data['data'][0]['mobile'],
          "email": data['data'][0]['email'],
          "city": data['data'][0]['city'],
          "location": data['data'][0]['location'],
          "status": data['data'][0]['motherOrFather'],
          "type": data['data'][0]['type'],
          "ovulation": data['data'][0]['ovulationDate'],
          "period": data['data'][0]['periodDate'],
        };
        _userdetails.addAll(detail);
      }
      notifyListeners();
      return detail;
    } catch (error) {
      rethrow;
    }
  }
}
