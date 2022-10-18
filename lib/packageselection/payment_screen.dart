import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/packageselection/packageprovider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  static const tag = '-/PaymentScreen';

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int count = 0;
  late Razorpay _razorpay;
  var checkoutdetails;

  bool isLoading = false;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerpaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerpaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerpaymentWallet);
  }

  void openCheckout() async {
    var options = {
      "key": "rzp_live_DSr6YK5QZQ6RnX",
      "amount": (checkoutdetails['amount'] * 100),
      "name": checkoutdetails['name'],
      "description": 'Kidzit Purchase',
      "redirect": true,
      "retry": {"enabled": false},
      "prefill": {
        "name": checkoutdetails['name'],
        "contact": checkoutdetails['mobile'],
        "email": checkoutdetails['email'],
      },
      "external": {
        "wallets": ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
    }
  }

  void _handlerpaymentSuccess(PaymentSuccessResponse successResponse) {
    _submitData();
  }

  void _handlerpaymentError(PaymentFailureResponse failureResponse) {
    String response =
        failureResponse.message!.replaceFirst(RegExp('&error='), '');
    final string = jsonDecode(response) as Map;
    _showMessage(
        'Failed',
        'Error Code: ${failureResponse.code}${'\n'}${string['code']}${'\n'}${string['description']}',
        false);
  }

  void _showScreen() {
    setState(() {
      showLoading = !showLoading;
    });
  }

  void showBottom(String id, String message) {
    if (count == 0) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: false,
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Purchase Successful',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'Payment ID:  ',
                                  style: TextStyle(
                                      color: Colors.grey.shade900
                                          .withOpacity(0.6))),
                              TextSpan(
                                  text: id,
                                  style: TextStyle(
                                      color: Colors.grey.shade900
                                          .withOpacity(0.6)))
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: '$message${'\n'}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  )),
                              TextSpan(
                                  text: ' ${'\n'}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 6,
                                  )),
                              TextSpan(
                                  text: 'to ${'\n'}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  )),
                              TextSpan(
                                  text: ' ${'\n'}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8,
                                  )),
                              TextSpan(
                                  text: '${checkoutdetails['title']} plan',
                                  style: const TextStyle(
                                    color: Color(0xFFce93d6),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  )),
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFce93d6),
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    ContainerScreen.tag, (route) => false);
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
      setState(() {
        count = 1;
      });
    }
  }

  void _submitData() {
    _showScreen();
    final transactionid =
        'TR${DateFormat('dMyyHms').format(DateTime.now())}${checkoutdetails['userid']}';
    Map detaild = {
      "apiVersion": "1.0.",
      "userId": checkoutdetails['userid'],
      "imei": checkoutdetails['imei'],
      "subscriptionTitle": checkoutdetails['title'],
      "price": checkoutdetails['amount'],
      "planId": checkoutdetails['planid'],
      "duration": checkoutdetails['duration'],
      "transactionId": transactionid,
      "transactionStatus": 1
    };

    Provider.of<PackageProvider>(context, listen: false)
        .registerPackage(detaild)
        .then((value) {
      if (value['ack']) {
        showBottom(transactionid, value['message']);
      } else {
        _showMessage('Error..', value['message'], true);
      }
      _showScreen();
    });
  }

  void _handlerpaymentWallet() {
    Fluttertoast.showToast(msg: 'error', toastLength: Toast.LENGTH_SHORT);
  }

  void _showMessage(String Status, String Message, bool status) {
    showDialog(
        barrierDismissible: false,
        useSafeArea: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Center(child: Text(Status)),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(Message),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: status ? Colors.green.shade700 : Colors.red.shade400,
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (status) {
                      Navigator.of(context)
                          .popAndPushNamed(ContainerScreen.tag);
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF6B39FE)),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    checkoutdetails = ModalRoute.of(context)!.settings.arguments as Map;

    if (checkoutdetails.isNotEmpty && !isLoading) {
      if (checkoutdetails['amount'] > 0) {
        openCheckout();
      } else {
        _submitData();
      }
      setState(() {
        isLoading = true;
      });
    }
    return Scaffold(
      body: showLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
