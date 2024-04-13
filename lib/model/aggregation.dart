import 'package:xhu_timetable_ios/model/course.dart';

class AggregationMainResponse {
  final List<Course> courseList;
  final List<ExperimentCourse> experimentCourseList;
  final List<PracticalCourse> practicalCourseList;

  AggregationMainResponse(
      {required this.courseList,
      required this.experimentCourseList,
      required this.practicalCourseList});

  factory AggregationMainResponse.fromJson(Map<String, dynamic> json) {
    return AggregationMainResponse(
      courseList:
          json['courseList'].map<Course>((e) => Course.fromJson(e)).toList(),
      experimentCourseList: json['experimentCourseList']
          .map<ExperimentCourse>((e) => ExperimentCourse.fromJson(e))
          .toList(),
      practicalCourseList: json['practicalCourseList']
          .map<PracticalCourse>((e) => PracticalCourse.fromJson(e))
          .toList(),
    );
  }
}
