import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/client_init.dart';
import 'package:xhu_timetable_ios/model/team_member.dart';

Future<ClientInitResponse> apiClientInit() async {
  var deviceInfo = DeviceInfoPlugin();
  var iosInfo = await deviceInfo.iosInfo;
  Dio dio = getServerClient();

  var map = <String, dynamic>{};
  map['versionSys'] = "iOS ${iosInfo.systemVersion}";
  map['deviceFactory'] = iosInfo.model;
  map['deviceModel'] = iosInfo.utsname.machine;
  map['deviceRom'] = iosInfo.isPhysicalDevice ? "Physical" : "Simulator";
  map['checkBetaVersion'] = false;
  map['alwaysShowVersion'] = false;

  var response =
      await dio.post("/api/rest/external/common/client/init", data: map);
  return ClientInitResponse.fromJson(response.data);
}

Future<List<TeamMember>> apiTeamMemberList() async {
  Dio dio = getServerClient();
  var response = await dio.get("/api/rest/external/common/team");
  return List<TeamMember>.from(
      response.data.map((x) => TeamMember.fromJson(x)));
}
