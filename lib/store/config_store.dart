import 'dart:convert';
import 'dart:io';

import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/model/custom_account_title.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/app.dart';

MMKV? _instance;
Future<MMKV> _getConfigStore() async {
  if (_instance != null) {
    return _instance!;
  }
  _instance = MMKV("ConfigStore");
  return _instance!;
}

Future<String> _getString(String key, String defaultValue) async {
  var store = await _getConfigStore();
  return store.decodeString(key) ?? defaultValue;
}

Future<void> _setString(String key, String value) async {
  var store = await _getConfigStore();
  store.encodeString(key, value);
}

Future<bool> _getBool(String key, {bool defaultValue = false}) async {
  var store = await _getConfigStore();
  return store.decodeBool(key, defaultValue: defaultValue);
}

Future<void> _setBool(String key, bool value) async {
  var store = await _getConfigStore();
  store.encodeBool(key, value);
}

Future<String> getUserStoreSecret() => _getString('userStoreSecret', '');

Future<void> setUserStoreSecret(String secret) =>
    _setString('userStoreSecret', secret);

Future<DateTime> getTermStartDate() =>
    getCustomTermStartDate().then((value) => value.data);

Future<Customisable<DateTime>> getCustomTermStartDate() async {
  var store = await _getConfigStore();
  var customValue = store.decodeInt(_mapKey("termStartDate"), defaultValue: 0);
  if (customValue != 0) {
    return Customisable(
        data: DateTime.fromMillisecondsSinceEpoch(customValue), custom: true);
  }
  var value = store.decodeInt("termStartDate", defaultValue: 0);
  if (value != 0) {
    return Customisable(
        data: DateTime.fromMillisecondsSinceEpoch(value), custom: false);
  }
  return Customisable(data: initTermStartDate, custom: false);
}

Future<void> setCustomTermStartDate(Customisable<DateTime> value) async {
  var store = await _getConfigStore();
  if (!value.custom && value.data.millisecondsSinceEpoch == 0) {
    store.removeValue(_mapKey("termStartDate"));
    return;
  }
  var key = value.mapKey("termStartDate");
  var saveValue = value.data.atStartOfDay().millisecondsSinceEpoch;
  store.encodeInt(key, saveValue);
}

Future<int> getNowYear() => getCustomNowYear().then((value) => value.data);

Future<Customisable<int>> getCustomNowYear() async {
  var store = await _getConfigStore();
  var customValue = store.decodeInt(_mapKey("nowYear"), defaultValue: -1);
  if (customValue != -1) {
    return Customisable(data: customValue, custom: true);
  }
  var value = store.decodeInt("nowYear", defaultValue: -1);
  if (value != -1) {
    return Customisable(data: value, custom: false);
  }
  return Customisable(data: initNowYear, custom: false);
}

Future<void> setCustomNowYear(Customisable<int> value) async {
  var store = await _getConfigStore();
  if (!value.custom && value.data == -1) {
    store.removeValue(_mapKey("nowYear"));
    return;
  }
  var key = value.mapKey("nowYear");
  store.encodeInt(key, value.data);
}

Future<int> getNowTerm() => getCustomNowTerm().then((value) => value.data);

Future<Customisable<int>> getCustomNowTerm() async {
  var store = await _getConfigStore();
  var customValue = store.decodeInt(_mapKey("nowTerm"), defaultValue: -1);
  if (customValue != -1) {
    return Customisable(data: customValue, custom: true);
  }
  var value = store.decodeInt("nowTerm", defaultValue: -1);
  if (value != -1) {
    return Customisable(data: value, custom: false);
  }
  return Customisable(data: initNowTerm, custom: false);
}

Future<void> setCustomNowTerm(Customisable<int> value) async {
  var store = await _getConfigStore();
  if (!value.custom && value.data == -1) {
    store.removeValue(_mapKey("nowTerm"));
    return;
  }
  var key = value.mapKey("nowTerm");
  store.encodeInt(key, value.data);
}

Future<bool> getShowNotThisWeek() =>
    _getBool("showNotThisWeek", defaultValue: true);

Future<void> setShowNotThisWeek(bool value) =>
    _setBool("showNotThisWeek", value);

Future<bool> getShowStatus() => _getBool("showStatus", defaultValue: true);

Future<void> setShowStatus(bool value) => _setBool("showStatus", value);

Future<bool> getMultiAccountMode() =>
    _getBool("multiAccountMode", defaultValue: false);

Future<void> setMultiAccountMode(bool value) =>
    _setBool("multiAccountMode", value);

Future<CustomAccountTitle> getCustomAccountTitle() async {
  var save = await _getString("customAccountTitle", "");
  if (save.isEmpty) {
    return DEFAULT_CUSTOM_ACCOUNT_TITLE;
  }
  return CustomAccountTitle.fromJson(json.decode(save));
}

Future<void> setCustomAccountTitle(CustomAccountTitle value) async {
  var save = json.encode(value.toJson());
  await _setString("customAccountTitle", save);
}

Future<bool> isDebugMode() => _getBool("debugMode", defaultValue: false);

Future<void> setDebugMode(bool value) => _setBool("debugMode", value);

Future<Customisable<File?>> getBackgroundImage() async {
  var store = await _getConfigStore();
  if (store.containsKey(_mapKey("backgroundImage"))) {
    //有自定义数据
    var customValue = store.decodeString(_mapKey("backgroundImage"));
    if (customValue != null) {
      return Customisable.custom(File(customValue));
    }
  }
  var value = store.decodeString("backgroundImage");
  if (value != null) {
    return Customisable.notCustom(File(value));
  }
  //没有设置过背景图
  return Customisable.notCustom(null);
}

Future<void> setBackgroundImage(Customisable<File?> image) async {
  var store = await _getConfigStore();
  if (image.data == null) {
    //默认值
    store.removeValue(_mapKey("backgroundImage"));
    store.removeValue("backgroundImage");
    return;
  }
  if (image.custom) {
    var key = image.mapKey("backgroundImage");
    var saveValue = image.data!.path;
    store.encodeString(key, saveValue);
  } else {
    store.encodeString("backgroundImage", image.data!.path);
  }
}

Future<bool> getShowCustomThing() => _getBool("showCustomThing", defaultValue: true);

Future<void> setShowCustomThing(bool value) => _setBool("showCustomThing", value);

String _mapKey(String key) => "$key-custom";

class Customisable<T> {
  final T data;
  final bool custom;

  Customisable({required this.data, required this.custom});

  factory Customisable.custom(T data) => Customisable(data: data, custom: true);

  factory Customisable.notCustom(T data) =>
      Customisable(data: data, custom: false);

  factory Customisable.clearCustom(T data) =>
      Customisable(data: data, custom: false);

  String mapKey(String key) => custom ? _mapKey(key) : key;
}
