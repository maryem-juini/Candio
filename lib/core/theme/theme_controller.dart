import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // Observable theme mode
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  // Observable theme data
  final _themeData = AppTheme.lightTheme.obs;
  ThemeData get themeData => _themeData.value;

  // Theme mode stream
  Stream<bool> get themeModeStream => _isDarkMode.stream;

  // Shared preferences key
  static const String _themeKey = 'theme_mode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load saved theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getBool(_themeKey) ?? false;
      _setThemeMode(savedThemeMode);
    } catch (e) {
      // If there's an error loading theme, use light mode as default
      _setThemeMode(false);
    }
  }

  /// Save theme mode to shared preferences
  Future<void> _saveThemeMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      // Handle error silently
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Set theme mode and update UI
  void _setThemeMode(bool isDark) {
    _isDarkMode.value = isDark;
    _themeData.value = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newMode = !_isDarkMode.value;
    _setThemeMode(newMode);
    await _saveThemeMode(newMode);
  }

  /// Set specific theme mode
  Future<void> setThemeMode(bool isDark) async {
    if (_isDarkMode.value != isDark) {
      _setThemeMode(isDark);
      await _saveThemeMode(isDark);
    }
  }

  /// Set theme mode based on system preference
  Future<void> setSystemTheme() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;
    await setThemeMode(isDark);
  }

  /// Get current theme mode as string
  String get themeModeString => _isDarkMode.value ? 'Dark' : 'Light';

  /// Check if current theme is dark
  bool get isDark => _isDarkMode.value;

  /// Check if current theme is light
  bool get isLight => !_isDarkMode.value;
}
