import "package:mmkv/mmkv.dart";
import "package:xhu_timetable_ios/model/poems.dart";
import "package:xhu_timetable_ios/api/poems.dart";

MMKV? _instance;
Future<MMKV> _getPoemsStore() async {
  if (_instance != null) {
    return _instance!;
  }
  _instance = MMKV("PoemsStore");
  return _instance!;
}

Future<bool> isDisablePoems() async {
  var store = await _getPoemsStore();
  return store.decodeBool("disablePoems", defaultValue: false);
}

Future<void> setDisablePoems(bool disable) async {
  var store = await _getPoemsStore();
  store.encodeBool("disablePoems", disable);
}

Future<String> getToken() async {
  var store = await _getPoemsStore();
  return store.decodeString("token") ?? "";
}

Future<void> setToken(String token) async {
  var store = await _getPoemsStore();
  if (token.isEmpty) {
    store.removeValue("token");
  } else {
    store.encodeString("token", token);
  }
}

Future<bool> isShowTranslate() async {
  var store = await _getPoemsStore();
  return store.decodeBool("showPoemsTranslate", defaultValue: true);
}

Future<void> setShowTranslate(bool show) async {
  var store = await _getPoemsStore();
  store.encodeBool("showPoemsTranslate", show);
}

Poems? _poems;
Future<Poems> loadPoems() async {
  if (_poems != null) {
    return _poems!;
  }
  var token = await _getTokenOrRequest();
  var dio = getPoemsClient();
  dio.options.headers['X-User-Token'] = token;
  var response = await dio.get('/sentence');
  if (response.statusCode != 200) {
    throw Exception("Get token failed, status code: ${response.statusCode}");
  }
  var poems = Poems.fromJson(response.data);
  var showTranslate = await isShowTranslate();
  if (!showTranslate) {
    poems.translate = null;
  }
  _poems = poems;
  return poems;
}

Future<String> _getTokenOrRequest() async {
  var token = await getToken();
  if (token.isNotEmpty) {
    return token;
  }
  var dio = getPoemsClient();
  var response = await dio.get('/token');
  if (response.statusCode != 200) {
    throw Exception("Get token failed, status code: ${response.statusCode}");
  }
  if (response.data['status'] != "success") {
    throw Exception("Get token failed, status: ${response.data['status']}");
  }
  token = response.data['data'];
  await setToken(token);
  return token;
}
