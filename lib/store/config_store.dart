import 'package:mmkv/mmkv.dart';

MMKV? _instance;
Future<MMKV> _getConfigStore() async {
  if (_instance != null) {
    return _instance!;
  }
  _instance = MMKV("ConfigStore");
  return _instance!;
}

Future<String> getUserStoreSecret() async {
  var store = await _getConfigStore();
  return store.decodeString("userStoreSecret") ?? "";
}

Future<void> setUserStoreSecret(String secret) async {
  var store = await _getConfigStore();
  store.encodeString('userStoreSecret', secret);
}
