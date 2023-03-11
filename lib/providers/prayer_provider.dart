import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PrayerProvider extends ChangeNotifier {
  final _prayers = {
    'Fajr': 0,
    'Zuhr': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
  };

  PrayerProvider() {
    setup();
  }

  void setup() {
    var box = Hive.box('prayers');
    for (var pkey in _prayers.keys) {
      _prayers[pkey] = box.get(pkey) ?? 0;
    }
  }

  get prayers => _prayers;

  void incrementOperation(String prayer, int amount) {
    var value = max(_prayers[prayer]! + amount, 0);
    _prayers[prayer] = value;
    var box = Hive.box('prayers');
    box.put(prayer, value);
    notifyListeners();
  }

  void reset() {
    var box = Hive.box('prayers');
    for (var pkey in _prayers.keys) {
      _prayers[pkey] = 0;
      box.put(pkey, 0);
    }
  }
}
