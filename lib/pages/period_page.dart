import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../components/period_counter.dart';
import '../providers/prayer_provider.dart';

class PeriodScreen extends StatefulWidget {
  const PeriodScreen({super.key});

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  var periods = {
    'years': {"amount": 0, "increment": 365, "label": "Years (365 days)"},
    'months': {"amount": 0, "increment": 30, "label": "Months (30 days)"},
    'weeks': {"amount": 0, "increment": 7, "label": "Weeks (7 days)"},
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
      periods[period]!["amount"] = max(am, 0);
    });
  }

  bool checkForm() {
    var periodSelected = false;
    var praySelected = false;
    for (var per in periods.keys) {
      if (periods[per]!["amount"]! as int > 0) {
        periodSelected = true;
        break;
      }
    }
    for (var pray in prays.keys) {
      if (prays[pray] == true) {
        praySelected = true;
        break;
      }
    }
    return periodSelected && praySelected;
  }

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 253, 250),
      appBar: AppBar(
        title: const Text("Add a period"),
        backgroundColor: const Color(0xFF4E6E81),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ...periods.entries
              .map((entry) => PeriodCounter(
                  period: entry.key,
                  info: entry.value,
                  operation: incrementPeriod))
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
            onPressed: !checkForm()
                ? null
                : () async {
                    for (var per in periods.keys) {
                      if (periods[per]!['amount']! as int > 0) {
                        for (var pray in prays.keys) {
                          if (prays[pray] == true) {
                            prayerProvider.incrementOperation(
                              pray,
                              ((periods[per]!['increment']! as int) *
                                  (periods[per]!['amount']! as int)),
                            );
                          }
                        }
                      }
                    }
                    Navigator.pop(context);
                  },
            child: const Text("Add"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
