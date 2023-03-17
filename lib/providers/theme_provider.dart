import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _light = true;

  ThemeProvider() {
    setup();
  }

  void setup() {
    var box = Hive.box('theme');
    _light = box.get('currentTheme') ?? true;
  }

  void changeTheme() {
    var box = Hive.box('theme');
    _light = !_light;
    box.put('currentTheme', _light);
    notifyListeners();
  }

  Color background() {
    return _light
        ? const Color.fromARGB(255, 255, 253, 250)
        : const Color(0xFF121212);
  }

  Color appbar() {
    return _light
        ? const Color(0xFF4E6E81)
        : const Color.fromARGB(255, 25, 25, 25);
  }

  Color icon() {
    return _light
        ? const Color(0xFF4E6E81)
        : const Color.fromARGB(255, 255, 253, 250).withOpacity(0.87);
  }

  Color text() {
    return _light
        ? const Color.fromARGB(255, 126, 126, 126)
        : const Color.fromARGB(255, 255, 253, 250).withOpacity(0.87);
  }

  Color minus() {
    return const Color(0xFF4DAB8F).withOpacity(0.87);
  }

  Color plus() {
    return const Color.fromARGB(255, 162, 57, 57).withOpacity(0.87);
  }
}
