import 'dart:convert';
import 'dart:developer';

//import 'package:cryptography/cryptography.dart';
//import '/../auth/auth.dart';
import '/../auth/nonce_util.dart';
import '/../auth/moffas.dart';
import '/../models/auth_response.dart';
import '/../repositories/session_manager.dart';
import 'package:dio/dio.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  factory DioSingleton() => _instance;

  DioSingleton._internal();

  final Dio _client = Dio(
    BaseOptions(
      baseUrl: 'https://devi.cayangqu.com/dmoney',
      headers: {
        // sementara hardcode, sebaiknya pakai AuthInterceptor
        'Bdi-Signature': 'c283f0f39f3d7a5155a3cce0919ab1739be028e1cd6a75a004e002005f5b015e',
        'Bdi-Timestamp': 'timestamp2024-02-13T07:55:39.053Z',
        'Bdi-Key': 'a6961472-a2da-4d91-a2bb-8ff009844eee',
        'Url': '/dmoney/auth'
      },
    ),
  );

  /// Proses login lengkap: /auth → /fin → simpan token
  Future<Response> postLoginInfo(String username, String password) async {
    try {
      // 1. Client First Message
      final clientNonce = generateNonce(); // random nonce
      final clientFirstMessage = getClientFirstMessage(username, clientNonce);

      final authResp = await _client.post(
        '/auth',
        data: {
          "data": clientFirstMessage,
          "AuthType": "login",
        },
      );

      log("authResponseData: ${authResp.data}");

      // 2. Parse Server First Message
      final responseData = authResp.data;
      final stringResponse = responseData['response'];
      final expiryResponse = responseData['expiry'];

      final parts = stringResponse.split(',');
      final r = parts[0].substring(2);
      final s = parts[1].substring(2);
      final i = parts[2].substring(2);

      final authResponse = AuthResponse(r: r, s: s, i: i, expiry: expiryResponse);

      // 3. Client Final Message (FIN)
      final dataFin =
          "c=${c()},r=${authResponse.r},p=${await p(username, password, clientNonce, authResponse)}";

      final sequence = getSequence();
      final payload = await getPayload(authResponse.r);

      // derive AES session key
      final saltedPassword =
          await getSaltedPassword(password, authResponse.s, int.parse(authResponse.i));
      final aesk = await getAesk(Base64Codec().encode(await saltedPassword.extractBytes()), authResponse.r);

      final hash = await getHash(payload, sequence, aesk);

      log("dataFin: $dataFin");

      final finResp = await _client.post(
        '/fin',
        data: {
          "data": dataFin,
          "payload": payload,
          "seq": sequence,
          "hash": hash,
        },
      );

      log("finResponseData: ${finResp.data}");

      // 4. Simpan session-token
      if (finResp.data != null && finResp.data['session-token'] != null) {
        await SecureStorageSingleton().write('session-token', finResp.data['session-token']);
      }

      return finResp;
    } catch (e, st) {
      log("Login ERROR: $e\n$st");
      rethrow;
    }
  }
}
