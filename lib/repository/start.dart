import 'package:xhu_timetable_ios/api/rest/common.dart';
import 'package:xhu_timetable_ios/api/rest/menu.dart';
import 'package:xhu_timetable_ios/model/menu.dart';
import 'package:xhu_timetable_ios/model/team_member.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/menu_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

Future<ReadyState> init() async {
  var isUserLogin = false;
  try {
    isUserLogin = await isLogin();
    var response = await apiClientInit();
    await setCustomTermStartDate(
        Customisable.serverDetect(response.xhuStartTime.startDate));
    await setCustomNowYear(
        Customisable.serverDetect(response.xhuStartTime.nowYear));
    await setCustomNowTerm(
        Customisable.serverDetect(response.xhuStartTime.nowTerm));
    List<Menu> menuList = await apiGetMenuList();
    await updateMenuList(menuList);
    Map<String, String> courseTime = await apiCourseTime();
    await setCourseTime(courseTime);
    List<TeamMember> teamMemberList = await apiTeamMemberList();
    await setTeamMemberList(teamMemberList);
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
