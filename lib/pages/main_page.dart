import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/prayer_counter.dart';
import '../components/fast_counter.dart';
import '../components/main_drawer.dart';
import '../providers/prayer_provider.dart';
import '../providers/fast_provider.dart';
import '../providers/people_provider.dart';
import '../providers/theme_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final fastProvider = Provider.of<FastProvider>(context);
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: "Qadaa",
      theme: ThemeData(
        primaryColor: const Color(0xFF4E6E81),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: const NavDrawer(),
          backgroundColor: themeProvider.background(),
          appBar: AppBar(
            centerTitle: true,
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: peopleProvider.currentUser != ""
                        ? capitalize(text: peopleProvider.currentUser)
                        : "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // TextSpan(
                  //   text: capitalize(peopleProvider.currentUser),
                  //   style: const TextStyle(fontSize: 13, fontFamily: 'Courier'),
                  // ),
                ],
              ),
            ),
            backgroundColor: themeProvider.appbar(),
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

String capitalize({text}) {
  if (text != null) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
  return "";
}
