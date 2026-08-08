abstract class ISettingsRepository {
  Future<void> setThemeMode(String themeMode);
  Future<String> getThemeMode();
}
