import 'package:flutter/material.dart';
import 'package:kidzit/calender/calendar_provider.dart';
import 'package:kidzit/container/containerscreen.dart';
import 'package:kidzit/home/home.dart';
import 'package:kidzit/intro/introduction.dart';
import 'package:kidzit/login/login.dart';
import 'package:kidzit/login/loginprovider.dart';
import 'package:kidzit/login/otp.dart';
import 'package:kidzit/packageselection/packageprovider.dart';
import 'package:kidzit/packageselection/packageview.dart';
import 'package:kidzit/packageselection/payment_screen.dart';
import 'package:kidzit/screens/splash/splashscreen.dart';
import 'package:kidzit/selection/pregnancycycle.dart';
import 'package:kidzit/selection/selctionprovider.dart';
import 'package:kidzit/selection/selection.dart';
import 'package:kidzit/selection/showcalendar.dart';
import 'package:kidzit/selection/trackmycycle.dart';
import 'package:kidzit/tools/announcements/accouncement_provider.dart';
import 'package:kidzit/tools/announcements/announcement.dart';
import 'package:kidzit/tools/events/add_diary.dart';
import 'package:kidzit/tools/events/allevents.dart';
import 'package:kidzit/tools/events/diaryprovider.dart';
import 'package:kidzit/tools/hospitaltips/hospital.dart';
import 'package:kidzit/tools/kiktracker/kikprovider.dart';
import 'package:kidzit/tools/kiktracker/kikscreen.dart';
import 'package:kidzit/tools/prayers/prayerprovider.dart';
import 'package:kidzit/tools/prayers/prayerscreen.dart';
import 'package:kidzit/tools/watertracker/waterprovider.dart';
import 'package:kidzit/tools/watertracker/watertracker.dart';
import 'package:kidzit/useraccount/account.dart';
import 'package:kidzit/useraccount/dateselection.dart';
import 'package:kidzit/useraccount/dateupdate.dart';
import 'package:kidzit/useraccount/pregnancydateupdate.dart';
import 'package:kidzit/useraccount/userprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginProvider()),
        ChangeNotifierProvider.value(value: CalendarProvider()),
        ChangeNotifierProvider.value(value: WaterProvider()),
        ChangeNotifierProvider.value(value: KikProvider()),
        ChangeNotifierProvider.value(value: DiaryProvider()),
        ChangeNotifierProvider.value(value: AnnouncementProvider()),
        ChangeNotifierProvider.value(value: PrayerProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: SelectionProvider()),
        ChangeNotifierProvider.value(value: PackageProvider(),)
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'SourceSandPro',
         colorScheme: ColorScheme(
             primary: Colors.purple.shade500,
             primaryVariant: Colors.purple.shade900,
             secondary: Colors.purple.shade300,
             secondaryVariant: Colors.purple.shade500,
             surface: Colors.grey.shade900,
             background: Colors.white,
             error: Colors.red,
             onPrimary: Colors.white,
             onSecondary: Colors.purple.shade300,
             onSurface: Colors.grey.shade900,
             onBackground: Colors.white,
             onError: Colors.red,
             brightness: Brightness.light)
        ),

        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          HomePage.tag: (context) => HomePage(),
          Introduction.tag: (context) => const Introduction(),
          LoginScreen.tag: (context) => const LoginScreen(),
          VerifyOTP.tag:(context) => VerifyOTP(),
          ContainerScreen.tag:(context) => const ContainerScreen(),
          WaterTracker.tag:(context) => const WaterTracker(),
          KicksTracker.tag:(context) => const KicksTracker(),
          Events.tag: (context) => const Events(),
          PrayerScreen.tag:(context) =>const PrayerScreen(),
          Selection.tag: (context) => Selection(),
          TrackMyCycle.tag: (context) => const TrackMyCycle(),
          Pregnancy.tag: (context)=> const Pregnancy(),
          AnnounceMents.tag:(context)=> const AnnounceMents(),
          AddDiary.tag:(context) => const AddDiary(),
          EditUser.tag:(context) => const EditUser(),
          Hospital.tag:(context) => const Hospital(),
          UpdateDate.tag:(context) => const UpdateDate(),
          PackageView.tag:(context) => PackageView(),
          PaymentScreen.tag:(context) => const PaymentScreen(),
          ShowCalender.tag : (context) => const ShowCalender(),
          UpdateSelection.tag:(context) => UpdateSelection(),
          PregnancyUpdate.tag:(context) => const PregnancyUpdate()
        },
      ),
    );
  }
}
