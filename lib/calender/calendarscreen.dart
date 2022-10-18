import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/calender/taskmodel.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calendar_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

TextEditingController _titlecontroller = TextEditingController();
TextEditingController _contentController = TextEditingController();
var user ;
bool isLoading = false;
GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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

showdialog(BuildContext context, DateTime date) {
  showDialog(
      context: context,
      builder: (_) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 355,
              width: 500,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        SizedBox(width: 5),
                        Text(
                          '${DateFormat('dd-MMM-yyyy').format(date)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.clear),
                          tooltip: 'Close',
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _titlecontroller,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          focusColor: Colors.purple.shade100,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.purple.shade100, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple.shade100),
                              borderRadius: BorderRadius.circular(20)),
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                              left: 25, right: 5, top: 15, bottom: 15),
                          alignLabelWithHint: true,
                          labelText: 'Task Title'),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Title is required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _contentController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.go,
                      maxLines: 4,
                      decoration: InputDecoration(
                          focusColor: Colors.purple.shade100,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.purple.shade100, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple.shade100),
                              borderRadius: BorderRadius.circular(20)),
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                              left: 25, right: 5, top: 15, bottom: 15),
                          alignLabelWithHint: true,
                          labelText: 'Task Details'),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Task detail is required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.red.shade300,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.purple.shade200,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  _showalertDialog(
                                      context,
                                      false,
                                      'Adding event',
                                      'Adding Event to your Calendar');
                                  Map taskDetails = {
                                    'title': _titlecontroller.text,
                                    'content': _contentController.text,
                                    'date':
                                        DateFormat('yyyy-mm-dd').format(date),
                                    'imei': user['deviceid'],
                                    'userid': user['userid']
                                  };
                                  Provider.of<CalendarProvider>(context,
                                          listen: false)
                                      .addNewTask(taskDetails)
                                      .then((value) {
                                    if (value.isNotEmpty) {
                                      Navigator.of(context).pop();
                                      if (value['ack'] == true) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    'Task Created Successfully',
                                                toastLength: Toast.LENGTH_SHORT)
                                            .then((value) {
                                          _titlecontroller.clear();
                                          _contentController.clear();
                                          Navigator.of(context).pop();
                                        });
                                      } else {
                                        _showalertDialog(context, true,
                                            'Error...', value['message']);
                                      }
                                    }
                                  });
                                }
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}

_showalertDialog(
    BuildContext context, bool status, String Title, String message) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(Title),
          content: Text(message),
          actions: [
            status
                ? MaterialButton(
                    color: Colors.purple.shade200,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
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

showInfo(BuildContext context, TaskModel taskModel) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.purple.shade300,
                                  width: 0.8,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          child: Row(
                            children: [
                              Center(
                                  child: Text(
                                taskModel.title!.toUpperCase().toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height*0.3,
                          maxHeight: MediaQuery.of(context).size.height * 0.6),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                            top: BorderSide(
                                color: Colors.purple.shade300,
                                width: 0.8,
                                style: BorderStyle.solid),
                            bottom: BorderSide(
                                color: Colors.purple.shade300,
                                width: 0.8,
                                style: BorderStyle.solid),
                            right: BorderSide(
                                color: Colors.purple.shade300,
                                width: 0.8,
                                style: BorderStyle.solid),
                            left: BorderSide(
                                color: Colors.purple.shade300,
                                width: 0.8,
                                style: BorderStyle.solid)),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          taskModel.description.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0, bottom: 8),
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.red.shade300,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime dateTime = DateTime.now();
    final task = Provider.of<CalendarProvider>(context);
    final deviceid = Provider.of<LoginProvider>(context).identifier;
    if (!isLoading) {
      getuserData().then((value) {
        user = {'userid': user['userid'], 'deviceid': deviceid};
        Provider.of<CalendarProvider>(context, listen: false).getTask(
            {'userid': user['userid'], 'imei': deviceid}).then((value) {
          if (mounted){
            setState(() {
              isLoading = true;
            });
        }
        });
      });
    }

    return isLoading
        ? Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.purple.shade100.withOpacity(0.5),
            Colors.purple.shade100.withOpacity(0.4),
            Colors.purple.shade100.withOpacity(0.3),
            Colors.purple.shade100.withOpacity(0.2),
            Colors.purple.shade100.withOpacity(0.1),
            Colors.white
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CalendarDatePicker(
                    initialCalendarMode: DatePickerMode.day,
                    initialDate: dateTime,
                    firstDate: dateTime,
                    lastDate: DateTime(2050),
                    onDateChanged: (date) {
                      setState(() {
                        dateTime = date;
                      });
                      showdialog(context, date);
                    }),
                Text(
                  task.recentitems.isNotEmpty?'Weekly Events':'',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
                SizedBox(
                  height: 10,
                ),
                task.recentitems.isNotEmpty
                    ? GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: task.recentitems.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 10),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, childAspectRatio: 3.5),
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              showInfo(context, task.recentitems[index]);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors
                                  .primaries[Random()
                                  .nextInt(Colors.primaries.length)]
                                  .shade50,
                              margin: EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 6.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          task.recentitems[index].title!
                                              .toUpperCase()
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                            DateFormat('dd-MMM-yyyy').format(
                                                DateTime.parse(task
                                                    .recentitems[index].date
                                                    .toString())),
                                            textAlign: TextAlign.start),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.5,
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: size.width * 0.85,
                                            child: Text(
                                              task.recentitems[index]
                                                  .description
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                          Container(
                                            transform: Matrix4.translationValues(0, 5, 0),
                                            child: Center(
                                                child: Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  color: Colors.grey.shade700,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 125,
                              color: Colors.grey.shade400,
                            ),
                            Text(
                              'You don\'t have any task listed yet',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        )
        : Container(child: Center(child: CircularProgressIndicator()));
  }

  @override
  void initState() {

    super.initState();
  }


}
