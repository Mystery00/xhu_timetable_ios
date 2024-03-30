import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/client_init.dart';

Future<ClientInitResponse> clientInit() async {
  var deviceInfo = DeviceInfoPlugin();
  var iosInfo = await deviceInfo.iosInfo;
  Dio dio = getServerClient();

  var map = <String, dynamic>{};
  map['versionSys'] = "iOS ${iosInfo.systemVersion}";
  map['deviceFactory'] = iosInfo.model;
  map['deviceModel'] = iosInfo.name;
  map['deviceRom'] = iosInfo.systemName;
  map['checkBetaVersion'] = false;
  map['alwaysShowVersion'] = false;

  var response =
      await dio.post("/api/rest/external/common/client/init", data: map);
  if (response.statusCode != 200) {
    throw Exception(
        "Failed to init client, status code: ${response.statusCode}");
  }
  return ClientInitResponse.fromJson(response.data);
}
