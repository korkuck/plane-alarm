import 'package:flutter_secure_storage_x/flutter_secure_storage_x.dart';

class ApiKeyStorage {
  const ApiKeyStorage._();

  static const _storage = FlutterSecureStorage();
  static const _apiKeyId = 'api_key_id';

  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyId, value: apiKey);
  }

  static Future<String?> readApiKey() async {
    return await _storage.read(key: _apiKeyId);
  }
}
