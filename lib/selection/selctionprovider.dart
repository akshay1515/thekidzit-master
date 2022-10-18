import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/utility.dart';

class SelectionProvider with ChangeNotifier {

  Future<Map> setUserDate(Map Userdetails) async {
    var url = Uri.parse('${Utility.Base_Url}${'updateDate'}');
    var details = {
      "apiVersion": "1.0",
      "imei": Userdetails['imei'],
      "userId": Userdetails['userid'],
      "date": Userdetails['date'],
      "type": Userdetails['type'],
      "fatherOrMother": Userdetails['gender']
    };

    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders, body: json.encode(details));
      if(response.statusCode==200){
        final data = jsonDecode(response.body);

        if(data['ack']==true){
          final temp = data['data'][0] as Map;
        }
      }
      return Userdetails;
    } catch (error) {
      rethrow;
    }
  }
}
