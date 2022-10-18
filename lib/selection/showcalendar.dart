import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/useraccount/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShowCalender extends StatefulWidget {
  static const tag = '-/showCalendar';

  const ShowCalender({Key? key}) : super(key: key);

  @override
  _ShowCalenderState createState() => _ShowCalenderState();
}

var datetime = DateTime.now();
var selected;

enum isRadius { left, right, no, next, selected }

List<Color> indicationColor = [
  Colors.purple.shade300.withOpacity(0.3),
  Colors.green.shade200,
  Colors.green.shade600,
  Colors.pink.shade200,
  Colors.orangeAccent,
  Colors.lightBlueAccent,
  Colors.grey.shade50
];
List<String> indicationText = [
  'Selected Date',
  'Safe Date',
  'Fertile Date',
  'Ovulation Date',
  'Post Ovulation Date',
  'Next Mensuration Date',
  'Disabled Date'
];
List<Color> indicationBorder = [
  Colors.purple,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white
];
var user;

bool isLoading = false;
int count = 0;
Map tempMap = {};
DateTime _dateTime = DateTime.now();
CalendarController _calendarController1 = CalendarController();
CalendarController _calendarController2 = CalendarController();
DateTime _safeFrom = DateTime.now();
DateTime _safeTo = DateTime.now();
DateTime _fertileFrom = DateTime.now();
DateTime _fertileTo = DateTime.now();
DateTime _ovulationFrom = DateTime.now();
DateTime _ovulationTo = DateTime.now();
DateTime _postFrom = DateTime.now();
DateTime _postTo = DateTime.now();
DateTime _nextdate = DateTime.now();

List<DateTime> safedate = [];
List<DateTime> fertiledate = [];
List<DateTime> ovulationdate = [];
List<DateTime> postdate = [];
bool isAlert = false;
bool isload = true;


class _ShowCalenderState extends State<ShowCalender> {


  Future getDate(Map map) async {

      Provider.of<UserProvider>(context, listen: false)
          .getUserDate(map)
          .then((value) {
        if(mounted) {
          setState(() {
            _safeFrom = DateTime.parse(value['date'][0]['from']);
            _safeTo = DateTime.parse(value['date'][0]['to']);
            _fertileFrom = DateTime.parse(value['date'][1]['from']);
            _fertileTo = DateTime.parse(value['date'][1]['to']);
            _ovulationFrom = DateTime.parse(value['date'][2]['from']);
            _ovulationTo = DateTime.parse(value['date'][2]['to']);
            _postFrom = DateTime.parse(value['date'][3]['from']);
            _postTo = DateTime.parse(value['date'][3]['to']);
            _nextdate = DateTime.parse(value['date'][4]['date']);
            isLoading = true;
          });
        }
        if (isAlert) {
          // Navigator.of(context).pop();
          Navigator.pop(context);
          isAlert = false;
        }
      });

  }

  changescreen() {
    Navigator.of(context).pushReplacementNamed(ContainerScreen.tag);
  }

