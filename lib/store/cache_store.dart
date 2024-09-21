import 'dart:convert';

import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/model/client_init.dart';
import 'package:xhu_timetable_ios/model/team_member.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

MMKV? _instance;
Future<MMKV> _getCacheStore() async {
  if (_instance != null) {
    return _instance!;
  }
  _instance = MMKV("CacheStore");
  return _instance!;
}

Future<String?> _getStringN(String key) async {
  var store = await _getCacheStore();
  return store.decodeString(key);
}

Future<String> _getString(String key, String defaultValue) =>
    _getStringN(key).then((value) => value ?? defaultValue);

Future<void> _setString(String key, String value) async {
  var store = await _getCacheStore();
  store.encodeString(key, value);
}

Future<List<Splash>> getSplashList() async {
  var value = await _getStringN('splashList');
  if (value == null) {
    return List.empty();
  }
  List<dynamic> list = json.decode(value);
  return List<Splash>.from(list.map((x) => Splash.fromJson(x)));
}

Future<void> setSplashList(List<Splash> value) =>
    _setString("splashList", json.encode(value));

Future<DateTime> getHideSplashBefore() async {
  var value = await _getString('hideSplashBefore', '');
  if (value.isEmpty) {
    return DateTime(2000, 1, 1, 0, 0, 0);
  }
  return DateTimeExt.localDate(value);
}

Future<void> setHideSplashBefore(DateTime date) =>
    _setString('hideSplashBefore', date.formatDate());

Future<DateTime> getLastSyncCourse() async {
  var value = await _getString('lastSyncCourse', '');
  if (value.isEmpty) {
    return DateTime(2000, 1, 1, 0, 0, 0);
  }
  return DateTimeExt.localDate(value);
}

Future<void> setLastSyncCourse(DateTime date) =>
    _setString('lastSyncCourse', date.formatDate());

Future<List<TeamMember>> getTeamMemberList() async {
  var value = await _getStringN('teamMemberList');
  if (value == null) {
    return List.empty();
  }
  List<dynamic> list = json.decode(value);
  return List<TeamMember>.from(list.map((x) => TeamMember.fromJson(x)));
}

Future<void> setTeamMemberList(List<TeamMember> value) =>
    _setString("teamMemberList", json.encode(value));
