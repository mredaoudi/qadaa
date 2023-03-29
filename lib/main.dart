import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'pages/prayer_period_page.dart';
import 'pages/fast_period_page.dart';
import 'pages/intro_page.dart';
import 'pages/user_form.dart';
import 'providers/prayer_provider.dart';
import 'providers/fast_provider.dart';
import 'providers/people_provider.dart';
import 'providers/theme_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('prayers');
  await Hive.openBox('fasts');
  await Hive.openBox('people');
  await Hive.openBox('theme');
  var box = Hive.box('people');
  var currentUser = box.get('currentUser') ?? '';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PrayerProvider>(
          create: (_) => currentUser == ''
              ? PrayerProvider()
              : PrayerProvider(user: currentUser),
        ),
        ChangeNotifierProvider<FastProvider>(create: (_) => FastProvider()),
        ChangeNotifierProvider<PeopleProvider>(create: (_) => PeopleProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        title: 'Qadaa',
        initialRoute: currentUser == '' ? '/intro' : '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/intro': (context) => const OnBoardingPage(),
          '/setup_user': (context) => const UserForm(),
          '/period/prayers': (context) => const PrayerPeriodScreen(),
          '/period/fasts': (context) => const FastPeriodScreen()
        },
      ),
    ),
  );
}
