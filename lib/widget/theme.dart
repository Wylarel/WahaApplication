import 'package:flutter/material.dart';
import 'package:waha/static/config.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = false;

  MyTheme(){
    if(box.containsKey('currentTheme'))
      _isDark = box.get('currentTheme');
    else
      box.put('currentTheme', _isDark);
  }

  ThemeMode currentTheme(){
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(bool newTheme) {
    _isDark = newTheme;
    notifyListeners();
  }

  bool isDark() {
    return _isDark;
  }
}