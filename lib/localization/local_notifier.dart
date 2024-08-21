import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier with ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  LocaleNotifier() {
    _loadFromPrefs();
  }

  void changeLanguage(Locale newLocale) async {
    _locale = newLocale;
    _saveToPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', _locale.languageCode);
  }
}
