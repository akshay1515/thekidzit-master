import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/useraccount/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  static const tag = '-/edituser';

  const EditUser({Key? key}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

TextEditingController _name = TextEditingController();
TextEditingController _mobile = TextEditingController();
TextEditingController _ovulationdate = TextEditingController();
TextEditingController _perioddate = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _city = TextEditingController();

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

FocusNode? _nameNode;

class _EditUserState extends State<EditUser> {
  var user;
  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _nameNode = FocusNode();
  }

  @override
  void dispose() {
    _nameNode!.dispose();
    super.dispose();
  }

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

  editUser() {
    if (isEdit) {
      setState(() {
        FocusScope.of(context).requestFocus(_nameNode);
      });
    } else {
      if (FocusScope.of(context).hasFocus) {
        setState(() {
          FocusScope.of(context).focusedChild!.unfocus();
        });
      }
    }
  }

  String date_text(String date) {
    if (date.trim().isNotEmpty && !date.contains('0000-00-00')) {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } else {
      return 'dd-MMM-yyyy';
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<UserProvider>(context);
    final deviceid =
        Provider.of<LoginProvider>(context, listen: false).identifier;

    if (isLoading == false) {
      getuserData().then((value) {
        user = {'userid': user['userid'], 'imei': deviceid};
        Provider.of<UserProvider>(context, listen: false)
            .getUserdetails(user)
            .then((value) {
              if(mounted) {
                setState(() {
                  _name.text = account.userdetails['name'];
                  _mobile.text = account.userdetails['mobile'];
                  _email.text = account.userdetails['email'];
                  _city.text = account.userdetails['city'];
                  _ovulationdate.text =
                      date_text(account.userdetails['ovulation']);
                  _perioddate.text = date_text(account.userdetails['period']);
                  isLoading = true;
                });
              }
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        centerTitle: true,
        title: const Text(
          'User Profile',
          style: TextStyle(fontSize: 20,fontFamily: 'SourceSandPro',fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/profile.jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: !isEdit,
                          child: Tooltip(
                              message: 'Edit',
                              margin: const EdgeInsets.only(top: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isEdit = true;
                                  });
                                  editUser();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )),
                              )),
                        )
                      ],
                    ),
                  ),
                  Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _name,
                              autofocus: isEdit,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              readOnly: !isEdit,
                              enabled: isEdit,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple.shade300)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple.shade300)),
                                labelText: "Username",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value!.trim().isNotEmpty) {
                                  return null;
                                } else {
                                  return 'User\'s name is required';
                                }
                              },
                            ),
                            TextFormField(
                              controller: _mobile,
                              keyboardType: TextInputType.phone,
                              textCapitalization: TextCapitalization.words,
                              readOnly: true,
                              enabled: false,
                              style: const TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple.shade300)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple.shade300)),
                                labelText: "Mobile No.",
                                focusColor: Colors.purple.shade300,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value!.trim().isNotEmpty) {
                                  return null;
                                } else if (value.trim().length != 10) {
                                  return 'Please enter valid mobile number';
                                } else {
                                  return 'User\'s mobile is required';
                                }
                              },
                            ),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: !isEdit,
                              enabled: isEdit,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple.shade300)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple.shade300)),
                                labelText: "Email Address",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value!.trim().isNotEmpty) {
                                  if (RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value)) {
                                    return null;
                                  } else {
                                    return 'Please enter valid E-mail';
                                  }
                                } else {
                                  return 'User\'s E-mail is required';
                                }
                              },
                            ),
                            TextFormField(
                                controller: _city,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                readOnly: !isEdit,
                                enabled: isEdit,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple.shade300)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple.shade300)),
                                  labelText: "City",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                            TextFormField(
                                controller: _ovulationdate,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                readOnly: !isEdit,
                                enabled: false,
                                style: TextStyle(color: Colors.grey.shade600),
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple.shade300)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple.shade300)),
                                  labelText: "Ovulation Date",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                            TextFormField(
                                controller: _perioddate,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                readOnly: !isEdit,
                                enabled: false,
                                style: TextStyle(color: Colors.grey.shade600),
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple.shade300)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.purple.shade300)),
                                  labelText: "Mensuration Cycle Date",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                            const SizedBox(
                              height: 25,
                            ),
                            Visibility(
                              visible: isEdit,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = !isLoading;
                                        });
                                        user['name'] = _name.text;
                                        user['mobile'] = _mobile.text;
                                        user['email'] = _email.text;
                                        user['city'] = _city.text;
                                        account.updateUser(user).then((value) {
                                          setState(() {
                                            isEdit = !isEdit;
                                            isLoading = !isLoading;
                                          });
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Profile updated successfully');
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    color: Colors.purple.shade200,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _name.text =
                                            account.userdetails['name'];
                                        _mobile.text =
                                            account.userdetails['mobile'];
                                        _email.text =
                                            account.userdetails['email'];
                                        _city.text =
                                            account.userdetails['city'];

                                        isEdit = !isEdit;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
