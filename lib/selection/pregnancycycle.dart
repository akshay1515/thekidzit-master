import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/selection/selctionprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pregnancy extends StatefulWidget {
  static const tag = '-/pregnancycycle';

  const Pregnancy({Key? key}) : super(key: key);

  @override
  _PregnancyState createState() => _PregnancyState();
}

var datetime = DateTime.now();
var selectedtime = DateTime.now();

Map tempMap = Map();
final List images = ['assets/mom.png', 'assets/father.png'];
final List<String> text = ['Mother', 'Father'];
int selected=0;
class _PregnancyState extends State<Pregnancy> {
  var user;
  bool isLoading = false;


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
    tempMap.addAll(user);
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

  updateMap(String Date) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    tempMap['ovulation'] = Date;
    _prefs.setString('userid', json.encode(tempMap));
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;

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
        title: Text('Concieving Date',style:TextStyle(fontFamily: 'SourceSandPro',fontSize: 20,fontWeight: FontWeight.bold)),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      body: isLoading
          ? Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CalendarDatePicker(
                        initialCalendarMode: DatePickerMode.day,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            datetime.year, datetime.month - 9, datetime.day),
                        lastDate: DateTime.now(),
                        onDateChanged: (date) {
                          setState(() {
                            selectedtime = date;
                          });
                        }),
                    SizedBox(height: 20,
                    ),
                    Text(
                      'I\'m Child\'s ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        itemCount: text.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 4 / 3.6),
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              tileColor: selected == index
                                  ? Colors.purple.shade500
                                  : Colors.purple.shade100,
                              title: Image.asset(
                                images[index],
                                fit: BoxFit.contain,
                                height: 100,
                                color: selected == index
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 15),
                                child: Text(
                                  text[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selected == index
                                          ? Colors.white
                                          : Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selected = index;
                                });
                              },
                            ),
                          );
                        }),
                    SizedBox(height: 25),
                    MaterialButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        showLoading();
                        Map Userdetails = {
                          'imei': user['imei'],
                          'userid': user['userid'],
                          'date': DateFormat('yyyy-MM-dd').format(selectedtime),
                          'type': 'conceive',
                          'gender': text[selected].toLowerCase(),
                        };
                        Provider.of<SelectionProvider>(context, listen: false)
                            .setUserDate(Userdetails)
                            .then((value) {
                          updateMap(
                                  DateFormat('yyyy-MM-dd').format(selectedtime))
                              .then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushReplacementNamed(ContainerScreen.tag);
                          });
                        });
                      },
                      color: Colors.purple.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textColor: Colors.white,
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container(child: Center(child: CircularProgressIndicator())),
    );
  }
}
