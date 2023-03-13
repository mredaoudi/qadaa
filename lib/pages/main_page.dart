import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/prayer_counter.dart';
import '../components/fast_counter.dart';
import '../components/main_drawer.dart';
import '../providers/prayer_provider.dart';
import '../providers/fast_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final fastProvider = Provider.of<FastProvider>(context);
    return MaterialApp(
      title: "Qadaa",
      theme: ThemeData(
        primaryColor: const Color(0xFF4E6E81),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const NavDrawer(),
          backgroundColor: const Color.fromARGB(255, 255, 253, 250),
          appBar: AppBar(
            centerTitle: true,
            title: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 20.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Qadaa\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Mohammed',
                    style: TextStyle(fontSize: 13, fontFamily: 'Courier'),
                  ),
                ],
              ),
            ),
            backgroundColor: const Color(0xFF4E6E81),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Prayers'),
                Tab(text: "Fasts"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ...prayerProvider.prayers.entries
                      .map((entry) => PrayerCounter(
                            prayer: entry.key,
                            amount: entry.value,
                          ))
                      .toList(),
                  FloatingActionButton(
                    heroTag: 'calendar-prayer',
                    backgroundColor: const Color(0xFF4E6E81),
                    onPressed: () {
                      Navigator.pushNamed(context, '/period/prayers');
                    },
                    child: const Icon(Icons.edit_calendar_outlined),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FastCounter(amount: fastProvider.fasts),
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: FloatingActionButton(
                      heroTag: 'calendar-fast',
                      backgroundColor: const Color(0xFF4E6E81),
                      onPressed: () {
                        Navigator.pushNamed(context, '/period/fasts');
                      },
                      child: const Icon(
                        Icons.edit_calendar,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
