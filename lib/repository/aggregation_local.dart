import 'package:xhu_timetable_ios/db/database.dart';
import 'package:xhu_timetable_ios/db/entity/course.dart';
import 'package:xhu_timetable_ios/db/entity/custom_thing.dart';
import 'package:xhu_timetable_ios/db/entity/experiment_course.dart';
import 'package:xhu_timetable_ios/db/entity/practical_course.dart';
import 'package:xhu_timetable_ios/model/aggregation.dart';
import 'package:xhu_timetable_ios/model/course.dart';
import 'package:xhu_timetable_ios/model/custom_thing.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';

class AggregationLocalRepo {
  static Future<void> saveAggregationMainPageResponse(
    int year,
    int term,
    User user,
    AggregationMainResponse response,
    bool containCustomThing,
  ) async {
    var db = await DataBaseManager.database();
    //删除旧数据
    await db.courseDao.deleteOld(year, term, user.studentId);
    await db.practicalCourseDao.deleteOld(year, term, user.studentId);
    await db.experimentCourseDao.deleteOld(year, term, user.studentId);

    //插入新数据
    for (var course in response.courseList) {
      CourseEntity courseEntity = CourseEntity(
          courseName: course.courseName,
          weekStr: course.weekStr,
          weekList: course.weekList.join(','),
          dayIndex: course.dayIndex,
          startDayTime: course.startDayTime,
          endDayTime: course.endDayTime,
          startTime: course.startTime,
          endTime: course.endTime,
          location: course.location,
          teacher: course.teacher,
          extraData: course.extraData.join(','),
          campus: course.campus,
          courseType: course.courseType,
          credit: course.credit,
          courseCodeType: course.courseCodeType,
          courseCodeFlag: course.courseCodeFlag,
          year: year,
          term: term,
          studentId: user.studentId);
      await db.courseDao.insertData(courseEntity);
    }
    for (var practicalCourse in response.practicalCourseList) {
      PracticalCourseEntity practicalCourseEntity = PracticalCourseEntity(
          courseName: practicalCourse.courseName,
          weekStr: practicalCourse.weekStr,
          weekList: practicalCourse.weekList.join(','),
          teacher: practicalCourse.teacher,
          campus: practicalCourse.campus,
          credit: practicalCourse.credit,
          year: year,
          term: term,
          studentId: user.studentId);
      await db.practicalCourseDao.insertData(practicalCourseEntity);
    }
    for (var experimentCourse in response.experimentCourseList) {
      ExperimentCourseEntity experimentCourseEntity = ExperimentCourseEntity(
          courseName: experimentCourse.courseName,
          experimentProjectName: experimentCourse.experimentProjectName,
          teacherName: experimentCourse.teacherName,
          experimentGroupName: experimentCourse.experimentGroupName,
          weekStr: experimentCourse.weekStr,
          weekList: experimentCourse.weekList.join(','),
          dayIndex: experimentCourse.dayIndex,
          startDayTime: experimentCourse.startDayTime,
          endDayTime: experimentCourse.endDayTime,
          startTime: experimentCourse.startTime,
          endTime: experimentCourse.endTime,
          region: experimentCourse.region,
          location: experimentCourse.location,
          year: year,
          term: term,
          studentId: user.studentId);
      await db.experimentCourseDao.insertData(experimentCourseEntity);
    }
    for (var customThing in response.customThingList) {
      CustomThingEntity customThingEntity = CustomThingEntity(
          thingId: customThing.thingId,
          title: customThing.title,
          location: customThing.location,
          allDay: customThing.allDay,
          startTime: customThing.startTime.millisecondsSinceEpoch,
          endTime: customThing.endTime.millisecondsSinceEpoch,
          remark: customThing.remark,
          color: customThing.color.toHex(),
          metadata: customThing.metadata,
          createTime: customThing.createTime.millisecondsSinceEpoch,
          studentId: user.studentId);
      await db.customThingDao.insertData(customThingEntity);
    }
  }

