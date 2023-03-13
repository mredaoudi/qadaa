import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PeopleProvider extends ChangeNotifier {
  String _person = '';

  PeopleProvider() {
    setup();
  }

  void setup() {
    var box = Hive.box('people');
    _person = box.get('person') ?? '';
  }

  get person => _person;
}
