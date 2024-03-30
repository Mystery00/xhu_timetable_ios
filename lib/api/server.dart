import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:xhu_timetable_ios/store/app.dart';

Dio getServerClient() {
  final dio = Dio();
  dio.options
    ..baseUrl = 'https://xgkb.api.mystery0.vip'
    ..connectTimeout = const Duration(seconds: 20)
    ..receiveTimeout = const Duration(seconds: 20)
    ..headers = {
      HttpHeaders.userAgentHeader: FkUserAgent.userAgent!,
    };
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      var uri = options.path;
      if (uri.contains("?")) {
        uri = uri.substring(0, uri.indexOf("?"));
      }
      var contentType = options.contentType;
      var body = jsonEncode(options.data);
      var signTime = DateTime.now().millisecondsSinceEpoch;

      var map = <String, String>{};
      map['method'] = options.method;
      map['url'] = uri;
      map['body'] = body;
      map['content-type'] = contentType ?? 'empty';
      map['content-length'] = options.headers['Content-Length'] ?? '0';
      map['signTime'] = signTime.toString();
      map['clientVersionName'] = getVersion();
      map['clientVersionCode'] = getBuildNumber();

      var signKey = options.headers['sessionToken'] ?? signTime.toString();
      var salt = md5.convert(utf8.encode(signKey)).toString();
      var sign = sha256.convert(utf8.encode("$map:$salt")).toString();

      options.headers['sign'] = sign;
      options.headers['signTime'] = signTime;
      options.headers['deviceId'] = "ios-test";
      options.headers['clientVersionName'] = getVersion();
      options.headers['clientVersionCode'] = getBuildNumber();

      return handler.next(options);
    },
  ));
  return dio;
}
