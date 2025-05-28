import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xhu_timetable_ios/model/user_info.dart';
import 'package:xhu_timetable_ios/repository/main.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

class MainModel with ChangeNotifier {
  bool isRefreshing = false;
  List<TodayCourseSheet> todayCourseSheetList = [];
  List<TodayThingSheet> todayThingSheetList = [];
  List<List<WeekCourseSheet>> weekCourseSheetList = List.generate(7, (_) => []);
  DateTime weekDateStart = DateTime.now().atStartOfDay();
  UserInfo? userInfo;

  static MainModel of(BuildContext context, {bool listen = true}) {
    return Provider.of<MainModel>(context, listen: listen);
  }

  bool isTodayNoData() {
    return todayCourseSheetList.isEmpty && todayThingSheetList.isEmpty;
  }

  bool isWeekNoData() {
    return weekCourseSheetList.every((list) => list.isEmpty);
  }

  void setRefreshing(bool isRefreshing) {
    this.isRefreshing = isRefreshing;
    notifyListeners();
  }

  void setTodayCourseSheetList(List<TodayCourseSheet> todayCourseSheetList) {
    this.todayCourseSheetList = todayCourseSheetList;
    notifyListeners();
  }

  void setTodayThingSheetList(List<TodayThingSheet> todayThingSheetList) {
    this.todayThingSheetList = todayThingSheetList;
    notifyListeners();
  }

  void setWeekCourseSheetList(List<List<WeekCourseSheet>> weekCourseSheetList) {
    this.weekCourseSheetList = weekCourseSheetList;
    notifyListeners();
  }

  void setWeekDateStart(DateTime weekDateStart) {
    this.weekDateStart = weekDateStart;
    notifyListeners();
  }

  void setUserInfo(UserInfo? userInfo) {
    this.userInfo = userInfo;
    notifyListeners();
  }
}
