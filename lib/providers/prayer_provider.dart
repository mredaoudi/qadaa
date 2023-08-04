import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PrayerProvider extends ChangeNotifier {
  final _prayers = ['Fajr', 'Zuhr', 'Asr', 'Maghrib', 'Isha'];

  PrayerProvider();

  void setup(String user) {
    var box = Hive.box('prayers');
    for (var pkey in _prayers) {
      box.put('${user}__$pkey', 0);
    }
  }

  Map prayers({required String user}) {
    var box = Hive.box('prayers');
    var p = {};
    for (var pkey in _prayers) {
      p[pkey] = box.get('${user}__$pkey');
    }
    return p;
  }

  void incrementOperation(
      {required String prayer, required int amount, required String user}) {
    var box = Hive.box('prayers');
    int initValue = box.get('${user}__$prayer') ?? 0;
    var value = max(initValue + amount, 0);
    box.put('${user}__$prayer', value);
    notifyListeners();
  }

  void reset({required String user}) {
    var box = Hive.box('prayers');
    for (var pkey in _prayers) {
      box.put('${user}__$pkey', 0);
    }
    notifyListeners();
  }

  void deleteUser({required String user}) {
    var box = Hive.box('prayers');
    for (var pkey in _prayers) {
      if (box.containsKey('${user}__$pkey')) {
        box.delete('${user}__$pkey');
      }
    }
    notifyListeners();
  }

  num amountPrayersUser({required String user}) {
    num amount = 0;
    var box = Hive.box('prayers');
    for (var pkey in _prayers) {
      amount += box.get('${user}__$pkey') ?? 0;
    }
    return amount;
  }
}
