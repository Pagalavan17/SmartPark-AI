/// Abstract Service Interface for Google Maps & Positioning
abstract class IMapsService {
  Future<bool> checkAndRequestLocationPermission();
  Future<Map<String, double>?> getCurrentCoordinates();
  Future<List<Map<String, dynamic>>> getDirections(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
  );
}
