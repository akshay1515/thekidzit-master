import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidzit/utility.dart';
import 'dart:convert';
import 'dart:io';

class LoginProvider with ChangeNotifier {
  String _identifier = '';

  String get identifier => _identifier;

  getUniqueid() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo deviceInfoPlugin =
          await DeviceInfoPlugin().androidInfo;
      _identifier = deviceInfoPlugin.androidId;
    } else {
      final IosDeviceInfo deviceInfoPlugin = await DeviceInfoPlugin().iosInfo;
      _identifier = deviceInfoPlugin.identifierForVendor;
    }
    notifyListeners();
  }

  Future<Map> sendOTP(String mobile) async {
    var url = Uri.parse('${Utility.Base_Url}${'sendOtp'}');
    Map<String, dynamic> userdata = {};

    var bodyMatter = {
      "apiVersion": "1.0",
      "phone": mobile,
      "imei": _identifier,
      "fcmToken": "",
      "motherOrFather": "mother"
    };

    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders, body: json.encode(bodyMatter));

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;

        userdata = decode['result'];
      }else{
        final decode = jsonDecode(response.body) as Map;
        userdata = decode['result'];
      }
      notifyListeners();
      return userdata;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> verifyOTP(String otp, String mobile) async {
    var url = Uri.parse('${Utility.Base_Url}${'verifyOtp'}');
    Map<String, dynamic> userdata = {};
    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders,
          body: json.encode({
            "apiVersion": "1.0",
            "phone": mobile,
            "otp": otp,
            "imei": _identifier
          }));
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;
        userdata = decode['result'];
      }else{
        final decode = jsonDecode(response.body) as Map;
        userdata = decode['result'];
      }
      notifyListeners();
      return userdata;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map> resendOTP(String otp, String mobile) async {
    var url = Uri.parse('${Utility.Base_Url}${'resendOTP'}');
    Map<String, dynamic> userdata = {};
    try {
      final response = await http.post(url,
          headers: Utility.requestHeaders,
          body: json.encode({
            "apiVersion": "1.0",
            "phone": mobile,
            "imei": _identifier
          }));
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body) as Map;
        userdata = decode['result'];
      }else{
        final decode = jsonDecode(response.body) as Map;
        userdata = decode['result'];
      }
      notifyListeners();
      return userdata;
    } catch (error) {
      rethrow;
    }
  }
}
