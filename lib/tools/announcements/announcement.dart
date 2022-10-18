import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/tools/announcements/accouncement_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnounceMents extends StatefulWidget {
  static const tag = '-/announcements';

  const AnnounceMents({Key? key}) : super(key: key);

  @override
  State<AnnounceMents> createState() => _AnnounceMentsState();
}

class _AnnounceMentsState extends State<AnnounceMents> {
  var user;
  bool isLoading = false;

  Future<Map> getuserData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final temp = _preferences.getString('userid');
    if (temp != null) {
      user = _preferences.getString('userid').toString();
    }
    user.replaceAll('{', user);
    user.replaceAll('}', user);
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

  _showImage(String Url, BuildContext context) {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.8),
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Material(
            color: Colors.transparent,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            onLoading(true);
                         shareImage(Url);
                          },
                          icon: Icon(
                            Icons.share_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          Url,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        num.parse(loadingProgress
                                            .expectedTotalBytes
                                            .toString())
                                    : null,
                              ),
                            );
                          },
                          fit: BoxFit.fill,

                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void shareImage(String url) async{
    final response = await get(Uri.parse(url));
    await get(Uri.parse(url)).then((value){
    onLoading(false);
    });
    final Directory temp = await getTemporaryDirectory();
    final File imagefile = File('${temp.path}/images.png');
    imagefile.writeAsBytesSync(response.bodyBytes);
    Share.shareFiles(['${temp.path}/images.png'],);
  }

  void onLoading(bool t) {
    if (t==true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return SimpleDialog(
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
                Center(child: Text('Getting Image ready'))
              ],
            );
          });
    }else{
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Provider.of<AnnouncementProvider>(context);
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;
    if (!isLoading) {
      getuserData().then((value) {
        user = {'userid': user['userid'], 'imei': deviceid};
      }).then((value) {
        Provider.of<AnnouncementProvider>(context, listen: false)
            .getAnnouncement(user)
            .then((value) {
          setState(() {
            isLoading = true;
          });
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: Text('Announcements',style: TextStyle(fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold,fontSize: 20)),
        centerTitle: true,
      ),
      body: isLoading
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 5 / 4.5),
              padding: EdgeInsets.only(top: 10),
              itemCount: data.items.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      _showImage(data.items[index].image.toString(), context);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: size.height * 0.4,
                          child: Image.network(
                            data.items[index].image.toString(),
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress){
                              if (loadingProgress == null) return child;

                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      num.parse(loadingProgress
                                          .expectedTotalBytes
                                          .toString())
                                      : null,
                                ),
                              );

                            },
                            fit: BoxFit.fill,
                            width: size.width,
                          ),
                        )),
                  ),
                );
              })
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
