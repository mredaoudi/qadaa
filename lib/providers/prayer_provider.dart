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

  PrayerProvider({user}) {
    if (user != null) {
      setup(user);
    }
  }

  void setup(String user) {
    var box = Hive.box('prayers');
    for (var pkey in _prayers.keys) {
      _prayers[pkey] = box.get('${user}__$pkey') ?? 0;
    }
  }

  get prayers => _prayers;

  void incrementOperation(
      {required String prayer, required int amount, required String user}) {
    var value = max(_prayers[prayer]! + amount, 0);
    _prayers[prayer] = value;
    var box = Hive.box('prayers');
    box.put('${user}__$prayer', value);
    notifyListeners();
  }

  void reset({required String user}) {
    var box = Hive.box('prayers');
    for (var pkey in _prayers.keys) {
      _prayers[pkey] = 0;
      box.put('${user}__$pkey', 0);
    }
  }

  num amountPrayersUser({required String user}) {
    num amount = 0;
    var box = Hive.box('prayers');
    for (var pkey in _prayers.keys) {
      amount += box.get('${user}__$pkey') ?? 0;
    }
    return amount;
  }
}
