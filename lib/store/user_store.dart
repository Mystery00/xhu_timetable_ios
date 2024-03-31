import 'dart:convert';
import 'dart:math';

import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';

MMKV? _instance;
Future<MMKV> _getUserStore() async {
  if (_instance != null) {
    return _instance!;
  }
  var secret = await getUserStoreSecret();
  if (secret.isEmpty) {
    secret = Random(DateTime.now().millisecondsSinceEpoch)
        .nextInt(100000000)
        .toString();
  }
  _instance = MMKV("UserStore", cryptKey: secret);
  return _instance!;
}

const _mainUserKey = "mainUser";
const _loggedUserListKey = "loggedUserList";

Future<bool> isLogin() async {
  return await getMainUser() != null;
}

Future<void> setMainUser(User user) async => setMainUserById(user.studentId);

Future<void> setMainUserById(String studentId) async {
  var store = await _getUserStore();
  store.encodeString(_mainUserKey, studentId);
}

Future<String?> getMainUserId() async {
  var store = await _getUserStore();
  return store.decodeString(_mainUserKey);
}

Future<String> mainUserId() async {
  var id = await getMainUserId();
  if (id == null) {
    throw Exception("Main user not found");
  }
  return id;
}

Future<User?> getMainUser() async {
  var id = await getMainUserId();
  if (id == null) {
    //主用户不存在，返回第一个登录的用户
    var list = await loggedUserList();
    if (list.isEmpty) {
      return null;
    }
    var m = list.first;
    await setMainUser(m);
    return m;
  }
  return await getUserByStudentId(id);
}

Future<User> mainUser() async {
  var u = await getMainUser();
  if (u == null) {
    throw Exception("Main user not found");
  }
  return u;
}

Future<User?> getUserByStudentId(String studentId) async {
  var store = await _getUserStore();
  var s = store.decodeString(_userMapKey(studentId));
  if (s == null) {
    return null;
  }
  return User.fromJson(jsonDecode(s));
}

Future<User> userByStudentId(String studentId) async {
  var u = await getUserByStudentId(studentId);
  if (u == null) {
    throw Exception("user not found");
  }
  return u;
}

Future<List<User>> loggedUserList() async {
  var store = await _getUserStore();
  var s = store.decodeString(_loggedUserListKey);
  if (s == null || s.isEmpty || s == "[]") {
    return [];
  }
  List<String> userMapKeyList = List<String>.from(jsonDecode(s));
  return Future.wait(userMapKeyList.map((e) => userByStudentId(e)));
}

Future<void> login(User user) async {
  var store = await _getUserStore();
  var userMapKey = _userMapKey(user.studentId);
  var json = jsonEncode(user.toJson());
  store.encodeString(userMapKey, json);
  List<String> userMapKeyList = [];
  var s = store.decodeString(_loggedUserListKey);
  if (s != null && s.isNotEmpty && s != "[]") {
    userMapKeyList = jsonDecode(s);
  }
  if (!userMapKeyList.contains(user.studentId)) {
    userMapKeyList.add(user.studentId);
  }
  store.encodeString(_loggedUserListKey, jsonEncode(userMapKeyList));
}

Future<bool> logout(String studentId) async {
  var store = await _getUserStore();
  var mainUserId = await getMainUserId();
  var userMapKey = _userMapKey(studentId);
  store.removeValue(userMapKey);
  List<String> userMapKeyList = [];
  var s = store.decodeString(_loggedUserListKey);
  if (s != null && s.isNotEmpty && s != "[]") {
    userMapKeyList = jsonDecode(s);
  }
  userMapKeyList.remove(studentId);
  store.encodeString(_loggedUserListKey, jsonEncode(userMapKeyList));
  if (mainUserId == studentId) {
    //登出主用户，那么需要重新设置主用户
    var list = await loggedUserList();
    if (list.isEmpty) {
      return true;
    }
    var newMainUser = list.first;
    await setMainUser(newMainUser);
  }
  return mainUserId == studentId;
}

Future<void> updateUser(User user) async {
  var store = await _getUserStore();
  var userMapKey = _userMapKey(user.studentId);
  var json = jsonEncode(user);
  store.encodeString(userMapKey, json);
}

String _userMapKey(String studentId) => "user_$studentId";
