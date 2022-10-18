import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kidzit/selection/pregnancycycle.dart';
import 'package:kidzit/selection/trackmycycle.dart';

class Selection extends StatelessWidget {
  static const tag = '-/selectionScreen';

  Selection({Key? key}) : super(key: key);
  final List images = ['assets/calendar.png', 'assets/pregnancy.png'];
  final List text = ['Track my cycle', 'I\'m already pregnant'];
  final List adrress = [TrackMyCycle.tag, Pregnancy.tag];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                    selectedTileColor: Colors.purple.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Colors.purple.shade100,
                    contentPadding: EdgeInsets.only(top: 10),
                    title: Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                      height: 75,
                      color: Colors.black54,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Text(
                        text[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          adrress[index]);
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
