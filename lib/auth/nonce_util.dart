import 'dart:math';

/// Generate random nonce untuk SCRAM/Moffas login
/// Default panjang = 32 karakter
String generateNonce([int length = 32]) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random.secure();
  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}
