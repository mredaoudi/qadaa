import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'pages/period_page.dart';
import 'pages/intro_page.dart';
import 'providers/prayer_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('prayers');
  //var prefs = await SharedPreferences.getInstance();
  //var boolKey = 'isFirstTime';
  //var isFirstTime = prefs.getBool(boolKey) ?? true;
  runApp(
    ChangeNotifierProvider(
      create: (context) => PrayerProvider(),
      child: MaterialApp(
        title: 'Qadaa',
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/period': (context) => const PeriodScreen(),
          '/intro': (context) => const OnBoardingPage()
        },
      ),
    ),
  );
}
