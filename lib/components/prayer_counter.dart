import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/people_provider.dart';
import '../providers/theme_provider.dart';
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
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var user = peopleProvider.currentUser;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(widget.prayer,
              style: TextStyle(
                  fontSize: 20,
                  color: themeProvider.text(),
                  fontWeight: FontWeight.bold)),
        ),
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
                        prayerProvider.incrementOperation(
                          prayer: widget.prayer,
                          amount: -1,
                          user: user,
                        );
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
                    prayerProvider.incrementOperation(
                      prayer: widget.prayer,
                      amount: -1,
                      user: user,
                    );
                  },
                  backgroundColor: themeProvider.minus(),
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
                style: TextStyle(fontSize: 40.0, color: themeProvider.text()),
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
                        prayerProvider.incrementOperation(
                          prayer: widget.prayer,
                          amount: 1,
                          user: user,
                        );
                      });
                    }
                  });
                },
                onLongPressUp: () {
                  _cancelIncrease();
                },
                child: FloatingActionButton(
                  heroTag: '${widget.prayer}' 'minus',
                  onPressed: () => prayerProvider.incrementOperation(
                    prayer: widget.prayer,
                    amount: 1,
                    user: user,
                  ),
                  backgroundColor: themeProvider.plus(),
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
