import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/user_campus.dart';
import 'package:xhu_timetable_ios/model/user_info.dart';

Future<String> apiGetPublicKey() async {
  var dio = getServerClient();
  var response = await dio.get("/api/rest/external/login/publicKey");
  return response.data['publicKey'];
}

Future<String> apiLogin(
    String username, String password, String publicKey) async {
  var dio = getServerClient();
  var response = await dio.post("/api/rest/external/login", data: {
    "username": username,
    "password": password,
    "publicKey": publicKey,
  });
  return response.data['sessionToken'];
}

Future<UserInfo> apiGetUserInfo(String sessionToken) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response = await dio.get("/api/rest/external/user/info");
  return UserInfo.fromJson(response.data);
}

Future<UserCampus> apiGetCampusList(String sessionToken) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response = await dio.get("/api/rest/external/user/campus/list");
  return UserCampus.fromJson(response.data);
}

Future<void> apiSetCampus(String sessionToken, String campus) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  dio.options.contentType = "application/json";
  await dio.put("/api/rest/external/user/campus", data: {
    "campus": campus,
  });
}
