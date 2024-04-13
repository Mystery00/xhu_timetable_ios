import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:xhu_timetable_ios/store/app.dart';

Dio getServerClient() {
  final dio = Dio();
  dio.options
    ..baseUrl = 'https://xgkb.api.mystery0.vip'
    ..connectTimeout = const Duration(seconds: 20)
    ..receiveTimeout = const Duration(seconds: 20)
    ..validateStatus = (status) {
      return status != null && status >= 200 && status < 300;
    }
    ..headers = {
      HttpHeaders.userAgentHeader: FkUserAgent.userAgent!,
    };
  if (isDebug()) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      var uri = options.path;
      if (uri.contains("?")) {
        uri = uri.substring(0, uri.indexOf("?"));
      }
      var contentType = options.contentType;
      var body = "";
      if (options.data != null) {
        body = jsonEncode(options.data);
      }
      var signTime = DateTime.now().millisecondsSinceEpoch;

      var map = <String, String>{};
      map['body'] = body;
      map['clientVersionCode'] = getBuildNumber();
      map['clientVersionName'] = getVersion();
      map['content-length'] = body.length.toString();
      map['content-type'] = contentType ?? 'empty';
      map['method'] = options.method;
      map['signTime'] = signTime.toString();
      map['url'] = uri;

      var signKey = options.headers['sessionToken'] ?? signTime.toString();
      var salt = md5
          .convert(utf8.encode("$signKey:XhuTimeTable"))
          .toString()
          .toUpperCase();
      var sign = sha256
          .convert(utf8.encode("${_mapToString(map)}:$salt"))
          .toString()
          .toUpperCase();

      options.headers['sign'] = sign;
      options.headers['signTime'] = signTime;
      options.headers['deviceId'] = getDeviceId();
      options.headers['clientVersionName'] = getVersion();
      options.headers['clientVersionCode'] = getBuildNumber();

      return handler.next(options);
    },
    onError: (error, handler) {
      if (error.response == null) {
        return handler.next(error);
      }
      var resp = error.response!;
      if (resp.statusCode == 401) {
        throw ServerNeedLoginException();
      }
      var msg = resp.data['message'] ?? "未知错误";
      throw ServerError(msg);
    },
  ));
  return dio;
}

String _mapToString(Map<String, String> m) {
  var result = StringBuffer();
  result.write('{');
  bool first = true;
  m.forEach((k, v) {
    if (!first) {
      result.write(', ');
    }
    first = false;
    result.write(k);
    result.write('=');
    result.write(v);
  });
  result.write('}');
  return result.toString();
}

class ServerNeedLoginException implements Exception {}

class ServerError {
  final String message;

  ServerError(this.message);

  @override
  String toString() {
    return message;
  }
}
