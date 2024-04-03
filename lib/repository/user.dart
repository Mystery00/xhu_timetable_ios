import 'package:xhu_timetable_ios/store/user_store.dart';

Future<List<LoggedUserItem>> loadLoggedUserList() async {
  var mainUserId = await getMainUserId();
  var list = await loggedUserList();
  return list
      .map((element) => LoggedUserItem(
            studentId: element.studentId,
            userName: element.userInfo.name,
            gender: element.userInfo.gender,
            isMain: element.studentId == mainUserId,
            xhuGrade: element.userInfo.xhuGrade,
            college: element.userInfo.college,
            majorName: element.userInfo.majorName,
            majorDirection: element.userInfo.majorDirection,
          ))
      .toList();
}

class LoggedUserItem {
  final String studentId;
  final String userName;
  final String gender;
  final bool isMain;
  final int xhuGrade;
  final String college;
  final String majorName;
  final String majorDirection;

  LoggedUserItem(
      {required this.studentId,
      required this.userName,
      required this.gender,
      required this.isMain,
      required this.xhuGrade,
      required this.college,
      required this.majorName,
      required this.majorDirection});
}
