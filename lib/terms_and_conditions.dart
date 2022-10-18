import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final int url_selector;

  const CustomWebView({Key? key, required this.url_selector}) : super(key: key);

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  String url =
      'https://docs.google.com/file/d/1z6Ffa0bp4iVrxNeiCMTGTeJlTSwFmif5/edit?usp=docslist_api&filetype=msword';

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url_selector == 1) {
    } else {
      url = 'https://docs.google.com/file/d/1J1TzEbS5wSxZsup7HMv_u-lHyfCKnZHx/edit?usp=docslist_api&filetype=msword';
    }

    return Material(
      child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
