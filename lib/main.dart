import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'pages/prayer_period_page.dart';
import 'pages/fast_period_page.dart';
import 'pages/intro_page.dart';
import 'providers/prayer_provider.dart';
import 'providers/fast_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('prayers');
  await Hive.openBox('fasts');
  //var prefs = await SharedPreferences.getInstance();
  //var boolKey = 'isFirstTime';
  //var isFirstTime = prefs.getBool(boolKey) ?? true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PrayerProvider>(create: (_) => PrayerProvider()),
        ChangeNotifierProvider<FastProvider>(create: (_) => FastProvider()),
      ],
      child: MaterialApp(
        title: 'Qadaa',
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/period/prayers': (context) => const PrayerPeriodScreen(),
          '/period/fasts': (context) => const FastPeriodScreen(),
          '/intro': (context) => const OnBoardingPage()
        },
      ),
    ),
  );
}
