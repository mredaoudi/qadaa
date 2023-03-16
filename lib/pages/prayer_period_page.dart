import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../components/period_counter.dart';
import '../providers/prayer_provider.dart';
import '../providers/people_provider.dart';

class PrayerPeriodScreen extends StatefulWidget {
  const PrayerPeriodScreen({super.key});

  @override
  State<PrayerPeriodScreen> createState() => _PrayerPeriodScreenState();
}

class _PrayerPeriodScreenState extends State<PrayerPeriodScreen> {
  var _amount = 0;

  var periods = {
    'years': {"amount": 0, "increment": 365, "label": "Years"},
    'months': {"amount": 0, "increment": 30, "label": "Months"},
    'weeks': {"amount": 0, "increment": 7, "label": "Weeks"},
    'days': {"amount": 0, "increment": 1, "label": "Days"}
  };
  var prays = {
    'Fajr': false,
    'Zuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false
  };

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
    for (var pray in prays.keys) {
      if (prays[pray] == true) {
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 253, 250),
      appBar: AppBar(
        title: const Icon(Icons.edit_calendar_outlined),
        backgroundColor: const Color(0xFF4E6E81),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            color: const Color(0xFFF9DBBB),
            padding: const EdgeInsets.only(top: 20),
            child: const Text(
              "Total amount of days",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                backgroundColor: Color(0xFFF9DBBB),
                color: Color(0xFF4E6E81),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            color: const Color(0xFFF9DBBB),
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: Text(
              _amount.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                backgroundColor: Color(0xFFF9DBBB),
                color: Color(0xFF4E6E81),
              ),
            ),
          ),
          ...periods.entries
              .map(
                (entry) => PeriodCounter(
                    period: entry.key,
                    info: entry.value,
                    operation: incrementPeriod),
              )
              .toList(),
          ...prays.entries.map((entry) => SwitchListTile(
                contentPadding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(180, 0, 0, 0),
                  ),
                ),
                value: entry.value,
                activeColor: const Color(0xFF4E6E81),
                onChanged: (bool value) {
                  setState(() {
                    prays[entry.key] = value;
                  });
                },
              )),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return const Color(0xFFD6D6D6); // Disabled color
                }
                return const Color(0xFF4E6E81); // Regular color
              }),
              minimumSize: const MaterialStatePropertyAll(Size(50, 50)),
            ),
            onPressed: !checkForm()
                ? null
                : () async {
                    for (var pray in prays.keys) {
                      if (prays[pray] == true) {
                        prayerProvider.incrementOperation(
                          prayer: pray,
                          amount: _amount,
                          user: peopleProvider.currentUser,
                        );
                      }
                    }
                    Navigator.pop(context);
                  },
            child: const Text(
              "Add",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
