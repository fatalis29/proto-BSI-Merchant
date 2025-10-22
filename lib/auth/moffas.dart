import 'dart:convert';
import 'dart:developer';

import 'package:cryptography/cryptography.dart';
import '/models/auth_response.dart';
import 'package:intl/intl.dart';

final GS2_HEADER = 'n,,';

int seq = 0;

String c(){
  return base64Encode(utf8.encode("n,,")); // hasilnya "biws"  
}

String getClientFirstMessage(String username, String saltFE) {
  String n = username.substring(0,4) + username;

  return '${GS2_HEADER}n=$n,r=$saltFE';
}
 
Future getSaltedPassword(String password, String salt, int iteration) async {
  var saltBytes = const Base64Codec().decode(salt);
  var passwordNormalized = password;

  // HI
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iteration, // 4096 iterations
    bits: 256,
  );

  final newSecretKey = await pbkdf2.deriveKeyFromPassword(
    password: passwordNormalized,
    nonce: saltBytes,
  );

  // final secretKeyBytes = await newSecretKey.extractBytes();
  return newSecretKey;
}

Future getClientKey(SecretKey saltedPassword) async {
  var hmac = Hmac.sha256();
  var mac = await hmac.calculateMac(
    const Utf8Codec().encode("Client Key"), 
    secretKey: saltedPassword
  );
  return mac.bytes;
}

Future getStoredKey(List<int> clientKey) async {
  var hashStoredKey = await Sha256().hash(clientKey);
  return SecretKey(hashStoredKey.bytes);
}

String getClientFirstMessageBare(String clientFirstMessage) {
  return clientFirstMessage.substring(GS2_HEADER.length);
}

String getServerFirstMessage(AuthResponse authResponse) {
  return "r=${authResponse.r},s=${authResponse.s},i=${authResponse.i}"; // expiry might not be needed
}

String getClientFinalMessageWithoutProve(String clientFirstMessage, AuthResponse authResponse) {
  return "c=${c()},r=${authResponse.r}";
}

String getAuthMessage(String clientFirstMessageBare, String serverFirstMessage, String clientFinalMessageWithoutProof) {
  return '${clientFirstMessageBare.substring(GS2_HEADER.length)},$serverFirstMessage,$clientFinalMessageWithoutProof';
}

Future getClientSignature(SecretKey storedKey, String authMessage) async {
  var hmac = Hmac.sha256();
  var mac = await hmac.calculateMac(
    const Utf8Codec().encode(authMessage), 
    secretKey: storedKey
  );
  return mac.bytes;
}

List<int> getClientProof(List<int> clientKey, List<int> clientSignature) {
  List<int> clientProof = [];
  for (var i = 0; i < clientKey.length; i++) {
    clientProof.add(clientKey[i]^clientSignature[i]);
  }
  return clientProof;
}

Future<String> p(String username, String password, String saltFE, AuthResponse authResponse) async {
  var saltedPassword = await getSaltedPassword(password, authResponse.s, int.parse(authResponse.i));
  log('salted password ${Base64Codec().encode(saltedPassword.bytes)}');
  var clientKey = await getClientKey(saltedPassword);
  log('client key ${Base64Codec().encode(clientKey)}');
  var storedKey = await getStoredKey(clientKey);
  log('stored key ${Base64Codec().encode(storedKey.bytes)}');
  var clientFirstMessage = getClientFirstMessage(username, saltFE);
  log('client first message $clientFirstMessage');
  var clientFirstMessageBare = getClientFirstMessageBare(clientFirstMessage);
  var authMessage = getAuthMessage(clientFirstMessageBare, getServerFirstMessage(authResponse), getClientFinalMessageWithoutProve(clientFirstMessage, authResponse));
  log('auth message $authMessage');
  var clientSignature = await getClientSignature(storedKey, authMessage);
  log('client signature ${Base64Codec().encode(clientSignature)}');
  var clientProof = getClientProof(clientKey, clientSignature);
  // log('client proof $clientProof');
  var clientProofb64 = const Base64Codec().encode(clientProof);
  log('client proof64 $clientProofb64');
  return clientProofb64;
}

Future<String> getDataFin(String username, String password, String clientNonce, AuthResponse authResponse) async {
  return "c=${c()},r=${authResponse.r},p=${await p(username, password, clientNonce, authResponse)}";
}

String getSequence() {
  var sequance = NumberFormat('0000').format(seq);
  seq += 1;
  return sequance;
}

Future<String> getPayload(String r, {String content = '{\\"fcm_token\\":\\"1234\\",\\"device_uuid\\":\\"0000000\\"}'}) async {
  // '{\\"fcm_token\\":\\"1234\\",\\"device_uuid\\":\\"0000000\\"}'
  var base64 = const Base64Codec();

  log('get payload');
  
  var algorithm = AesCbc.with256bits(
    macAlgorithm: Hmac.sha256(),
  );
  SecretKey secretKey = SecretKey(base64.decode('jEr8rlcgNwsKO44bYHZFEKKeYdXiYbRWcAGKAKwbsPM='));
  //

  var payload = await algorithm.encryptString(
    content, 
    secretKey: secretKey
  );

  var payloadString = base64.encode(payload.cipherText);

  log('payload: $payloadString');

  return payloadString;
}

Future<SecretKey> getAesk(String saltedPassword, String r, {int iteration = 4096}) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iteration, // 4096 iterations
    bits: 256,
  );

  log('get aesk');
  List<int> nonceBytes;
  try {
    nonceBytes = Base64Codec().decode(r);
  } catch (_) {
    nonceBytes = utf8.encode(r);
  }

  final newAesk = await pbkdf2.deriveKeyFromPassword(
    password: saltedPassword,
    nonce: nonceBytes,
  );

  final newAeskString = Base64Codec().encode(await newAesk.extractBytes());
  log('derived AESK: $newAeskString');

  return newAesk;
}

Future<String> getHash(String payload, String sequence, SecretKey aesk) async {
  var hmac = Hmac.sha256();
  var mac = await hmac.calculateMac(
    const Utf8Codec().encode("$payload+$sequence+.v3.1"), 
    secretKey: aesk
  );

  final hashString = Base64Codec().encode(mac.bytes);
  log(hashString);
  return hashString;
}

// aesk = HI(saltedPassword, r=server_nuonce)
// CHash = hmac(aesk, (payload+seq+".v3.1"))