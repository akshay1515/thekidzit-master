import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  static const tag = "-/Homepage";

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userid;

  bool isLoading = false;
  String? url;
  bool loadpage = true;

  Future getUserDetails() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      userid = _prefs.getString('userid').toString();
      userid = userid.replaceAll('{', userid);
      userid = userid.replaceAll('}', userid);
      userid = userid.replaceAll('"','');

      var used = userid.split(",");
      Map myMap = {};
      var key = [], value = [];
      used.forEach((element) {
        var temp = [];
        temp = element.split(':');
        key.add(temp[0]);
        value.add(temp[1]);
      });
      for (int i = 0; i < key.length; i++) {
        myMap["${key[i]}"] = "${value[i]}";
      }
      userid = myMap;

      setState(() {
        isLoading = true;
      });
      return json.encode(myMap);
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imei = Provider.of<LoginProvider>(context, listen: false).identifier;
    if (!isLoading) {

      getUserDetails().then((value) {
        url =
            '${'https://www.thekidzit.in/thekidzit/#/template?userid='}${userid['userid']}${'&imei='}${imei.toString()}';
      });

    }
    return Material(
        color: Colors.white,
        child: isLoading
            ? Stack(
                children: [
                  SafeArea(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height - 20,
                    child: WebView(
                      initialUrl: url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (finish) {

                        setState(() {
                          loadpage = false;
                        });
                      },
                      allowsInlineMediaPlayback: true,
                      gestureNavigationEnabled: true,
                    ),
                  )),
                  Visibility(
                      visible: loadpage,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        child: const  Center(
                          child: CircularProgressIndicator(),
                        ),
                      ))
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
