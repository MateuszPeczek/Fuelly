import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends Model {
  static const String _darkModeKey = "DARK_MODE";
  static const String _accentColorKey = "ACCENT_COLOR";

  ThemeModel(this._preferences) {
    try {
      var persistedDarkModeSettings = _preferences.getBool(_darkModeKey);
      _brightness =
          persistedDarkModeSettings ? Brightness.dark : Brightness.light;
    } catch (e) {
      _brightness = Brightness.light;
    }

    try {
      var persistedAccentColor = _preferences.getInt(_accentColorKey);
      _accentColor = Color(persistedAccentColor);
    } catch (e) {
      _accentColor = Colors.purple;
    }
  }

  final SharedPreferences _preferences;

  Brightness _brightness = Brightness.light;
  Color _accentColor = Colors.purple;

  ThemeData get theme =>
      _brightness == Brightness.light ? _buildLightTheme() : _buildDarkTheme();
  Brightness get brightness => _brightness;
  Color get accentColor => _accentColor;

  Future<void> switchDarkMode() async {
    if (_brightness == Brightness.light) {
      _brightness = Brightness.dark;
      await _preferences.setBool(_darkModeKey, true);
    } else {
      _brightness = Brightness.light;
      await _preferences.setBool(_darkModeKey, false);
    }
    notifyListeners();
  }

  void updateAccentColor(Color color) {
    _accentColor = color;
    _preferences.setInt(_accentColorKey, color.value);
    notifyListeners();
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        backgroundColor: Colors.grey[900],
        accentColor: _accentColor,
        textTheme: TextTheme(title: TextStyle(color: Colors.white)));
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        accentColor: _accentColor,
        textTheme: TextTheme(title: TextStyle(color: Colors.black87)));
  }
}
