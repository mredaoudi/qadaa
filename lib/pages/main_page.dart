import 'package:flutter/material.dart';
import '../components/primary_color.dart';
import '../components/prayer_counter.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    return MaterialApp(
      title: "Qadaa",
      theme: ThemeData(
        primaryColor: const MyColor(),
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 253, 250),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Qadaa"),
          backgroundColor: const Color(0xFF6096B4),
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
              backgroundColor: const Color(0xFF6096B4),
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
