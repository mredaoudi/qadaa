import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';

class PrayerCounter extends StatelessWidget {
  final String prayer;
  final int amount;

  const PrayerCounter({super.key, required this.prayer, required this.amount});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    return Column(
      children: [
        Text(prayer,
            style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(180, 0, 0, 0),
                fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: GestureDetector(
                onLongPress: () {
                  prayerProvider.incrementOperation(prayer, -999999);
                },
                child: FloatingActionButton(
                  heroTag: '$prayer' 'plus',
                  onPressed: () async {
                    prayerProvider.incrementOperation(prayer, -1);
                  },
                  backgroundColor: const Color(0xFF4DAB8F),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                amount.toString(),
                style: const TextStyle(
                    fontSize: 40.0, color: Color.fromARGB(255, 126, 126, 126)),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 4,
              child: FloatingActionButton(
                heroTag: '$prayer' 'minus',
                onPressed: () => prayerProvider.incrementOperation(prayer, 1),
                backgroundColor: const Color.fromARGB(255, 162, 57, 57),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }
}
