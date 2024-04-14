import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/course.dart';
import 'package:xhu_timetable_ios/model/user.dart';

class TodayCourseView {
  final String courseName;
  final List<int> weekList;
  final int dayIndex;
  final int startDayTime;
  int endDayTime;
  final String startTime;
  final String endTime;
  final String location;
  final String teacher;
  final User user;

  String courseDayTime = "";
  Color backgroundColor = Colors.white;
  String key = "";

  TodayCourseView({
    required this.courseName,
    required this.weekList,
    required this.dayIndex,
    required this.startDayTime,
    required this.endDayTime,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.teacher,
    required this.user,
  });

  void generateKey() {
    key = "$courseName!$teacher!$location!$weekList!$dayIndex";
  }

  void updateTime() {
    if (startDayTime == endDayTime) {
      courseDayTime = "第$startDayTime";
    } else {
      courseDayTime = "$startDayTime-$endDayTime节";
    }
  }

  factory TodayCourseView.valueOfCourse(Course course, User user) =>
      TodayCourseView(
        courseName: course.courseName,
        weekList: course.weekList,
        dayIndex: course.dayIndex,
        startDayTime: course.startDayTime,
        endDayTime: course.endDayTime,
        startTime: course.startTime,
        endTime: course.endTime,
        location: course.location,
        teacher: course.teacher,
        user: user,
      );

  factory TodayCourseView.valueOfExperimentCourse(
          ExperimentCourse experimentCourse, User user) =>
      TodayCourseView(
        courseName: experimentCourse.experimentProjectName,
        weekList: experimentCourse.weekList,
        dayIndex: experimentCourse.dayIndex,
        startDayTime: experimentCourse.startDayTime,
        endDayTime: experimentCourse.endDayTime,
        startTime: experimentCourse.startTime,
        endTime: experimentCourse.endTime,
        location: experimentCourse.location,
        teacher: experimentCourse.teacherName,
        user: user,
      );
}
