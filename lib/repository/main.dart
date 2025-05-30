import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/transfer/aggregation_view.dart';
import 'package:xhu_timetable_ios/model/transfer/today_course_view.dart';
import 'package:xhu_timetable_ios/model/transfer/today_thing_view.dart';
import 'package:xhu_timetable_ios/model/transfer/week_course_view.dart';
import 'package:xhu_timetable_ios/repository/aggregation.dart';
import 'package:xhu_timetable_ios/repository/course_color.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

AggregationRepo _aggregationRepo = AggregationRepo();

Future<(AggregationView, String)> getMainPageData(
  bool forceLoadFromCloud,
  bool forceLoadFromLocal,
) async {
  var showCustomCourse = false;
  var showCustomThing = await getShowCustomThing();
  var view = await _aggregationRepo.fetchAggregationMainPage(forceLoadFromCloud,
      forceLoadFromLocal, showCustomCourse, showCustomThing);
  if (view.loadWarning?.isNotEmpty ?? false) {
    return (view, view.loadWarning!);
  }
  return (view, "");
}

Future<List<TodayCourseSheet>> getTodayCourseSheetList(
  int currentWeek,
  List<TodayCourseView> courseList,
) async {
  if (courseList.isEmpty) {
    return [];
  }
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
  var courseColorMap = await getCourseColorList();
  for (var element in showList) {
    element.backgroundColor = courseColorMap[element.courseName] ??
        ColorPool.hash(element.courseName);
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
  var multiAccountMode = await getMultiAccountMode();
  var customAccountTitle = await getCustomAccountTitle();
  var showStatus = await getShowStatus();
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
    var sheet = TodayCourseSheet(
      courseName: element.courseName,
      teacherName: element.teacher,
      timeSet: timeSet,
      startTime: DateTimeExt.localTime(element.startTime),
      endTime: DateTimeExt.localTime(element.endTime),
      timeString: element.courseDayTime,
      location: element.location,
      color: element.backgroundColor,
      showDate: showDate,
      accountTitle: multiAccountMode
          ? customAccountTitle.formatToday(element.user.userInfo)
          : "",
    );
    if (showStatus) {
      sheet.calc(now);
    }
    todayCourseSheetList.add(sheet);
  }
  return todayCourseSheetList;
}

Future<List<TodayThingSheet>> getTodayThingSheetList(
    List<TodayThingView> thingList) async {
  var multiAccountMode = await getMultiAccountMode();
  var customAccountTitle = await getCustomAccountTitle();
  var showInstant = DateTime.now();
  //过滤出今日或者明日的事项
  var showList =
      thingList.where((element) => element.showOnDay(showInstant)).toList();
  if (showList.isEmpty) {
    return [];
  }
  showList.sort((a, b) => a.getSort().compareTo(b.getSort()));
  var resultList = <TodayThingSheet>[];
  for (var element in showList) {
    var timeTextBuilder = StringBuffer();
    if (element.allDay) {
      timeTextBuilder.write(element.startTime.formatChinaDate());
    } else {
      timeTextBuilder.write(element.startTime.formatChinaDateTime());
    }
    if (!element.saveAsCountDown) {
      timeTextBuilder.write(" - ");
      if (element.allDay) {
        timeTextBuilder.write(element.endTime.formatChinaDate());
      } else {
        timeTextBuilder.write(element.endTime.formatChinaDateTime());
      }
    }
    var showInstantStartDay = showInstant.atStartOfDay();
    var remainDays = element.startTime.difference(showInstantStartDay).inDays;
    resultList.add(TodayThingSheet(
      title: element.title,
      location: element.location,
      allDay: element.allDay,
      timeText: timeTextBuilder.toString(),
      remark: element.remark,
      color: element.color,
      saveAsCountDown: element.saveAsCountDown,
      remainDays: remainDays,
      accountTitle: multiAccountMode
          ? customAccountTitle.formatToday(element.user.userInfo)
          : "",
    ));
  }
  return resultList;
}

