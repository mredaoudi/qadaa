import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Column(
        children: [
          Text(info['label'],
              style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(180, 0, 0, 0),
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
                  color: const Color(0xFF6096B4),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  info['amount'].toString(),
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 126, 126, 126)),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 4,
                child: IconButton(
                  onPressed: () => operation(period, 1),
                  icon: const Icon(Icons.add),
                  iconSize: 32.0,
                  color: const Color(0xFF6096B4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
