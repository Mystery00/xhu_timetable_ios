import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class BaseDataRepo {
  bool isOnline() {
    //todo: implement this method
    return true;
  }

  void checkForceLoadFromCloud(bool forceLoadFromCloud) {
    if (!forceLoadFromCloud) {
      return;
    }
    if (!isOnline()) {
      throw Exception(HINT_NETWORK);
    }
  }

  Future<List<User>> requestUserList() async {
    var multiAccountMode = await getMultiAccountMode();
    if (multiAccountMode) {
      return await loggedUserList();
    }
    var u = await mainUser();
    return [u];
  }

  Future<List<User>> getLoggedUserList() async {
    return await loggedUserList();
  }

  Future<User> getMainUser() async {
    return await mainUser();
  }
}

// ignore: constant_identifier_names
const String HINT_NETWORK = "网络无法使用，请检查网络连接！";
