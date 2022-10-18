
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidzit/calender/calender.dart';
import 'package:kidzit/home/home.dart';
import 'package:kidzit/selection/showcalendar.dart';
import 'package:kidzit/tools/tools.dart';
import 'package:kidzit/useraccount/useraccount.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final key  = GlobalKey<_ContainerScreenState>();
class ContainerScreen extends StatefulWidget {
  static const tag = '-/Containerscreen';

  const ContainerScreen({Key? key}) : super(key: key);

  @override
  _ContainerScreenState createState() => _ContainerScreenState();
}

List<String> Title = ['Home', 'Calendar', 'Tools', 'Account'];


List<int> position = [0, 1, 2, 3];

var user;
bool userdate = false;
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
  return myMap;
}
int count = 0;
int index = 0;

class _ContainerScreenState extends State<ContainerScreen> {
  @override
  initState(){
    setState(() {
      index = 0;
    });
    super.initState();
  }

  Widget loadscreen() {
    print("parshu "+user['ovulation']);
    switch (index) {
      case 0:
        return user['ovulation'].contains('0000-00-00')==false? HomePage(): const ShowCalender();
      case 1:
        return const Calender();
      case 2:
        return const Tools();
      case 3:
        return const UserAccount();
      default:
        return user['ovulation'].contains('0000-00-00')==false? HomePage(): const ShowCalender();
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    getuserData().then((value){
      setState(() {
        userdate = true;
      });
    });

    return WillPopScope(
      onWillPop: () async {
        if (count < 1) {
          var appDir = (await getTemporaryDirectory()).path;
           Directory(appDir).delete(recursive: true);
          Fluttertoast.showToast(msg: 'Press back one more time to exit');
          count++;
          return false;
        } else {
          SystemNavigator.pop();
          return true;
        }
      },
      child: Material(
        child: userdate ? Stack(
          children: [
            loadscreen(),
            Positioned(
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                height: Platform.isIOS ? 75 : 70,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50.withBlue(240).withGreen(240),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage('assets/home.png'),
                              size: 30,
                              color: index == position[0]
                                  ? Colors.pink
                                  : Colors.black,
                            ),
                            Text(
                              Title[0],
                              style: TextStyle(
                                fontWeight: index == position[0]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: index == position[0]
                                    ? Colors.pink
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage('assets/calendar.png'),
                              size: 30,
                              color: index == position[1]
                                  ? Colors.pink
                                  : Colors.black,
                            ),
                            Text(
                              Title[1],
                              style: TextStyle(
                                fontWeight: index == position[1]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: index == position[1]
                                    ? Colors.pink
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {

                        if(user['ovulation'].contains('0000-00-00')){

                          showDialog(context: context, builder: (_){
                            return AlertDialog(
                              title: const Text('Subscription'),
                              content: const Text('This feature is avaliable post pregnancy'),
                              actions: [MaterialButton(onPressed: (){
                                Navigator.of(context).pop();
                              }, child: const Text('Ok'),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,)],
                            );
                          });

                        }else {
                          setState(() {
                            index = 2;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage('assets/more_time.png'),
                              size: 35,
                              color: index == position[2]
                                  ? Colors.pink
                                  : Colors.black,
                            ),
                            Text(
                              Title[2],
                              style: TextStyle(
                                fontWeight: index == position[2]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: index == position[2]
                                    ? Colors.pink
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                          setState(() {
                            index = 3;
                          });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage('assets/user.png'),
                              size: 30,
                              color: index == position[3]
                                  ? Colors.pink
                                  : Colors.black,
                            ),
                            Text(
                              Title[3],
                              style: TextStyle(
                                fontWeight: index == position[3]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: index == position[3]
                                    ? Colors.pink
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ): const Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
