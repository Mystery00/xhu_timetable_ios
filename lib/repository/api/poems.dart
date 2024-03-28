import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';

Dio getPoemsClient() {
  final dio = Dio();
  dio.options
    ..baseUrl = 'https://v2.jinrishici.com'
    ..connectTimeout = const Duration(seconds: 2)
    ..receiveTimeout = const Duration(seconds: 2)
    ..headers = {
      HttpHeaders.userAgentHeader: FlutterUserAgent.userAgent,
    };
  return dio;
}
