import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/course.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

class WeekCourseView {
  final String courseName;
  final String weekStr;
  final List<int> weekList;
  final int dayIndex;
  final int startDayTime;
  final int endDayTime;
  final DateTime startTime;
  final DateTime endTime;
  final String courseDayTime;
  final String courseTime;
  final String location;
  final String teacher;
  final List<String> extraData;
  final String accountTitle;
  bool thisWeek = false;
  Color backgroundColor = Colors.transparent;
  String key = "";

  WeekCourseView({
    required this.courseName,
    required this.weekStr,
    required this.weekList,
    required this.dayIndex,
    required this.startDayTime,
    required this.endDayTime,
    required this.startTime,
    required this.endTime,
    required this.courseDayTime,
    required this.courseTime,
    required this.location,
    required this.teacher,
    required this.extraData,
    required this.accountTitle,
  });

  void generateKey() {
    key = "$courseName!$teacher!$location!$weekStr!$courseDayTime!$dayIndex";
  }

  factory WeekCourseView.valueOfCourse(Course course, String accountTitle) {
    var courseDayTime = "${course.startDayTime}-${course.endDayTime}节";
    if (course.startDayTime == course.endDayTime) {
      courseDayTime = "第${course.startDayTime}节";
    }
    var courseTime = "${course.startTime} - ${course.endTime}";
    return WeekCourseView(
      courseName: course.courseName,
      weekStr: course.weekStr,
      weekList: course.weekList,
      dayIndex: course.dayIndex,
      startDayTime: course.startDayTime,
      endDayTime: course.endDayTime,
      startTime: DateTimeExt.localTime(course.startTime),
      endTime: DateTimeExt.localTime(course.endTime),
      courseDayTime: courseDayTime,
      courseTime: courseTime,
      location: course.location,
      teacher: course.teacher,
      extraData: course.extraData,
      accountTitle: accountTitle,
    );
  }

  factory WeekCourseView.valueOfExperimentCourse(
      ExperimentCourse experimentCourse, String accountTitle) {
    var courseDayTime =
        "${experimentCourse.startDayTime}-${experimentCourse.endDayTime}节";
    if (experimentCourse.startDayTime == experimentCourse.endDayTime) {
      courseDayTime = "第${experimentCourse.startDayTime}节";
    }
    var courseTime =
        "${experimentCourse.startTime} - ${experimentCourse.endTime}";
    var extraData = <String>[];
    if (experimentCourse.experimentGroupName.isNotEmpty) {
      extraData.add("实验分组：${experimentCourse.experimentGroupName}");
    }
    return WeekCourseView(
      courseName: experimentCourse.courseName,
      weekStr: experimentCourse.weekStr,
      weekList: experimentCourse.weekList,
      dayIndex: experimentCourse.dayIndex,
      startDayTime: experimentCourse.startDayTime,
      endDayTime: experimentCourse.endDayTime,
      startTime: DateTimeExt.localTime(experimentCourse.startTime),
      endTime: DateTimeExt.localTime(experimentCourse.endTime),
      courseDayTime: courseDayTime,
      courseTime: courseTime,
      location: experimentCourse.location,
      teacher: experimentCourse.teacherName,
      extraData: extraData,
      accountTitle: accountTitle,
    );
  }
}
