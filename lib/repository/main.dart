import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/transfer/aggregation_view.dart';
import 'package:xhu_timetable_ios/model/transfer/today_course_view.dart';
import 'package:xhu_timetable_ios/repository/aggregation.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

AggregationRepo _aggregationRepo = AggregationRepo();
Future<AggregationView> getMainPageData(
  bool forceLoadFromCloud,
  bool forceLoadFromLocal,
) async {
  var showCustomCourse = false;
  var showCustomThing = false;
  var view = await _aggregationRepo.fetchAggregationMainPage(forceLoadFromCloud,
      forceLoadFromLocal, showCustomCourse, showCustomThing);
  if (view.loadWarning?.isNotEmpty ?? false) {
    print(view.loadWarning);
  }
  return view;
}

Future<List<TodayCourseSheet>> getTodayCourseSheetList(
  int currentWeek,
  List<TodayCourseView> courseList,
) async {
  var today = DateTime.now().atStartOfDay();
  DateTime showDate;
  int weekDay;
  int showCurrentWeek;

  showDate = today;
  weekDay = showDate.weekday;
  showCurrentWeek = currentWeek;

  //过滤出今天或明天的课程
  var showList = courseList
      .where((element) =>
          element.weekList.contains(showCurrentWeek) &&
          element.dayIndex == weekDay)
      .toList();
  if (showList.isEmpty) {
    return [];
  }
  showList.sort((a, b) => a.startTime.compareTo(b.startTime));
  //合并相同课程
  var resultList = <TodayCourseView>[];
  //计算key与设置颜色
  for (var element in showList) {
    element.backgroundColor = ColorPool.hash(element.courseName);
    element.generateKey();
  }
  Map<String, List<TodayCourseView>> showListGroupByStudentId = {};
  for (var element in showList) {
    if (showListGroupByStudentId.containsKey(element.user.studentId)) {
      showListGroupByStudentId[element.user.studentId]!.add(element);
    } else {
      showListGroupByStudentId[element.user.studentId] = [element];
    }
  }
  showListGroupByStudentId.forEach((key, list) {
    var last = list.first;
    var lastKey = last.key;
    for (var index = 0; index < list.length; index++) {
      var todayCourseView = list[index];
      if (index == 0) {
        resultList.add(todayCourseView);
        continue;
      }
      var thisKey = todayCourseView.key;
      if (lastKey == thisKey) {
        if (last.endDayTime == todayCourseView.startDayTime - 1) {
          //合并两个课程
          last.endDayTime = todayCourseView.endDayTime;
        } else {
          //两个课程相同但是节次不连续，不合并
          resultList.add(todayCourseView);
          last = todayCourseView;
          lastKey = thisKey;
        }
      } else {
        resultList.add(todayCourseView);
        last = todayCourseView;
        lastKey = thisKey;
      }
    }
    if (resultList.last != last) {
      resultList.add(last);
    }
  });
  //最后按照开始节次排序
  var now = DateTime.now();
  resultList.sort((a, b) => a.startDayTime.compareTo(b.startDayTime));
  var todayCourseSheetList = <TodayCourseSheet>[];
  for (var element in resultList) {
    element.updateTime();
    var timeSet = <int>{};
    for (var i = element.startDayTime; i <= element.endDayTime; i++) {
      timeSet.add(i);
    }
    todayCourseSheetList.add(TodayCourseSheet(
        courseName: element.courseName,
        teacherName: element.teacher,
        timeSet: timeSet,
        startTime: DateTimeExt.localTime(element.startTime),
        endTime: DateTimeExt.localTime(element.endTime),
        timeString: element.courseDayTime,
        location: element.location,
        color: element.backgroundColor,
        showDate: showDate)
      ..calc(now));
  }
  return todayCourseSheetList;
}

class TodayCourseSheet {
  final String courseName;
  final String teacherName;
  final Set<int> timeSet;
  final DateTime startTime;
  final DateTime endTime;
  final String timeString;
  final String location;
  final Color color;
  final DateTime showDate;
  String courseStatus = "";

  TodayCourseSheet(
      {required this.courseName,
      required this.teacherName,
      required this.timeSet,
      required this.startTime,
      required this.endTime,
      required this.timeString,
      required this.location,
      required this.color,
      required this.showDate});

  void calc(DateTime now) {
    var sTime = startTime.atDate(showDate);
    var eTime = endTime.atDate(showDate);
    if (now.isBefore(sTime)) {
      courseStatus = "未开始";
    } else if (now.isAfter(eTime)) {
      courseStatus = "已结束";
    } else {
      courseStatus = "开课中";
    }
  }
}
