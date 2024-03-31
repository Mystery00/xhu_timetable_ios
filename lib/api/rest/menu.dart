import 'package:dio/dio.dart';
import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/menu.dart';

Future<List<Menu>> apiGetMenuList() async {
  Dio dio = getServerClient();
  var response =
      await dio.get("/api/rest/external/menu/list", queryParameters: {
    "platform": "IOS",
  });
  return List<Menu>.from(response.data.map<Menu>((e) => Menu.fromJson(e)));
}
