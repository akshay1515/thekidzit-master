
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/tools/kiktracker/kikprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KicksTracker extends StatefulWidget {
  static const tag = '-/kicktracker';

  const KicksTracker({Key? key}) : super(key: key);

  @override
  State<KicksTracker> createState() => _KicksTrackerState();
}

class _KicksTrackerState extends State<KicksTracker> {
  var user ;
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
    return myMap;
  }

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

  @override
  Widget build(BuildContext context) {
    final kiktrack = Provider.of<KikProvider>(context);
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;
    if (!isLoading) {
      getuserData().then((value) {
        Map waterdetails = {'userid': user['userid'], 'deviceid': deviceid};
        kiktrack.getWater(waterdetails).then((value) {
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
        title: const Text('Kick Tracker',style: TextStyle(fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold,fontSize: 20),),
        centerTitle: true,
      ),
      body: isLoading
          ? SizedBox(
              width: size.width,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        showmessage(
                            'It\'s Awesome to experience kick from your womb',
                            false);
                        Map waterdetails = {
                          'userid': user['userid'],
                          'deviceid': deviceid
                        };
                        kiktrack.insertkik(waterdetails).then((value) {
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          Navigator.of(context).pop();
                          showmessage(error.toString(), true);
                        });
                      },
                      child: const Text(
                        'Experienced A Kick',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      color: Colors.purple.shade200,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    kiktrack.items.isNotEmpty
                        ? Container(
                          height: size.height*0.8,
                          padding: EdgeInsets.only(bottom: 30),
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: kiktrack.items.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (_, index) {
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
                                        DateFormat('dd MMM yyyy').format(DateTime.parse(kiktrack.items[index].date.toString())),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 75,
                                        width: 75,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              'assets/kick.png',
                                              color: Colors.black,
                                              fit: BoxFit.fill,
                                            ),
                                            Center(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                '${kiktrack.items[index].kiks}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Text(
                                        'No. of Kick Experienced Today',
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
                ),
              ),
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
