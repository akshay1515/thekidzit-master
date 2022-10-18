import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/login/otp.dart';
import 'package:kidzit/terms_and_conditions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const tag = '-/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController _mobilecontroller = TextEditingController();
FocusNode? _mobilefocus;
GlobalKey<FormFieldState> loginkey = GlobalKey<FormFieldState>();

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
                    child: const Text(
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (_) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade100],
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter)),
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.view_headline_rounded,
                        size: 17,
                      )),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9 - 20,
                    child: CustomWebView(url_selector: type)),
              ],
            ));
      });
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final login = Provider.of<LoginProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      'assets/mobile.png',
                      height: size.height * 0.13,
                      width: size.height * 0.13,
                      fit: BoxFit.fill,
                    )),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'Login / SignUp',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                decorationColor: Colors.black26,
                                fontSize: 23,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'We will send you an ',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16)),
                              const TextSpan(
                                  text: 'One Time Password ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text:
                                      'on this mobile number to verify your account',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16))
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _mobilecontroller,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.go,
                          key: loginkey,
                          focusNode: _mobilefocus,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).requestFocus(_mobilefocus);
                            });
                          },
                          decoration: InputDecoration(
                            focusColor: Colors.purple.shade100,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purple.shade100, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple.shade100),
                                borderRadius: BorderRadius.circular(20)),
                            isDense: true,
                            labelStyle:
                                TextStyle(color: Colors.purple.shade300),
                            contentPadding: const EdgeInsets.only(
                                left: 25, right: 5, top: 15, bottom: 15),
                            prefix: Text(
                              '+91  ',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            alignLabelWithHint: true,
                            labelText: _mobilefocus!.hasFocus
                                ? 'Mobile Number'
                                : 'Enter your mobile number',
                          ),
                          validator: (value) {
                            if (value!.trim == null) {
                              return 'Phone number is required';
                            } else if (value.length != 10) {
                              return 'Enter valid phone number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 75, right: 75),
                          child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: Colors.purple.shade200,
                              onPressed: () {
                                if (loginkey.currentState!.validate()) {
                                  _showalertDialog(
                                      context,
                                      false,
                                      'Authenticating...',
                                      'Please be patience.. we are sending you OTP');
                                  login
                                      .sendOTP(
                                          _mobilecontroller.text.toString())
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    if (value['ack'] == true) {
                                        Navigator.of(context).pushNamed(
                                            VerifyOTP.tag,
                                            arguments: {
                                              'mobile': _mobilecontroller.text
                                            });
                                    } else {
                                      _showalertDialog(context, true,
                                          'Error...', value['message']);
                                    }
                                  }).catchError((error) {
                                    _showalertDialog(context, true, 'Error...',
                                        error.toString());
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Get OTP',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _mobilefocus = FocusNode();
  }
}
