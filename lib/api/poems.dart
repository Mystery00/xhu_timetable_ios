import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio getPoemsClient() {
  final dio = Dio();
  dio.options
    ..baseUrl = 'https://v2.jinrishici.com'
    ..connectTimeout = const Duration(seconds: 2)
    ..receiveTimeout = const Duration(seconds: 2)
    ..headers = {
      HttpHeaders.userAgentHeader: FkUserAgent.userAgent!,
    };
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: false,
    requestBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ));
  return dio;
}
