import 'package:flutter/material.dart';
import 'package:knekroapp/pages/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme with ChangeNotifier {
  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(isDark);
    print(!isDark);
    isDark = !isDark;
    print(isDark);
    sharedPreferences.setBool('darkmode', isDark);

    notifyListeners();
  }
}
