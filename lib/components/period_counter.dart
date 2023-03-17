import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class PeriodCounter extends StatelessWidget {
  Map info;
  String period;
  Function operation;

  PeriodCounter(
      {super.key,
      required this.period,
      required this.info,
      required this.operation});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Column(
        children: [
          Text(info['label'],
              style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.text(),
                  fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: IconButton(
                  onPressed: () => operation(period, -1),
                  icon: const Icon(Icons.remove),
                  iconSize: 32.0,
                  color: themeProvider.icon(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  info['amount'].toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: themeProvider.text(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 4,
                child: IconButton(
                  onPressed: () => operation(period, 1),
                  icon: const Icon(Icons.add),
                  iconSize: 32.0,
                  color: themeProvider.icon(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
