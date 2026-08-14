import 'package:shared_preferences/shared_preferences.dart';

class LanguageLocalDataSource {
  Future<String> readLanguageFromHive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_language') ?? 'en';
  }

  Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', code);
  }
}