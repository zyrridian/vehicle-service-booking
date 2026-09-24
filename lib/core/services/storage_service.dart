/// Contract for local storage operations.
abstract class StorageService {
  Future<void> init();
  Future<void> write(String key, dynamic value);
  Future<dynamic> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
}