Future<List<List<WeekCourseSheet>>> getWeekCourseSheetList(
  int currentWeek,
  int showWeek,
  List<WeekCourseView> courseList,
) async {
  if (courseList.isEmpty) {
    return List.generate(7, (_) => []);
  }
  //设置是否本周以及课程颜色
  var courseColorMap = await getCourseColorList();
  for (var element in courseList) {
    element.thisWeek = element.weekList.contains(showWeek);
    element.backgroundColor = courseColorMap[element.courseName] ??
        ColorPool.hash(element.courseName);
    element.generateKey();
  }
  //过滤非本周课程
  var showNotThisWeek = await getShowNotThisWeek();
  if (!showNotThisWeek) {
    courseList.removeWhere((element) => !element.thisWeek);
  }
  //多账号模式检测
  var multiAccountMode = await getMultiAccountMode();
  if (!multiAccountMode) {
    for (var element in courseList) {
      element.accountTitle = "";
    }
  }
  //组建表格数据
  List<List<WeekCourseSheet>> expandTableCourse = List.generate(
      7,
      (day) => List.generate(
          11, (index) => WeekCourseSheet.empty(1, index + 1, day + 1)));
  //平铺课程
  for (var course in courseList) {
    var day = course.dayIndex - 1;
    for (var i = course.startDayTime; i <= course.endDayTime; i++) {
      expandTableCourse[day][i - 1].course.add(course);
    }
  }
  //使用key判断格子内容是否相同，相同则合并
  var tableCourse = List.generate(7, (day) {
    var dayArray = expandTableCourse[day];
    var first = dayArray.first;
    var result = <WeekCourseSheet>[];
    var last = first;
    var lastList = first.course;
    lastList.sort((a, b) => a.key.compareTo(b.key));
    var lastKey = lastList.map((e) => e.key).join();
    for (var index = 0; index < dayArray.length; index++) {
      if (index == 0) {
        continue;
      }
      var courseSheet = dayArray[index];

      var thisList = courseSheet.course;
      thisList.sort((a, b) => a.key.compareTo(b.key));
      var thisKey = thisList.map((e) => e.key).join();
      if (lastKey == thisKey) {
        last.step++;
      } else {
        result.add(last);
        last = courseSheet;
        lastKey = thisKey;
      }
    }
    if (result.lastOrNull != last) {
      result.add(last);
    }
    return result;
  });
  //处理显示的信息
  for (var array in tableCourse) {
    for (var sheet in array) {
      if (sheet.course.isNotEmpty) {
        sheet.course.sort((a, b) {
          if (a.thisWeek != b.thisWeek) {
            if (a.thisWeek && !b.thisWeek) {
              return -1;
            }
            if (!a.thisWeek && b.thisWeek) {
              return 1;
            }
            return 0;
          }
          return a.weekList.first.compareTo(b.weekList.first);
        });
      } else {
        continue;
      }
      var show = sheet.course.first;
      sheet.course.sort((a, b) => a.weekList.first.compareTo(b.weekList.first));
      if (show.thisWeek) {
        sheet.showTitle = "${show.courseName}\n@${show.location}";
        sheet.color =
            courseColorMap[show.courseName] ?? ColorPool.hash(show.courseName);
        sheet.textColor = Colors.white;
      } else {
        sheet.showTitle = "[非本周]\n${show.courseName}\n@${show.location}";
        sheet.color = const Color(0xFFe5e5e5);
        sheet.textColor = Colors.grey;
      }
    }
  }
  return tableCourse;
}

class WeekCourseSheet {
  String showTitle;
  int step;
  final int startIndex;
  final int day;
  List<WeekCourseView> course;
  Color color;
  Color textColor;

  WeekCourseSheet({
    required this.showTitle,
    required this.step,
    required this.startIndex,
    required this.day,
    required this.course,
    required this.color,
    required this.textColor,
  });

  factory WeekCourseSheet.empty(int step, int startIndex, int day) {
    return WeekCourseSheet(
      showTitle: "",
      step: step,
      startIndex: startIndex,
      day: day,
      course: [],
      color: Colors.transparent,
      textColor: Colors.transparent,
    );
  }

  bool isEmpty() => course.isEmpty;
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
  String accountTitle = "";
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
      required this.showDate,
      this.accountTitle = ""});

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

class TodayThingSheet {
  final String title;
  final String location;
  final bool allDay;
  final String timeText;
  final String remark;
  final Color color;
  final bool saveAsCountDown;
  final int remainDays;
  final String accountTitle;

  TodayThingSheet(
      {required this.title,
      required this.location,
      required this.allDay,
      required this.timeText,
      required this.remark,
      required this.color,
      required this.saveAsCountDown,
      required this.remainDays,
      required this.accountTitle});
}
