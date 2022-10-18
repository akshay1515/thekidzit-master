import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidzit/tools/prayers/prayerprovider.dart';
import 'package:provider/provider.dart';

class PrayerScreen extends StatefulWidget {
  static const tag = "-/prayerpage";

  const PrayerScreen({Key? key}) : super(key: key);

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {

  bool isLoading = false;
  String? url;

  @override
  void initState() {
    super.initState();
  }

  Future<void> launchyoutube(String url) async {

   if(await canLaunch(url)){

     await launch(
         url,
       forceSafariVC: false,
       forceWebView: false,

     );
   }else{
     Fluttertoast.showToast(msg: 'Unable to load video',toastLength: Toast.LENGTH_SHORT );
   }
  }

  @override
  Widget build(BuildContext context) {
    final prayers = Provider.of<PrayerProvider>(context);
    final size = MediaQuery.of(context).size;
    if (!isLoading) {
      Provider.of<PrayerProvider>(context, listen: false)
          .getPrayers()
          .then((value) {
        setState(() {
          isLoading = true;
        });
      });
    }

    return Material(
        child: Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade200,
            title: const Text('Prayers',style: TextStyle(fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold,fontSize: 20),),
            centerTitle: true,
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 6),
            child: ListView.builder(
                itemCount: prayers.items.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      launchyoutube(prayers.items[index].audio.toString());
                    },
                    child: Card(
                      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black38)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.red.shade300,
                              size: 65,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: size.width*0.65,
                              child: Text(
                                prayers.items[index].title.toString(),
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        Visibility(
            visible: !isLoading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ))
      ],
    ));
  }
}
