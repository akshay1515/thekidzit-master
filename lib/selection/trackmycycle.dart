import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/selection/selctionprovider.dart';
import 'package:kidzit/selection/showcalendar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackMyCycle extends StatefulWidget {
  static const tag = '-/trackmycycle';

  const TrackMyCycle({Key? key}) : super(key: key);

  @override
  _TrackMyCycleState createState() => _TrackMyCycleState();
}

var datetime = DateTime.now();
var selected = DateTime.now();

class _TrackMyCycleState extends State<TrackMyCycle> {
  var user;
  bool isLoading = false;
  Map tempMap = Map();
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
      myMap[key[i]] = value[i];
    }
    user = myMap;
    tempMap.addAll(user);
    return myMap;
  }

  updateMap(String Date) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    tempMap['period'] = Date;
    _prefs.setString('userid', json.encode(tempMap));
  }

  @override
  Widget build(BuildContext context) {
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;

    showMessage() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Please Wait...',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              content: Text('We are setting up your period cycle calendar...'),
            );
          });
    }

    if (isLoading == false) {
      getuserData().then((value) {
        user = {'userid': user['userid'], 'imei': deviceid};
        setState(() {
          isLoading = true;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: const Text('Menstruation Date Cycle',style:TextStyle(fontFamily: 'SourceSandPro',fontSize: 20,fontWeight: FontWeight.bold)),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      body: isLoading
          ? Column(
              children: [
                CalendarDatePicker(
                    initialCalendarMode: DatePickerMode.day,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                        datetime.year, datetime.month - 1, datetime.day),
                    lastDate: DateTime.now(),
                    onDateChanged: (date) {
                      setState(() {
                        selected = date;
                      });
                    }),
                MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      showMessage();
                      Map userdetails = {
                        'imei': user['imei'],
                        'userid': user['userid'],
                        'date': DateFormat('yyyy-MM-dd').format(selected),
                        'type': 'period',
                        'gender': 'mother',
                      };

                      Provider.of<SelectionProvider>(context, listen: false)
                          .setUserDate(userdetails)
                          .then((value) {
                        updateMap(DateFormat('yyyy-MM-dd').format(selected));
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(ShowCalender.tag);
                      });
                    },
                    color: Colors.purple.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textColor: Colors.white,
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ))
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
