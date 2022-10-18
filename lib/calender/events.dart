import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/calender/calendar_provider.dart';
import 'package:kidzit/calender/taskmodel.dart';
import 'package:provider/provider.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({Key? key}) : super(key: key);

  @override
  _AllEventsState createState() => _AllEventsState();
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
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.purple.shade300,
                                  width: 0.8,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            taskModel.title!.toUpperCase().toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Details',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height*0.3,
                          maxHeight: MediaQuery.of(context).size.height * 0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.red.shade300,
                          child: const Text(
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

class _AllEventsState extends State<AllEvents> {
  @override
  Widget build(BuildContext context) {
    final task = Provider.of<CalendarProvider>(context);
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.white, Colors.purple.shade100],
               center: Alignment.topLeft,radius: 8)),
        child: SingleChildScrollView(
          child: Column(
            children: [
             const SizedBox(
                height: 8,
              ),
              Text(
                task.items.isNotEmpty?'All Events':'',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 19),
              ),
              const SizedBox(
                height: 8,
              ),
              task.items.isNotEmpty
                  ? GridView.builder(
                padding: const EdgeInsets.only(right: 8,bottom: 70),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4/5,
                      ),
                      itemCount: task.items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            showInfo(context, task.items[index]);
                          },
                          child: Card(
                            color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade50,
                            margin: const EdgeInsets.only(left: 8, bottom: 8),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 2, right: 2),
                                  child: Text(
                                    task.items[index].title!
                                        .toUpperCase()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  width: size.width,
                                  decoration: const BoxDecoration(),
                                  padding: const EdgeInsets.only(
                                      bottom: 4, left: 8, right: 4),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      DateFormat('dd-MMM-yyyy').format(
                                          DateTime.parse(task
                                              .items[index].date
                                              .toString())),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    child: Text(
                                      task.items[index].description
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: Platform.isIOS?6:8,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : SizedBox(
                      height: size.height-150,
                      width: size.width,
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
                          ),
                          const SizedBox(height:70)
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }
}
