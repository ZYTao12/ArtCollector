import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final _storage = FlutterSecureStorage();

  // Write values
  Future<void> writeCredentials(String username, String password) async {
    await _storage.write(key: 'username', value: 'admin');
    await _storage.write(key: 'password', value: 'Sunny20031022');
  }

  // Read values
  Future<Map<String, String?>> readCredentials() async {
    String? username = await _storage.read(key: 'username');
    String? password = await _storage.read(key: 'password');
    return {'username': username, 'password': password};
  }

  // Delete values
  Future<void> deleteCredentials() async {
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }
}