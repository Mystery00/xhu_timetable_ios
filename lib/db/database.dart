import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:xhu_timetable_ios/db/dao/course.dart';
import 'package:xhu_timetable_ios/db/dao/experiment_course.dart';
import 'package:xhu_timetable_ios/db/dao/practical_course.dart';
import 'package:xhu_timetable_ios/db/entity/course.dart';
import 'package:xhu_timetable_ios/db/entity/experiment_course.dart';
import 'package:xhu_timetable_ios/db/entity/practical_course.dart';

part 'database.g.dart';

@Database(
    version: 1,
    entities: [CourseEntity, PracticalCourseEntity, ExperimentCourseEntity])
abstract class AppDatabase extends FloorDatabase {
  CourseDao get courseDao;
  PracticalCourseDao get practicalCourseDao;
  ExperimentCourseDao get experimentCourseDao;
}

class DataBaseManager {
  static Future<AppDatabase> database() async {
    return await $FloorAppDatabase.databaseBuilder('app.db').build();
  }
}