  static Future<void> queryAndMap<T, R>(
    List<R> list,
    Function query,
    Function dataMap,
  ) async {
    List<T> data = await query();
    for (var item in data) {
      list.add(dataMap(item));
    }
  }

  static Future<AggregationMainResponse> fetchAggregationMainPage(
      int nowYear, int nowTerm, User user) async {
    var db = await DataBaseManager.database();

    List<Course> courseList = [];
    List<PracticalCourse> practicalCourseList = [];
    List<ExperimentCourse> experimentCourseList = [];
    List<CustomThingResponse> customThingList = [];

    await queryAndMap<CourseEntity, Course>(
      courseList,
      () => db.courseDao.queryCourse(nowYear, nowTerm, user.studentId),
      (item) {
        CourseEntity entity = item as CourseEntity;
        return Course(
          courseName: entity.courseName,
          weekStr: entity.weekStr,
          weekList:
              entity.weekList.split(',').map((e) => int.parse(e)).toList(),
          dayIndex: entity.dayIndex,
          startDayTime: entity.startDayTime,
          endDayTime: entity.endDayTime,
          startTime: entity.startTime,
          endTime: entity.endTime,
          location: entity.location,
          teacher: entity.teacher,
          extraData: entity.extraData.split(','),
          campus: entity.campus,
          courseType: entity.courseType,
          credit: entity.credit,
          courseCodeType: entity.courseCodeType,
          courseCodeFlag: entity.courseCodeFlag,
        );
      },
    );
    await queryAndMap<PracticalCourseEntity, PracticalCourse>(
      practicalCourseList,
      () => db.practicalCourseDao
          .queryPracticalCourse(nowYear, nowTerm, user.studentId),
      (item) {
        PracticalCourseEntity entity = item as PracticalCourseEntity;
        return PracticalCourse(
          courseName: entity.courseName,
          weekStr: entity.weekStr,
          weekList:
              entity.weekList.split(',').map((e) => int.parse(e)).toList(),
          teacher: entity.teacher,
          campus: entity.campus,
          credit: entity.credit,
        );
      },
    );
    await queryAndMap<ExperimentCourseEntity, ExperimentCourse>(
      experimentCourseList,
      () => db.experimentCourseDao
          .queryExperimentCourse(nowYear, nowTerm, user.studentId),
      (item) {
        ExperimentCourseEntity entity = item as ExperimentCourseEntity;
        return ExperimentCourse(
          courseName: entity.courseName,
          experimentProjectName: entity.experimentProjectName,
          teacherName: entity.teacherName,
          experimentGroupName: entity.experimentGroupName,
          weekStr: entity.weekStr,
          weekList:
              entity.weekList.split(',').map((e) => int.parse(e)).toList(),
          dayIndex: entity.dayIndex,
          startDayTime: entity.startDayTime,
          endDayTime: entity.endDayTime,
          startTime: entity.startTime,
          endTime: entity.endTime,
          region: entity.region,
          location: entity.location,
        );
      },
    );
    await queryAndMap<CustomThingEntity, CustomThingResponse>(customThingList,
        () => db.customThingDao.queryByUsername(user.studentId), (item) {
      CustomThingEntity entity = item as CustomThingEntity;
      return CustomThingResponse(
        thingId: entity.thingId,
        title: entity.title,
        location: entity.location,
        allDay: entity.allDay,
        startTime: DateTime.fromMillisecondsSinceEpoch(entity.startTime),
        endTime: DateTime.fromMillisecondsSinceEpoch(entity.endTime),
        remark: entity.remark,
        color: HexColor.fromHex(entity.color),
        metadata: entity.metadata,
        createTime: DateTime.fromMillisecondsSinceEpoch(entity.createTime),
      );
    });
    return AggregationMainResponse(
      courseList: courseList,
      practicalCourseList: practicalCourseList,
      experimentCourseList: experimentCourseList,
      customThingList: customThingList,
    );
  }
}
