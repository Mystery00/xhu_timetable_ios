import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

MMKV? _instance;
Future<MMKV> _getCacheStore() async {
  if (_instance != null) {
    return _instance!;
  }
  _instance = MMKV("CacheStore");
  return _instance!;
}

Future<DateTime> getLastSyncCourse() async {
  var store = await _getCacheStore();
  var value = store.decodeString("lastSyncCourse") ?? "";
  if (value.isEmpty) {
    return DateTime(2000, 1, 1, 0, 0, 0);
  }
  return DateTimeExt.localDate(value);
}

Future<void> setLastSyncCourse(DateTime date) async {
  var store = await _getCacheStore();
  store.encodeString('lastSyncCourse', date.formatDate());
}
