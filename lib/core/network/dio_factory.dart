import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 60);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      // تهيئة الـ Adapter للتعامل مع استقرار الاتصال
      dio!.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback =
              (cert, host, port) => true; // لتجنب مشاكل الـ SSL
          return client;
        },
      );

      addDioHeaders();
      addDioInterceptor();
    }
    return dio!;
  }

  static void addDioHeaders() {
    dio?.options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    });
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers.addAll({
      "Authorization": "Bearer $token",
    });
  }

  static void addDioInterceptor() {
    if (!kReleaseMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          error: true,
          compact: true,
        ),
      );
    }
  }
}
