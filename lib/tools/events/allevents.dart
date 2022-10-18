import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/tools/events/add_diary.dart';
import 'package:kidzit/tools/events/diarymodel.dart';
import 'package:kidzit/tools/events/diaryprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Events extends StatefulWidget {
  static const tag = '-/allEvents';

  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool isLoading = false;
  var user;

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

  _showDialog(BuildContext context, Diarymodel details) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            contentPadding:
                const EdgeInsets.only(left: 6, right: 6, top: 16, bottom: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
                child: Text(DateFormat('dd-MMM-yyyy')
                    .format(DateTime.parse(details.date.toString())))),
            content: Text(details.text.toString()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diarytrack = Provider.of<DiaryProvider>(context);
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;
    if (!isLoading) {
      getuserData().then((value) {
        Map details = {'userid': user['userid'], 'imei': deviceid};
        Provider.of<DiaryProvider>(context, listen: false)
            .getDiary(details)
            .then((value) {

          setState(() {
            isLoading = true;
          });
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple.shade200,
        title: const Text('Daily Diary',style:TextStyle(fontFamily: 'SourceSandPro',)),
      ),
      body: isLoading
          ? diarytrack.items.length > 0
              ? GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(right: 6),
                  itemCount: diarytrack.items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0, top: 4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors
                                .primaries[Random()
                                    .nextInt(Colors.primaries.length)]
                                .shade100,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 8.0, top: 4.0),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd MMM yyyy').format(
                                        DateTime.parse(diarytrack
                                            .items[index].date
                                            .toString())),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day)
                                          .isAtSameMomentAs(DateTime.parse(
                                              diarytrack.items[index].date
                                                  .toString()))
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                AddDiary.tag,
                                                arguments: {
                                                  'data': diarytrack
                                                      .items[index]
                                                });
                                          },
                                          child: Tooltip(
                                              message: 'Edit Note',
                                              child: ImageIcon(
                                                AssetImage(
                                                    'assets/edit.png'),
                                              )),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _showDialog(
                                    context, diarytrack.items[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    diarytrack.items[index].text
                                        .toString(),
                                    softWrap: true,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          color: Colors.grey.shade500,
                          size: 125,
                        ),
                        Text(
                          'Nothing is added in Diary yet',
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        )
                      ],
                    ),
                  ),
                )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add or Update Task',
        onPressed: () {
          Navigator.of(context).pushNamed(AddDiary.tag,arguments: {
            'data': null
          });
        },
        backgroundColor: Colors.purple.shade200,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
