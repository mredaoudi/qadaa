import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/fast_provider.dart';
import '../providers/people_provider.dart';
import '../providers/theme_provider.dart';
import '../components/period_counter.dart';

class FastPeriodScreen extends StatefulWidget {
  const FastPeriodScreen({super.key});

  @override
  State<FastPeriodScreen> createState() => _FastPeriodScreenState();
}

class _FastPeriodScreenState extends State<FastPeriodScreen> {
  var _amount = 0;
  var periods = {
    'months': {"amount": 0, "increment": 30, "label": "Months"},
    'weeks': {"amount": 0, "increment": 7, "label": "Weeks"},
    'days': {"amount": 0, "increment": 1, "label": "Days"}
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

  @override
  Widget build(BuildContext context) {
    final fastProvider = Provider.of<FastProvider>(context);
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.background(),
      appBar: AppBar(
        title: const Icon(Icons.edit_calendar_outlined),
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
              .map((entry) => PeriodCounter(
                  period: entry.key,
                  info: entry.value,
                  operation: incrementPeriod))
              .toList(),
          const SizedBox(height: 20),
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
            onPressed: _amount == 0
                ? null
                : () async {
                    fastProvider.incrementOperation(
                      _amount,
                      peopleProvider.currentUser,
                    );
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
