import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FastProvider extends ChangeNotifier {
  int _fasts = 0;

  FastProvider() {
    setup();
  }

  void setup() {
    var box = Hive.box('fasts');
    _fasts = box.get('amount') ?? 0;
  }

  get fasts => _fasts;

  void incrementOperation(int amount) {
    _fasts = max(_fasts + amount, 0);
    var box = Hive.box('fasts');
    box.put('amount', _fasts);
    notifyListeners();
  }
}
