import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/tools/events/diaryprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDiary extends StatefulWidget {
  static const tag = '-/AddDiaryEvent';

  const AddDiary({Key? key}) : super(key: key);

  @override
  _AddDiaryState createState() => _AddDiaryState();
}

class _AddDiaryState extends State<AddDiary> {
  bool isLoading = false;
  bool isFirst = true;
  var user ;
  final TextEditingController _descriptioncontroller = TextEditingController();
  var deviceid;

  Future<Map> getuserData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final temp = _preferences.getString('userid');
    if (temp != null) {
      user = _preferences.getString('userid').toString();
    }
    user = user.replaceAll('{','');
    user = user.replaceAll('}','');
    user = user.replaceAll('"', '');

    var used = user.split(",");
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
    user = myMap;
    return myMap;
  }

  @override
  Widget build(BuildContext context) {
    final modal = ModalRoute.of(context)!.settings.arguments as Map;
    getuserData().then((value) {
      if(modal['data'] == null){
        setState(() {
          isLoading = true;
        });
      }
      deviceid = Provider.of<LoginProvider>(context, listen: false).identifier;
    });

    if (isLoading == false && modal['data'] != null && isFirst) {
      _descriptioncontroller.text = modal['data'].text;
      setState(() {
        isFirst = false;
        isLoading = true;
      });
    }

    final addevent = Provider.of<DiaryProvider>(context, listen: false);

    return isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple.shade200,
              centerTitle: true,
              title: const Text('Add Diary Event',style: TextStyle(fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold,fontSize: 20)),
              leading: Tooltip(
                message: 'Close',
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 30,
                      semanticLabel: 'Close',
                    )),
              ),
              actions: [
                Tooltip(
                  message: 'Add Note',
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        Map userDetails = {
                          'userid': user['userid'],
                          'imei': deviceid,
                          'data': DateFormat('yyyy-mm-dd').format(
                              DateTime.now().subtract(const Duration(days: 1))),
                          'note': _descriptioncontroller.text
                        };
                        addevent.addDiary(userDetails).then((value) {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          Navigator.of(context).pop();
                        });
                      },
                      icon: const Icon(
                        Icons.check,
                        size: 30,
                      )),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _descriptioncontroller,
                keyboardType: TextInputType.multiline,
                maxLines: 30,
                decoration: InputDecoration(
                  focusColor: Colors.transparent,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Create Note Here',
                  labelStyle: TextStyle(color: Colors.purple.shade300),
                  contentPadding: const EdgeInsets.only(
                      left: 15, right: 5,),
                  alignLabelWithHint: true,
                ),
              ),
            ),
          )
        : const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
