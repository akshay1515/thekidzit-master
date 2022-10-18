import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/selection/selctionprovider.dart';
import 'package:kidzit/useraccount/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PregnancyUpdate extends StatefulWidget {
  static const tag = '-/pregnancyUpdatecycle';

  const PregnancyUpdate({Key? key}) : super(key: key);

  @override
  _PregnancyUpdateState createState() => _PregnancyUpdateState();
}

var datetime = DateTime.now();
var selectedtime;
String selected = '';

class _PregnancyUpdateState extends State<PregnancyUpdate> {
  var user;
  bool isLoading = false;
  int count = 0;
  Map tempMap = Map();
  Future<Map> getuserData() async {

    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final temp = _preferences.getString('userid');
    if (temp != null) {
      user = _preferences.getString('userid').toString();
    }
    user = user.replaceAll('{','');
    user = user.replaceAll('}','');
    user = user.replaceAll('"','');

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
      myMap[key[i]] = value[i];
    }
    user = myMap;
    tempMap.addAll(myMap);
    return myMap;
  }



  showLoading() {
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
              title: Text(
                'Updating...',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                  'Please wait while your conceive date id being updated.'),
            ));
  }

  printUser() {
    final select =
        Provider.of<UserProvider>(context, listen: false).userdetails;
    selected = select['status'];
    if (select['ovulation'].toString().contains('0000-00-00')) {
    } else {
      datetime = DateTime.parse(select['ovulation'].toString());
    }
  }

  updateMap(String Date) async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    tempMap['ovulation'] = Date;
    _prefs.setString('userid', json.encode(tempMap));
  }

  @override
  Widget build(BuildContext context) {
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;
    getuserData().then((value) {
      var temp = value['userid'];
      user.clear();
      user = {'imei': deviceid, 'userid': temp};

    });
    printUser();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade200,
          title: const Text('Update Concieve Date',style: TextStyle(fontFamily: 'SourceSandPro',fontSize: 20,fontWeight: FontWeight.bold),),
          centerTitle: true,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CalendarDatePicker(
                  initialCalendarMode: DatePickerMode.day,
                  initialDate: datetime,
                  firstDate: DateTime(
                      datetime.year, datetime.month - 9, datetime.day),
                  lastDate: DateTime(
                      datetime.year, datetime.month + 9, datetime.day),
                  onDateChanged: (date) {
                    setState(() {
                      selectedtime = date;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  showLoading();
                  Map userdetails = {
                    'imei': user['imei'],
                    'userid': user['userid'],
                    'date': DateFormat('yyyy-MM-dd').format(selectedtime),
                    'type': 'conceive',
                    'gender': selected,
                  };
                  Provider.of<SelectionProvider>(context, listen: false)
                      .setUserDate(userdetails)
                      .then((value) {
                        updateMap(DateFormat('yyyy-MM-dd').format(selectedtime));
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(
                          msg: 'Conceive date Updated Successfully',
                          toastLength: Toast.LENGTH_LONG);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ContainerScreen.tag, (route) => false);

                  });
                },
                color: Colors.purple.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textColor: Colors.white,
                child: const  Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              )
            ],
          ),
        ));
  }
}
