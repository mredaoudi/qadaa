import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import 'dart:async';

class PrayerCounter extends StatefulWidget {
  final String prayer;
  final int amount;

  const PrayerCounter({super.key, required this.prayer, required this.amount});

  @override
  State<PrayerCounter> createState() => _PrayerCounterState();
}

class _PrayerCounterState extends State<PrayerCounter> {
  Timer? _timer;
  bool _longPressCanceled = false;

  void _cancelIncrease() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _longPressCanceled = true;
  }

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    return Column(
      children: [
        Text(widget.prayer,
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
                onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
                  _cancelIncrease();
                },
                onLongPress: () {
                  _longPressCanceled = false;
                  Future.delayed(const Duration(milliseconds: 0), () {
                    if (!_longPressCanceled) {
                      _timer = Timer.periodic(const Duration(milliseconds: 50),
                          (timer) {
                        prayerProvider.incrementOperation(widget.prayer, -1);
                      });
                    }
                  });
                },
                onLongPressUp: () {
                  _cancelIncrease();
                },
                child: FloatingActionButton(
                  heroTag: '${widget.prayer}' 'plus',
                  onPressed: () async {
                    prayerProvider.incrementOperation(widget.prayer, -1);
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
                widget.amount.toString(),
                style: const TextStyle(
                    fontSize: 40.0, color: Color.fromARGB(255, 126, 126, 126)),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 4,
              child: GestureDetector(
                onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
                  _cancelIncrease();
                },
                onLongPress: () {
                  _longPressCanceled = false;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (!_longPressCanceled) {
                      _timer = Timer.periodic(const Duration(milliseconds: 50),
                          (timer) {
                        prayerProvider.incrementOperation(widget.prayer, 1);
                      });
                    }
                  });
                },
                onLongPressUp: () {
                  _cancelIncrease();
                },
                child: FloatingActionButton(
                  heroTag: '${widget.prayer}' 'minus',
                  onPressed: () =>
                      prayerProvider.incrementOperation(widget.prayer, 1),
                  backgroundColor: const Color.fromARGB(255, 162, 57, 57),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
