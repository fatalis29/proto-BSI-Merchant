
import 'dart:developer';

import 'package:dbank/utilities/utilities.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  // This is still not working
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final body = options.data.toString();
    final timestamp = getTimestampIso8601();
    // 
    final url = getSubUrlFromPath(options.path);

    final bdiSignature = getBdiSignature(timestamp, url);

    log(options.path);

    // Add All Headers
    options.headers.addAll({
      'Bdi-Signature': 'c283f0f39f3d7a5155a3cce0919ab1739be028e1cd6a75a004e002005f5b015e',
      'Bdi-Timestamp': 'timestamp$timestamp',
      'Bdi-Key': 'a6961472-a2da-4d91-a2bb-8ff009844eee',
      'Url': url
    });

    return super.onRequest(options, handler);
  }
}