  Future<Map> getuserData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final temp = _preferences.getString('userid');
    if (temp != null) {
      user = _preferences.getString('userid').toString();
    }
    user = user.replaceAll('{', '');
    user = user.replaceAll('}', '');
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
    tempMap = myMap;
    return myMap;
  }

  void onCalendarTapped(CalendarTapDetails details) {
    isAlert = true;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Updating...'),
            content: const Text('Updating your Mensuration Calendar'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;
    final userdetails = Provider.of<UserProvider>(context);

    if (isLoading == true && count == 0) {
      if (userdetails.userdetails['period'].contains('0000-00-00')) {
      } else {
        setState(() {
          _dateTime = DateTime.parse(userdetails.userdetails['period']);
        });
      }
    }

    if (isLoading == false) {
      getuserData().then((value) {
        user = {'userid': user['userid'], 'imei': deviceid};
        Provider.of<UserProvider>(context, listen: false)
            .getUserdetails(user)
            .then((value) {
              if(mounted) {
                getDate({
                  "apiVersion": "1.0",
                  "imei": deviceid,
                  "userId": user['userid'],
                  "date": userdetails.userdetails['period'],
                  "type": "not Concieve",
                  "motherOrFather": "mother"
                }).then((value) {});
              }
        });
      });
    }

    void calendar1ViewChanged(ViewChangedDetails viewChangedDetails) {
      SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
        if (_calendarController1.displayDate!.compareTo(_dateTime) == 0) {
          _calendarController2.displayDate = DateTime(
              _calendarController1.displayDate!.year,
              _calendarController1.displayDate!.month + 1,
              _calendarController1.displayDate!.day);
        } else {
          _calendarController2.displayDate = DateTime(
              _calendarController1.displayDate!.year,
              _calendarController1.displayDate!.month - 1,
              _calendarController1.displayDate!.day);
        }
      });
    }

    void calendar2ViewChanged(ViewChangedDetails viewChangedDetails) {
      SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
        if (_calendarController2.displayDate!.compareTo(_dateTime) == 0) {
          _calendarController1.displayDate = DateTime(
              _calendarController2.displayDate!.year,
              _calendarController2.displayDate!.month + 1,
              _calendarController2.displayDate!.day);
        } else {
          _calendarController1.displayDate = DateTime(
              _calendarController2.displayDate!.year,
              _calendarController2.displayDate!.month - 1,
              _calendarController2.displayDate!.day);
        }
      });
    }

    Widget cellBuilder(BuildContext context, MonthCellDetails details) {
      Color back(MonthCellDetails select) {
        if (select.date.isAfter(
            DateTime(_safeFrom.year, _safeFrom.month, _safeFrom.day - 1)) &&
            select.date.isBefore(
                DateTime(_safeTo.year, _safeTo.month, _safeTo.day + 1))) {
          safedate.add(select.date);
          return Colors.green.shade200;
        }
        else if (select.date.isAfter(DateTime(
            _fertileFrom.year, _fertileFrom.month, _fertileFrom.day - 1)) &&
            select.date.isBefore(DateTime(
                _fertileTo.year, _fertileTo.month, _fertileTo.day + 1))) {
          fertiledate.add(select.date);
          return Colors.green.shade600;
        } else if (select.date.isAfter(DateTime(_ovulationFrom.year,
            _ovulationFrom.month, _ovulationFrom.day - 1)) &&
            select.date.isBefore(DateTime(
                _ovulationTo.year, _ovulationTo.month, _ovulationTo.day + 1))) {
          ovulationdate.add(select.date);
          return Colors.pink.shade200;
        } else if (select.date.isAfter(
            DateTime(_postFrom.year, _postFrom.month, _postFrom.day - 1)) &&
            select.date.isBefore(
                DateTime(_postTo.year, _postTo.month, _postTo.day + 1))) {
          postdate.add(select.date);
          return Colors.orangeAccent;
        } else if (select.date.compareTo(_nextdate) == 0) {
          return Colors.lightBlueAccent;
        } else if (select.date.isBefore(_dateTime) ||
            select.date.isAfter(
                DateTime(_dateTime.year, _dateTime.month + 1, _dateTime.day))) {
          return Colors.grey.shade50;
        } else {
          return Colors.white;
        }
      }

      Color textColor(MonthCellDetails select) {
        if (select.date.isBefore(_dateTime) ||
            select.date.isAfter(
                DateTime(_dateTime.year, _dateTime.month + 1, _dateTime.day))) {
          return Colors.grey;
        } else {
          return Colors.black;
        }
      }

      isRadius iboxRadius(MonthCellDetails select) {
        if (select.date.isAfter(
            DateTime(_safeFrom.year, _safeFrom.month, _safeFrom.day)) &&
            select.date.isBefore(
                DateTime(_safeTo.year, _safeTo.month, _safeTo.day)) ||
            select.date.isAfter(DateTime(
                _fertileFrom.year, _fertileFrom.month, _fertileFrom.day)) &&
                select.date.isBefore(DateTime(
                    _fertileTo.year, _fertileTo.month, _fertileTo.day)) ||
            select.date.isAfter(DateTime(_ovulationFrom.year, _ovulationFrom.month, _ovulationFrom.day)) &&
                select.date.isBefore(DateTime(
                    _ovulationTo.year, _ovulationTo.month, _ovulationTo.day)) ||
            select.date.isAfter(
                DateTime(_postFrom.year, _postFrom.month, _postFrom.day)) &&
                select.date
                    .isBefore(DateTime(_postTo.year, _postTo.month, _postTo.day))) {
          return isRadius.no;
        } else if (select.date.isAtSameMomentAs(
            DateTime(_safeFrom.year, _safeFrom.month, _safeFrom.day)) ||
            select.date.isAtSameMomentAs(DateTime(
                _fertileFrom.year, _fertileFrom.month, _fertileFrom.day)) ||
            select.date.isAtSameMomentAs(DateTime(_ovulationFrom.year,
                _ovulationFrom.month, _ovulationFrom.day)) ||
            select.date.isAtSameMomentAs(
                DateTime(_postFrom.year, _postFrom.month, _postFrom.day))) {
          return isRadius.left;
        } else if (select.date.isAtSameMomentAs(
            DateTime(_nextdate.year, _nextdate.month, _nextdate.day))) {
          return isRadius.next;
        } else if (select.date.isAtSameMomentAs(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day))) {
          return isRadius.selected;
        } else {
          return isRadius.right;
        }
      }

      Color boxColor(MonthCellDetails select) {
        if (select.date.isAfter(
            DateTime(_safeFrom.year, _safeFrom.month, _safeFrom.day - 1)) &&
            select.date.isBefore(
                DateTime(_safeTo.year, _safeTo.month, _safeTo.day + 1))) {
          return Colors.green.shade200;
        } else if (select.date.isAfter(DateTime(
            _fertileFrom.year, _fertileFrom.month, _fertileFrom.day - 1)) &&
            select.date.isBefore(DateTime(
                _fertileTo.year, _fertileTo.month, _fertileTo.day + 1))) {
          return Colors.green.shade600;
        } else if (select.date.isAfter(DateTime(_ovulationFrom.year,
            _ovulationFrom.month, _ovulationFrom.day - 1)) &&
            select.date.isBefore(DateTime(
                _ovulationTo.year, _ovulationTo.month, _ovulationTo.day + 1))) {
          return Colors.pink.shade200;
        } else if (select.date.isAfter(
            DateTime(_postFrom.year, _postFrom.month, _postFrom.day - 1)) &&
            select.date.isBefore(
                DateTime(_postTo.year, _postTo.month, _postTo.day + 1))) {
          return Colors.orangeAccent;
        } else {
          return Colors.white;
        }
      }

      return Container(
        margin: iboxRadius(details) == isRadius.left
            ? const EdgeInsets.only(left: 4, top: 5, bottom: 5)
            : iboxRadius(details) == isRadius.right
            ? const EdgeInsets.only(top: 5, bottom: 5, right: 4)
            : iboxRadius(details) == isRadius.next
            ? EdgeInsets.zero
            : iboxRadius(details) == isRadius.selected
            ? const EdgeInsets.all(10)
            : const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.2),
            borderRadius: iboxRadius(details) == isRadius.left
                ? const BorderRadius.horizontal(left: Radius.circular(20))
                : iboxRadius(details) == isRadius.right
                ? const BorderRadius.horizontal(right: Radius.circular(20))
                : BorderRadius.zero,
            color: boxColor(details)),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(3),
            alignment: Alignment.center,
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            decoration:
            BoxDecoration(color: back(details), shape: BoxShape.circle),
            child: Text(
              details.date.day.toString(),
              style: TextStyle(
                  color: textColor(details),
                  fontSize: (DateTime(details.date.year, details.date.month,
                      details.date.day) ==
                      (DateTime(
                          _dateTime.year, _dateTime.month, _dateTime.day)))
                      ? 13
                      : 11,
                  fontWeight: details.date == _dateTime
                      ? FontWeight.bold
                      : FontWeight.w500),
            ),
          ),
        ),
      );
    }

    BoxDecoration selectionDecortion() {
      return BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple.shade300.withOpacity(0.3),
          border: Border.all(color: Colors.purple, width: 1));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        elevation: 0,
        title: const Text('Menstruation Date Cycle',style:TextStyle(fontFamily: 'SourceSandPro',fontSize: 20,fontWeight: FontWeight.bold)),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        actions: [
          TextButton(
              onPressed: () {
                changescreen();
              },
              child:const Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))
        ],
      ),
      body: isLoading
          ? SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 5, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: const Text(
                          'Indications:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.grey.shade600,
                                    style: BorderStyle.solid))),
                      ),
                      GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: indicationColor.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 5.5),
                          itemBuilder: (_, i) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: indicationColor[i],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: indicationBorder[i],
                                          width: 0.5)),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: size.height * 0.15,
                                  height: size.height * 0.15,
                                  child: Text(
                                    indicationText[i],
                                    maxLines: 2,
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            );
                          }),
                    ],
                  ),
                ),
                Container(
                  decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: SfCalendar(
                      selectionDecoration: selectionDecortion(),
                      controller: _calendarController1,
                      view: CalendarView.month,
                      viewNavigationMode: ViewNavigationMode.none,
                      minDate: _dateTime,
                      maxDate: DateTime(
                          _dateTime.year, _dateTime.month + 1, _dateTime.day),
                      onViewChanged: calendar1ViewChanged,
                      headerDateFormat: 'MMM yyyy',
                      monthViewSettings: const MonthViewSettings(
                          showTrailingAndLeadingDates: false,
                          navigationDirection:
                              MonthNavigationDirection.vertical),
                      initialDisplayDate: DateTime(
                          _dateTime.year, _dateTime.month, _dateTime.day),
                      initialSelectedDate: DateTime(
                          _dateTime.year, _dateTime.month, _dateTime.day),
                      monthCellBuilder: (_, MonthCellDetails details) =>
                          cellBuilder(_, details)),
                ),
                const SizedBox(height:10),
                Container(
                  decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: SfCalendar(
                      selectionDecoration: selectionDecortion(),
                      viewNavigationMode: ViewNavigationMode.none,
                      controller: _calendarController2,
                      minDate: _dateTime,
                      maxDate: DateTime(
                          _dateTime.year, _dateTime.month + 1, _dateTime.day),
                      view: CalendarView.month,
                      headerDateFormat: 'MMM yyyy',
/*                  initialSelectedDate: DateTime(
                    _dateTime.year, _dateTime.month + 1, _dateTime.day),*/
                      onViewChanged: calendar2ViewChanged,
                      monthViewSettings: const MonthViewSettings(
                          navigationDirection:
                              MonthNavigationDirection.vertical,
                          showTrailingAndLeadingDates: false),
                      monthCellBuilder: (_, MonthCellDetails details) =>
                          cellBuilder(_, details)),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(10),
                  color: Colors.purple.shade200,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    changescreen();
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
