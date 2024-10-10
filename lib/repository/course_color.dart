import 'dart:ui';

import 'package:xhu_timetable_ios/db/database.dart';
import 'package:xhu_timetable_ios/db/entity/course_color.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

Future<Map<String, Color>> getCourseColorList() async {
  var db = await DataBaseManager.database();
  Map<String, Color> courseColorMap = {};
  await db.courseColorDao
      .queryAllCourseColor()
      .then((List<CourseColorEntity> list) {
    for (var item in list) {
      courseColorMap[item.courseName] = HexColor.fromHex(item.color);
    }
  });
  return courseColorMap;
}

Future<Map<String, Color>> loadAllCourseColor() async {
  var db = await DataBaseManager.database();
  Map<String, Color> courseColorMap = {};
  await db.courseDao.queryAllCourseName().then((List<String> list) {
    for (var item in list) {
      courseColorMap[item] = ColorPool.hash(item);
    }
  });
  await db.practicalCourseDao.queryAllCourseName().then((List<String> list) {
    for (var item in list) {
      courseColorMap[item] = ColorPool.hash(item);
    }
  });
  await db.experimentCourseDao.queryAllCourseName().then((List<String> list) {
    for (var item in list) {
      courseColorMap[item] = ColorPool.hash(item);
    }
  });
  await getCourseColorList().then((value) {
    courseColorMap.addAll(value);
  });
  return courseColorMap;
}

Future<void> saveCourseColor(String courseName, Color color) async {
  var db = await DataBaseManager.database();
  var saved = await db.courseColorDao.queryCourseColor(courseName);
  if (saved == null) {
    await db.courseColorDao.insertData(
        CourseColorEntity(courseName: courseName, color: color.toHex()));
  } else {
    await db.courseColorDao.deleteData(saved);
    await db.courseColorDao.insertData(
        CourseColorEntity(courseName: courseName, color: color.toHex()));
  }
}

Future<void> deleteCourseColor(String courseName) async {
  var db = await DataBaseManager.database();
  var saved = await db.courseColorDao.queryCourseColor(courseName);
  if (saved != null) {
    await db.courseColorDao.deleteData(saved);
  }
}
