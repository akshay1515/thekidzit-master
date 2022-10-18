import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/packageselection/plans_model.dart';
import 'package:kidzit/utility.dart';

// class PackageProvider with ChangeNotifier {
//   int _selected = 0;
//
//   int get selected => _selected;
//
//   int _package = 0;
//
//   int get package => _package;
//
//   List<planModel> _items = [];
//
//   List<planModel> get items => _items;
//
//   Future<Map> getPackageDetails(String userid) async {
//     var url = Uri.parse('${Utility.Base_Url}${'getPlans/'}$userid');
//     Map plandata = Map();
//     List<planModel> dataList = [];
//
//     try {
//       final response = await http.get(url, headers: Utility.requestHeaders);
//       print(response.body);
//       if (response.statusCode == 200) {
//         final decode = jsonDecode(response.body);
//         plandata['plans'] = decode['plans'] as List;
//         for (int i = 0; i < plandata['plans'].length; i++) {
//           dataList.add(planModel(
//             ack: plandata['ack'],
//             message: plandata['ack'],
//             plans: plandata['plans']
//           ));
//
//         }
//       } else {}
//     } catch (error) {
//       rethrow;
//     }
//     _items = dataList;
//     notifyListeners();
//     return plandata;
//   }
//

class PackageProvider with ChangeNotifier {
  planModel _item = planModel(ack: false, message: 'Loading...', plans: []);

  planModel get item => _item;

  int _durationselector = 0;

  int get durationselector => _durationselector;

  int _packageselector = 0;

  int get packageselector => _packageselector;

  String _razorPay = '';

  String get razorpay => _razorPay;

  Future<Map> getPackageDetails(String userid) async {
    planModel? tempData;
    var url = Uri.parse('${Utility.Base_Url}${'getPlans/'}$userid');

    try {
      final response = await http.get(url, headers: Utility.requestHeaders);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data['plans'].isNotEmpty) {
          tempData = planModel.fromJson(data);
        }
        _item = tempData!;
      }
      notifyListeners();
    } on Error {
      rethrow;
    }

    return Map();
  }

  Future<Map> registerPackage(Map userDetails) async {
    var url = Uri.parse('${Utility.Base_Url}${'subscribe'}');
    Map details = Map();

    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders, body: jsonEncode(userDetails));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        details = {
          'ack': data['result']['ack'],
          'message': data['result']['message']
        };
        notifyListeners();
        return details;
      } else {
        notifyListeners();
        return details;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> getRazorpay() async {
    var url =
        Uri.parse('https://thekidzit.in/admin/index.php/API/getConfigDetails');

    try {
      final response = await http.get(
        url,
        headers: Utility.requestHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;
        _razorPay = data['razorpayKey'];
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    return {};
  }

  changeDuration(int days) {
    _durationselector = days;

    notifyListeners();
  }

  changePackage(int package) {
    _packageselector = package;
  }
}
