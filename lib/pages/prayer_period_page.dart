import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/people_provider.dart';
import '../components/period_counter.dart';

const List<Widget> prayers = <Widget>[
  Text('Fajr'),
  Text('Zuhr'),
  Text('Asr'),
  Text('Maghrib'),
  Text('Isha')
];

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
        title: const Icon(
          Icons.edit_calendar_outlined,
        ),
        backgroundColor: themeProvider.appbar(),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                // All buttons are selectable.
                setState(() {
                  _selectedPrayers[index] = !_selectedPrayers[index];
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderColor: Colors.grey.withOpacity(0.5),
              selectedBorderColor: Colors.white,
              selectedColor: Colors.white,
              fillColor: const Color(0xFF4E6E81),
              color: themeProvider.text(),
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedPrayers,
              children: prayers,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return const Color.fromARGB(
                      255, 125, 125, 125); // Disabled color
                }
                return const Color(0xFF4E6E81); // Regular color
              }),
              minimumSize: const MaterialStatePropertyAll(Size(50, 50)),
            ),
            onPressed: !checkForm()
                ? null
                : () async {
                    List prayIndex = ['Fajr', 'Zuhr', 'Asr', 'Maghrib', 'Isha'];
                    for (var i = 0; i < _selectedPrayers.length; i++) {
                      if (_selectedPrayers[i] == true) {
                        prayerProvider.incrementOperation(
                          prayer: prayIndex[i],
                          amount: _amount,
                          user: peopleProvider.currentUser,
                        );
                      }
                    }
                    Navigator.pop(context);
                  },
            child: Text(
              _amount >= 0 ? "Add" : "Subtract",
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
