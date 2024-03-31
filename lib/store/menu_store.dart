import 'dart:collection';
import 'dart:convert';

import 'package:mmkv/mmkv.dart';
import 'package:xhu_timetable_ios/model/menu.dart';

MMKV? _instance;
Future<MMKV> _getMenuStore() async {
  if (_instance != null) {
    return _instance!;
  }
  _instance = MMKV("MenuStore");
  return _instance!;
}

List<List<Menu>>? _menuList;
Future<List<List<Menu>>> loadAllMenu() async {
  var store = await _getMenuStore();
  var menuList = store.decodeString("menuList");
  if (menuList == null || menuList.isEmpty || menuList == "[]") {
    return [];
  }
  var list = (jsonDecode(menuList) as List<dynamic>)
      .map((e) => Menu.fromJson(e))
      .toList();
  var menuGroup = SplayTreeMap<int, List<Menu>>();
  for (var element in list) {
    if (!menuGroup.containsKey(element.group)) {
      menuGroup[element.group] = [];
    }
    menuGroup[element.group]!.add(element);
  }
  menuGroup.forEach((key, value) {
    value.sort((a, b) => a.sort.compareTo(b.sort));
  });
  _menuList = menuGroup.values.toList();
  return _menuList!;
}

Future<void> updateMenuList(List<Menu> list) async {
  var store = await _getMenuStore();
  store.clearAll();
  store.encodeString("menuList", jsonEncode(list));
  _menuList = null;
}
