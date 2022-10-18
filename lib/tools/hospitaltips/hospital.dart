import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Hospital extends StatefulWidget {
  static const tag = "-/Checklist";

  const Hospital({Key? key}) : super(key: key);

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  bool isLoading = false;
  String? url;
  bool loadpage = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade200,
          title: const Text('Hospital Checklist',style: TextStyle(fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold,fontSize: 20),),
          centerTitle: true,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const WebView(
            initialUrl:
                'https://thekidzit.in/admin/webpages/hospital_checklist.html',
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            gestureNavigationEnabled: true,
          ),
        ));
  }
}
