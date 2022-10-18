import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/login/loginprovider.dart';

import 'package:kidzit/selection/selection.dart';
import 'package:kidzit/terms_and_conditions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTP extends StatelessWidget {
  static const tag = '-/OTPScreen';

  VerifyOTP({Key? key}) : super(key: key);
  final TextEditingController OTPController = TextEditingController();

  _showalertDialog(
      BuildContext context, bool status, String Title, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(Title),
            content: Text(message),
            actions: [
              status
                  ? MaterialButton(
                      color: Colors.purple.shade200,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    )
                  : Container()
            ],
          );
        });
  }

  _showModal(BuildContext context, int type) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.grey.shade400,
                          Colors.grey.shade100
                        ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter)),
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.view_headline_rounded,
                          size: 17,
                        )),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.9 - 20,
                      child: CustomWebView(url_selector: type)),
                ],
              ));
        });
  }

  Future<String?> setUserData(Map userdata) async {
    String? status;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('userid', json.encode(userdata)).then((value) {
      status = value.toString();
    });
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verifyOTP = Provider.of<LoginProvider>(context);
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    return Material(
      color: Colors.purple.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: size.height * 0.15,
              width: size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(10),
              child: Image.asset(
                'assets/mobile2.png',
                height: size.height * 0.13,
                width: size.height * 0.09,
                fit: BoxFit.contain,
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            width: size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'OTP Verification',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'Enter the otp sent on ',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  TextSpan(
                      text: '${'+91'} ${data['mobile']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ])),
                Container(
                  width: size.width * 0.5,
                  child: PinCodeTextField(
                    pastedTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    controller: OTPController,
                    textInputAction: TextInputAction.done,
                    enableActiveFill: true,
                    keyboardType: TextInputType.phone,
                    textStyle: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold),
                    cursorColor: Colors.black54,
                    onChanged: (String Value) {},
                    enablePinAutofill: true,
                    appContext: context,
                    length: 4,
                    pinTheme: PinTheme(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      activeColor: Colors.purple.shade100,
                      inactiveColor: Colors.blueGrey,
                      inactiveFillColor: Colors.transparent,
                      activeFillColor: Colors.transparent,
                      selectedColor: Colors.purple.shade100,
                      selectedFillColor: Colors.transparent,

                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Din\'t receive OTP yet? ',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  InkWell(
                    onTap: () {
                      _showalertDialog(context, false, 'Resending...',
                          'Please be patience while we resend OTP');
                      verifyOTP
                          .resendOTP(OTPController.text, data['mobile'])
                          .then((value) {
                        Navigator.of(context).pop();
                        if (value['ack'] == true) {
                          Map userdata = {
                            'ack': value['ack'],
                            'userid': value['userId'],
                            'token': value['token']
                          };
                          setUserData(userdata).then((id) {

                          });
                        } else {
                          _showalertDialog(
                              context, true, 'Error...', value['message']);
                        }
                      }).catchError((error) {
                        _showalertDialog(
                            context, true, 'Error...', error.toString());
                      });
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                          color: Colors.pink.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ]),
                SizedBox(height: 8),
                MaterialButton(
                  onPressed: () {
                    _showalertDialog(context, false, 'Authenticating...',
                        'Please be patience while we verify OTP');
                    verifyOTP
                        .verifyOTP(OTPController.text, data['mobile'])
                        .then((value) {
                      Navigator.of(context).pop();
                      if (value['ack'] == true) {
                        Map userdata = {
                          "ack": value['ack'],
                          "userid": value['userId'],
                          "token": value['token'],
                          "ovulation": value['user'][0]['ovulationDate'],
                          "period": value['user'][0]['periodDate']
                        };
                        setUserData(userdata).then((id) {
                          if (value['user'][0]['ovulationDate']
                                  .contains('0000-00-00') &&
                              value['user'][0]['periodDate']
                                  .contains('0000-00-00')) {

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  Selection.tag, (route) => false);

                          } else {

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  ContainerScreen.tag, (route) => false);

                          }
                        });
                      } else {
                        _showalertDialog(
                            context, true, 'Error...', value['message']);
                      }
                    }).catchError((error) {
                      _showalertDialog(
                          context, true, 'Error...', error.toString());
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Verify and Proceed',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  color: Colors.purple.shade200,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: 'By continuing you agree to our ',
                      ),
                      TextSpan(
                          text: 'Terms of services ',
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _showModal(context, 1);
                            }),
                      TextSpan(
                        text: 'and ',
                      ),
                      TextSpan(
                          text: 'Privacy & Legal Policy',
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _showModal(context, 2);
                            }),
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
