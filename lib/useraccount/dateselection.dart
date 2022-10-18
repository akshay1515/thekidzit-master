import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kidzit/useraccount/dateupdate.dart';
import 'package:kidzit/useraccount/pregnancydateupdate.dart';

class UpdateSelection extends StatelessWidget {
  static const tag = '-/updateselectionScreen';

  UpdateSelection({Key? key}) : super(key: key);
  final List images = ['assets/calendar.png', 'assets/pregnancy.png'];
  final List text = ['Update my cycle', 'Update pregnancy date'];
  final List adrress = [UpdateDate.tag, PregnancyUpdate.tag];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: const Text(
          'Update Dates',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'SourceSandPro',fontSize: 20,),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.builder(
              shrinkWrap: true,
              itemCount: text.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 4 / 3.6),
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    selectedTileColor: Colors.purple.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: Colors.purple.shade100,
                    contentPadding: const EdgeInsets.only(top: 10),
                    title: Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                      height: 75,
                      color: Colors.black54,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8,left: 8,right:8),
                      child: Text(
                        text[index],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(adrress[index]);
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
