import 'dart:convert';
import 'dart:math';

import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/model/user_info.dart';
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
  var store = await _getUserStore();
  return store.decodeBool("isLogin", defaultValue: false);
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
    return null;
  }
  return getUserByStudentId(id);
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
  List<String> userMapKeyList = jsonDecode(s);
  return Future.wait(userMapKeyList.map((e) => userByStudentId(e)));
}

Future<void> login(User user) async {
  var store = await _getUserStore();
  var userMapKey = user._userMapKey();
  var json = jsonEncode(user);
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
  var userMapKey = user._userMapKey();
  var json = jsonEncode(user);
  store.encodeString(userMapKey, json);
}

class User {
  final String studentId;
  final String password;
  final String token;
  final UserInfo userInfo;
  final String? profileImage;

  User(
      {required this.studentId,
      required this.password,
      required this.token,
      required this.userInfo,
      required this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      studentId: json['studentId'],
      password: json['password'],
      token: json['token'],
      userInfo: UserInfo.fromJson(json['userInfo']),
      profileImage: json['profileImage'],
    );
  }

  String _userMapKey() => "user_$studentId";
}

String _userMapKey(String studentId) => "user_$studentId";
