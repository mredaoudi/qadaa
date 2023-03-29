import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PeopleProvider extends ChangeNotifier {
  String _currentUser = '';

  PeopleProvider() {
    setup();
  }

  void setup() {
    var box = Hive.box('people');
    _currentUser = box.get('currentUser') ?? '';
  }

  void setCurrentUser(name) {
    var box = Hive.box('people');
    _currentUser = name;
    box.put('currentUser', name);
    notifyListeners();
  }

  void createPerson({name, firstTime = false}) {
    var box = Hive.box('people');
    if (firstTime) {
      var initialList = [name];
      box.put('users', initialList);
      box.put('currentUser', name);
      _currentUser = name;
    } else {
      var userList = box.get('users');
      userList.add(name);
      box.put('users', userList);
    }
    notifyListeners();
  }

  List getPeople() {
    var box = Hive.box('people');
    var userList = box.get('users');
    return userList;
  }

  get currentUser => _currentUser;
}
