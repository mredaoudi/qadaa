import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FastProvider extends ChangeNotifier {
  int _fasts = 0;

  FastProvider();

  void setup(String user) {
    var box = Hive.box('fasts');
    box.put('${user}__amount', 0);
  }

  int fasts({required String user}) {
    var box = Hive.box('fasts');
    return box.get('${user}__amount') ?? 0;
  }

  void incrementOperation(int amount, String user) {
    var box = Hive.box('fasts');
    var initValue = box.get('${user}__amount') ?? 0;
    _fasts = max(initValue + amount, 0);
    box.put('${user}__amount', _fasts);
    notifyListeners();
  }

  void deleteUser({required String user}) {
    var box = Hive.box('fasts');
    box.delete('${user}__amount');
    notifyListeners();
  }

  void reset({required String user}) {
    var box = Hive.box('fasts');
    box.put('${user}__amount', 0);
    notifyListeners();
  }
}
