import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

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
  return Customisable(data: DateTime(2023, 2, 20, 0, 0, 0), custom: false);
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
  return Customisable(data: 2022, custom: false);
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
  return Customisable(data: 2, custom: false);
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

String _mapKey(String key) => "$key-custom";

class Customisable<T> {
  final T data;
  final bool custom;

  Customisable({required this.data, required this.custom});

  factory Customisable.custom(T data) => Customisable(data: data, custom: true);

  factory Customisable.serverDetect(T data) =>
      Customisable(data: data, custom: false);

  factory Customisable.clearCustom(T data) =>
      Customisable(data: data, custom: false);

  String mapKey(String key) => custom ? _mapKey(key) : key;
}
