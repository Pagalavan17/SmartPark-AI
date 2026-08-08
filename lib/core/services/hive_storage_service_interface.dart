/// Abstract Storage Interface for Hive Local Storage
abstract class IHiveStorageService {
  Future<void> initHive();
  Future<void> saveUserProfile(Map<String, dynamic> profileData);
  Future<Map<String, dynamic>?> getUserProfile();
  Future<void> saveThemeMode(String mode);
  Future<String?> getThemeMode();
  Future<void> saveLanguage(String languageCode);
  Future<String?> getLanguage();
  Future<void> cacheRecentBookings(List<Map<String, dynamic>> bookings);
  Future<List<Map<String, dynamic>>> getCachedRecentBookings();
  Future<void> toggleFavoriteParking(String parkingId);
  Future<List<String>> getFavoriteParkingIds();
}
