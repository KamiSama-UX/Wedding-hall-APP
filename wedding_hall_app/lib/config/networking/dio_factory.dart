import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:io' show Platform;

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);
    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioInterceptor();
      setLanguageIntoHeader();
      return dio!;
    } else {
      return dio!;
    }
  }

  static Future<void> setTokenIntoHeader(String token) async {
    dio!.options.headers['Authorization'] = 'Bearer $token';
  }

  static void setLanguageIntoHeader() {
    String languageCode = Platform.localeName.substring(0, 2);
    dio?.options.headers['Accept-Language'] = languageCode;
  }

  static void addDioInterceptor() {
    // Add logger only in debug mode
    if (!kReleaseMode) {
      dio!.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          error: true,
        ),
      );
    }
  }
}
