import 'package:flutter/material.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/tools/announcements/announcement.dart';
import 'package:kidzit/tools/events/allevents.dart';
import 'package:kidzit/tools/hospitaltips/hospital.dart';
import 'package:kidzit/tools/kiktracker/kikscreen.dart';
import 'package:kidzit/tools/prayers/prayerscreen.dart';
import 'package:kidzit/tools/watertracker/watertracker.dart';

class Tools extends StatefulWidget {
  const Tools({Key? key}) : super(key: key);

  @override
  _ToolsState createState() => _ToolsState();
}

const List<String> title = [
  'Water Trackers',
  'Kick Meter',
  'Announcements',
  'Daily Diary',
  'Hospital Checklist',
  'Prayers'
];

List icondata = [
  Image.asset(
    'assets/tools/water.JPEG',
    height: 75,
  ),
  Image.asset(
    'assets/tools/kick.JPEG',
    height: 75,
  ),
  Image.asset(
    'assets/tools/announcement.JPEG',
    height: 75,
  ),
  Image.asset(
    'assets/tools/diary.JPEG',
    height: 75,
  ),
  Image.asset(
    'assets/tools/hospital.JPEG',
    height: 75,
  ),
  Image.asset(
    'assets/tools/prayer.JPEG',
    height: 75,
  )
];

const List<String> navigatonAddress = [
  WaterTracker.tag,
  KicksTracker.tag,
  AnnounceMents.tag,
  Events.tag,
  Hospital.tag,
  PrayerScreen.tag
];

class _ToolsState extends State<Tools> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple.shade200,
        leading: IconButton(onPressed: (){
          Navigator.pushNamedAndRemoveUntil(context, ContainerScreen.tag, (route) => false);
        }, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
        title: const Text(
          'My Tools',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'SourceSandPro',),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.grey.shade100, Colors.purple.shade200.withOpacity(0.7)],
                center: Alignment.topLeft,
                radius: 3),
          ),
          child: SingleChildScrollView(
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: icondata.length,
                padding: const EdgeInsets.only(bottom: 70, top: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(navigatonAddress[index]);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          icondata[index],
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            title[index],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
