abstract class ILanguageRepository {
  Future<void> saveLanguage(String languageCode);
  Future<String> getSavedLanguage();
}
