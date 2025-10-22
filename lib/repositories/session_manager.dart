import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefSingleton {
  static final SharedPrefSingleton _instance = SharedPrefSingleton._internal();
  factory SharedPrefSingleton() => _instance;

  late SharedPreferences _pref;

  SharedPrefSingleton._internal();

  Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  // Functions
  Future<bool> setName(String name) => _pref.setString('name_key', name);
  String get name => _pref.getString('name_key') ?? '';
}

class SecureStorageSingleton {
  static final SecureStorageSingleton _instance = SecureStorageSingleton._internal();
  factory SecureStorageSingleton() => _instance;

  late FlutterSecureStorage _storage;

  SecureStorageSingleton._internal();

  Future<void> initialize() async {
    _storage = const FlutterSecureStorage(aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ));

    await write('Bdi-Key', 'a6961472-a2da-4d91-a2bb-8ff009844eee');
    await write('api_key', '284cd721-3b6a-4d4b-984e-3995ae5d1ae7');
    await write('add_key', '74145');
  }

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);
  Future<String?> getValue(String key) => _storage.read(key: key);

  Future<String?> get bdiKey => _storage.read(key: 'Bdi-Key');
  Future<String?> get apiKey => _storage.read(key: 'api_key');
  Future<String?> get addKey => _storage.read(key: 'add_key');
}

bool checkSession(String? session) {
  return true; // TODO: check session to server
}