import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

User? _mainUser;
Future<User?> getMainUserWithCache() async {
  if (_mainUser != null) {
    return _mainUser!;
  }
  _mainUser = await getMainUser();
  return _mainUser;
}

Future<void> clearMainUserCache() async {
  _mainUser = null;
}
