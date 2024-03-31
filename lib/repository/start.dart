import 'package:xhu_timetable_ios/api/rest/common.dart';
import 'package:xhu_timetable_ios/api/rest/menu.dart';
import 'package:xhu_timetable_ios/model/menu.dart';
import 'package:xhu_timetable_ios/store/menu_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

Future<ReadyState> init() async {
  var isUserLogin = false;
  try {
    isUserLogin = await isLogin();
    await apiClientInit();
    List<Menu> menuList = await apiGetMenuList();
    await updateMenuList(menuList);
    return ReadyState(isLogin: isUserLogin, errorMessage: null);
  } catch (e) {
    return ReadyState(isLogin: isUserLogin, errorMessage: e.toString());
  }
}

class ReadyState {
  final bool isLogin;
  final String? errorMessage;

  ReadyState({required this.isLogin, required this.errorMessage});
}
