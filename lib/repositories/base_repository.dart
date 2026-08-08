/// Base Repository Template with Exception Handling
abstract class BaseRepository {
  Future<T> callGuard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw Exception('Repository Error: ${e.toString()}');
    }
  }
}
