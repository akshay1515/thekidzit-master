import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/tools/watertracker/waterprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTracker extends StatefulWidget {
  static const tag = '-/watertracker';

  const WaterTracker({Key? key}) : super(key: key);

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  var user;
  bool isLoading = false;

  showmessage(String message, bool status) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(status ? 'Error....' : 'Be Patience'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Text(message),
            actions: [
              status
                  ? MaterialButton(
                      color: Colors.purple.shade200,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    )
                  : Container()
            ],
          );
        });
  }

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
    final watertrack = Provider.of<WaterProvider>(context);
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;
    if (!isLoading) {
      getuserData().then((value) {
        Map waterdetails = {'userid': user['userid'], 'deviceid': deviceid};
        watertrack.getWater(waterdetails).then((value) {
          setState(() {
            isLoading = true;
          });
        });
      });
    }
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: const Text('Water Tracker',style: TextStyle(fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold,fontSize: 20),),
        centerTitle: true,
      ),
      body: isLoading
          ? ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    showmessage('Please sit and Drink water', false);
                    Map waterdetails = {
                      'userid': user['userid'],
                      'deviceid': deviceid
                    };
                    watertrack.drinkWater(waterdetails).then((value) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      Navigator.of(context).pop();
                      showmessage(error.toString(), true);
                    });
                  },
                  child: const Text(
                    'Drink a glass of water',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  color: Colors.purple.shade200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              watertrack.items.isNotEmpty
                  ? Container(
                    height: size.height*0.8,
                    padding: EdgeInsets.only(bottom: 30),
                    child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: watertrack.items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors
                                    .primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                    .shade100,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy').format(DateTime.parse(watertrack.items[index].date.toString())),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  '${watertrack.items[index].noOfGlasses}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'No. of Glass Water Consumed Today',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const Spacer()
                              ],
                            ),
                          );
                        }),
                  )
                  : SizedBox(
                      height: size.height,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            color: Colors.grey.shade500,
                            size: 150,
                          ),
                          Text(
                            'No record found yet',
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          )
                        ],
                      ))
            ],
          )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
