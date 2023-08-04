import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FastProvider extends ChangeNotifier {
  int _fasts = 0;

  FastProvider({user}) {
    if (user != null) {
      setup(user);
    }
  }

  void setup(String user) {
    var box = Hive.box('fasts');
    _fasts = box.get('${user}__amount') ?? 0;
  }

  get fasts => _fasts;

  void incrementOperation(int amount, String user) {
    _fasts = max(_fasts + amount, 0);
    var box = Hive.box('fasts');
    box.put('${user}__amount', _fasts);
    notifyListeners();
  }

  num amountFastsUser({required String user}) {
    var box = Hive.box('fasts');
    return box.get('${user}__amount') ?? 0;
  }
}
