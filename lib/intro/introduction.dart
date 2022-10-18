import 'package:flutter/material.dart';
import 'package:kidzit/login/login.dart';


class Introduction extends StatefulWidget {
  static const tag = '-/introduction';

  const Introduction({Key? key}) : super(key: key);

  @override
  _IntroductionState createState() => _IntroductionState();
}

List<String> introimages = ['assets/onboarding3.JPEG', 'assets/onboarding2.JPEG', 'assets/onboarding1.JPEG'];

class _IntroductionState extends State<Introduction> {
  int count = 0;

  int pageChange(int index) {
    setState(() {
      count = index;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            PageView.builder(
                controller:
                    PageController(initialPage: 0, viewportFraction: 1.0),
                itemCount: introimages.length,
                onPageChanged: (index) {
                  pageChange(index);
                },
                itemBuilder: (context, position) {
                  return Image.asset(introimages[count],
                      height: size.height, width: size.width, fit: BoxFit.contain);
                }),
            Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.transparent,
                        splashFactory: NoSplash.splashFactory),
                    onPressed: () {
                      if (count < introimages.length - 1) {
                        setState(() {
                          count = count + 1;
                        });
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.tag);
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          count < introimages.length - 1 ? 'Next' : 'Start',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          count < introimages.length - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.done,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 25,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: introimages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: index == count
                                ? const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5)
                                : const EdgeInsets.all(2),
                            child: Container(
                              margin: index == count
                                  ? const EdgeInsets.all(2.5)
                                  : const EdgeInsets.all(5),
                              height: index == count ? 15 : 10,
                              width: index == count ? 15 : 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      index == count ? 15 : 10),
                                  color: index == count
                                      ? Colors.pink
                                      : Colors.grey),
                            ),
                          );
                        }),
                  ),
                )),
            Visibility(
              visible: count < introimages.length - 1 ? true : false,
              child: Positioned(
                  bottom: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.transparent,
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.tag);
                      },
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.check_circle,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
