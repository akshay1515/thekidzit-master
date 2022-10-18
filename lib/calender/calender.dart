import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kidzit/calender/calendarscreen.dart';
import 'package:kidzit/calender/events.dart';
import 'package:kidzit/container/containerscreen.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

List<String> views = ['Calendar', 'Events'];

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: DefaultTabController(
        length: views.length,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
              primary: true,
              backgroundColor: Colors.purple.shade200,
              automaticallyImplyLeading: false,
              leading: IconButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, ContainerScreen.tag, (route) => false);
              }, icon: Icon(Icons.arrow_back_rounded,color: Colors.white,)),
              centerTitle: true,
              title: Text('Event Calender',style: TextStyle(fontFamily: 'SourceSandPro',fontSize: 20,fontWeight: FontWeight.bold)),
              titleSpacing: 0,
              bottom: TabBar(
                  isScrollable: true,
                  automaticIndicatorColorAdjustment: true,
                  indicatorColor: Colors.white,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  tabs: List<Widget>.generate(views.length, (index) {
                    return Tab(
                      child: Text(
                        views[index],
                        style: TextStyle(fontSize: 18,fontFamily: 'SourceSandPro',),
                      ),
                    );
                  })),
            ),
            body: const TabBarView(children: [
              CalendarScreen(),
              AllEvents(),
            ])),
      ),
    );
  }

  @override
  void initState() {

    super.initState();
  }

}
