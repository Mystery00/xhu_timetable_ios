import 'dart:ui';

import 'package:xhu_timetable_ios/model/entity/course.dart';
import 'package:xhu_timetable_ios/model/entity/experiment_course.dart';
import 'package:xhu_timetable_ios/model/entity/practical_course.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

Future<Map<String, Color>> getCourseColorList() async {
  return {};
}

Future<Map<String, Color>> loadAllCourseColor() async {
  // var db = database();
  // Map<String, Color> courseColorMap = {};
  // await db
  //     .query(
  //       tableCourse,
  //       columns: ['courseName'],
  //       distinct: true,
  //     )
  //     .then((value) => value.map((e) => CourseEntity.fromMap(e)).toList())
  //     .then((List<CourseEntity> list) {
  //   for (var item in list) {
  //     courseColorMap[item.courseName] = ColorPool.hash(item.courseName);
  //   }
  // });
  // await db
  //     .query(
  //       tablePracticalCourse,
  //       columns: ['courseName'],
  //       distinct: true,
  //     )
  //     .then((value) =>
  //         value.map((e) => PracticalCourseEntity.fromMap(e)).toList())
  //     .then((List<PracticalCourseEntity> list) {
  //   for (var item in list) {
  //     courseColorMap[item.courseName] = ColorPool.hash(item.courseName);
  //   }
  // });
  // await db
  //     .query(
  //       tableExperimentCourse,
  //       columns: ['courseName'],
  //       distinct: true,
  //     )
  //     .then((value) =>
  //         value.map((e) => ExperimentCourseEntity.fromMap(e)).toList())
  //     .then((List<ExperimentCourseEntity> list) {
  //   for (var item in list) {
  //     courseColorMap[item.courseName] = ColorPool.hash(item.courseName);
  //   }
  // });
  // await getCourseColorList().then((value) {
  //   courseColorMap.addAll(value);
  // });
  // return courseColorMap;
  return {};
}
