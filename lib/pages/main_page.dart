import 'package:flutter/material.dart';
import '../components/prayer_counter.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../components/main_drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    return MaterialApp(
      title: "Qadaa",
      theme: ThemeData(
        primaryColor: const Color(0xFF4E6E81),
      ),
      home: Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: const Color.fromARGB(255, 255, 253, 250),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Qadaa",
          ),
          backgroundColor: const Color(0xFF4E6E81),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ...prayerProvider.prayers.entries
                .map((entry) => PrayerCounter(
                      prayer: entry.key,
                      amount: entry.value,
                    ))
                .toList(),
            FloatingActionButton(
              heroTag: 'calendar',
              backgroundColor: const Color(0xFF4E6E81),
              onPressed: () {
                Navigator.pushNamed(context, '/period');
              },
              child: const Icon(Icons.edit_calendar),
            ),
          ],
        ),
      ),
    );
  }
}
