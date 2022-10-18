import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/intro/introduction.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/selection/selection.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

String user = "";

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  Future<String> getuserData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final temp = _preferences.getString('userid');
    if (temp != null) {
      user = _preferences.getString('userid').toString();

      Map time = json.decode(user) as Map;


    user = user.replaceAll('{','');
    user = user.replaceAll('}','');
    user = user.replaceAll('"', '');
    var used = user.split(",");
    Map myMap = {};
    var key = []; var value = [];
    for (var element in used) {
      var temp = [];
      temp = element.split(':');
      key.add(temp[0]);
      value.add(temp[1]);
    }
    for (int i = 0; i < key.length; i++) {
      myMap[key[i]] = value[i];
    }
    return json.encode(myMap);
    }else{
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LoginProvider>(context, listen: false).getUniqueid();
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: _controller.value.isInitialized
            ? Center(
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller)))
            : SizedBox(
                height: size.height,
                width: size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/thekidzit.mp4')
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((value) {
        _controller.setVolume(0.2);
        _controller.play();
      });

    getuserData().then((value) {

      if (["", 'null', null, 0, false].contains(value) == false ||
          value.isNotEmpty) {
        Map<String,dynamic> data = json.decode(value) as Map<String,dynamic>;
        data.putIfAbsent('ovulation', () => '0000-00-00');
        if (data.isNotEmpty) {
          if (data['ovulation'].contains('0000-00-00') &&
              data['period'].contains('0000-00-00')) {
            Future.delayed(const Duration(seconds: 6), () async {
              Navigator.of(context).pushReplacementNamed(Selection.tag);
            });
          } else {
            Future.delayed(const Duration(seconds: 6), () async {
              Navigator.of(context).pushReplacementNamed(ContainerScreen.tag);
            });
          }
        }
      } else {
        Future.delayed(const Duration(seconds: 6), () async {
          Navigator.of(context).pushReplacementNamed(Introduction.tag);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
