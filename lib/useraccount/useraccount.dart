import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/login/login.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/packageselection/packageview.dart';
import 'package:kidzit/useraccount/account.dart';
import 'package:kidzit/useraccount/dateselection.dart';
import 'package:kidzit/useraccount/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  var user ;
  bool isLoading = false;

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

  Future logout(BuildContext context, Size size) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
                      )),
                  SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Logout',
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            content: const Text(
              'Are you sure you want to exit KidzIt ?',
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      fixedSize: const Size(60, 60),
                      elevation: 0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.all(8),
                      elevation: 0),
                  onPressed: () async {
                    showLoading();
                    SharedPreferences _prefences =
                        await SharedPreferences.getInstance();
                    user = json.decode(_prefences.getString('userid').toString());
                    _prefences.clear();
                    Navigator.of(context).pop();
                    showLoading();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.tag, (route) => false);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          );
        });
    return user;
  }

  showLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final account = Provider.of<UserProvider>(context);
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;

    if (isLoading == false) {
      getuserData().then((value) {
        user = {'userid': user['userid'], 'imei': deviceid};
        Provider.of<UserProvider>(context, listen: false)
            .getUserdetails(user)
            .then((value) {
          if(mounted){
              setState(() {
            isLoading = true;
          });}
        });
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade200,
          centerTitle: true,
          title: const Text(
            'Account',
            style: TextStyle(fontSize: 20,fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, ContainerScreen.tag, (route) => false);
          }, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
        ),
        body: isLoading
            ? Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.purple.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: Image.asset('assets/avatar.png'))),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  account.userdetails['name'].isEmpty
                                      ? " "
                                      : account.userdetails['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  account.userdetails['email'].isEmpty
                                      ? " "
                                      : account.userdetails['email'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  account.userdetails['mobile'].isEmpty
                                      ? ""
                                      : account.userdetails['mobile'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 4 / 3.25),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(EditUser.tag);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade100),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.account_circle_rounded,
                                      size: 75,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'User Profile',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(UpdateSelection.tag);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade100),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 70,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'My Calendar',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(PackageView.tag, arguments: {
                                'name': account.userdetails['name'],
                                'email': account.userdetails['email'],
                                'mobile': account.userdetails['mobile'],
                                'userid': account.userdetails['id'],
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade100),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.widgets_rounded,
                                      size: 70,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Package',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              logout(context, size);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.purple.shade400,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.exit_to_app_rounded,
                                      size: 70,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )))
            : const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
