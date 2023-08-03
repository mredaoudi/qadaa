import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/people_provider.dart';

const List<Widget> prayers = <Widget>[
  Text('Fajr'),
  Text('Zuhr'),
  Text('Asr'),
  Text('Maghrib'),
  Text('Isha')
];

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  var _amount = 0;

  var periods = {
    'years': {"amount": 0, "increment": 365, "label": "Years"},
    'months': {"amount": 0, "increment": 30, "label": "Months"},
    'weeks': {"amount": 0, "increment": 7, "label": "Weeks"},
    'days': {"amount": 0, "increment": 1, "label": "Days"}
  };

  final List<bool> _selectedPrayers = <bool>[false, false, false, false, false];

  void incrementPeriod(String period, int amount) {
    setState(() {
      int am = (periods[period]!["amount"]! as int) + amount;
      periods[period]!["amount"] = am;
      int result = 0;
      for (var val in periods.values) {
        result = result + (val['increment']! as int) * (val['amount']! as int);
      }
      _amount = result;
    });
  }

  bool checkForm() {
    var praySelected = false;
    for (var pray in _selectedPrayers) {
      if (pray == true) {
        praySelected = true;
        break;
      }
    }
    return _amount != 0 && praySelected;
  }

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.background(),
        appBar: AppBar(
          foregroundColor: themeProvider.appBarIcon(),
          title: const Icon(Icons.person),
          backgroundColor: themeProvider.appbar(),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ));
  }
}
