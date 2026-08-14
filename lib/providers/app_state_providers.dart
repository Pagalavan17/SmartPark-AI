import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLanguageStorageKey = 'selected_language';
const String _kDarkModeStorageKey = 'is_dark_mode';

/// Global App State Providers
final isAppInitializedProvider = StateProvider<bool>((ref) => false);

/// StateNotifier for Managing Dark Mode State & Persisting Changes
class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDark = prefs.getBool(_kDarkModeStorageKey);
      if (savedDark != null) {
        state = savedDark;
      }
    } catch (_) {
      // Fallback default false (light mode)
    }
  }

  Future<void> toggleTheme([bool? value]) async {
    final newValue = value ?? !state;
    state = newValue;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDarkModeStorageKey, newValue);
    } catch (_) {}
  }
}

/// Single Source of Truth for App-Wide Dark Mode State
final isDarkModeProvider =
    StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier();
});

/// StateNotifier for Managing Active Language Code & Persisting Changes
class ActiveLanguageNotifier extends StateNotifier<String> {
  ActiveLanguageNotifier() : super('en') {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_kLanguageStorageKey);
      if (savedCode != null && ['en', 'ta', 'hi', 'ml', 'kn'].contains(savedCode)) {
        state = savedCode;
      }
    } catch (_) {
      // Fallback default 'en'
    }
  }

  Future<void> setLanguage(String code) async {
    if (!['en', 'ta', 'hi', 'ml', 'kn'].contains(code)) return;
    state = code;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguageStorageKey, code);
    } catch (_) {}
  }
}

/// Single Source of Truth for App-Wide Language Code
final activeLanguageCodeProvider =
    StateNotifierProvider<ActiveLanguageNotifier, String>((ref) {
  return ActiveLanguageNotifier();
});
