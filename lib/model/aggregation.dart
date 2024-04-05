import 'package:xhu_timetable_ios/model/course.dart';

class AggregationMainResponse {
  final List<Course> courseList;
  final List<ExperimentCourse> experimentCourseList;

  AggregationMainResponse(
      {required this.courseList, required this.experimentCourseList});

  factory AggregationMainResponse.fromJson(Map<String, dynamic> json) {
    return AggregationMainResponse(
      courseList:
          json['courseList'].map<Course>((e) => Course.fromJson(e)).toList(),
      experimentCourseList: json['experimentCourseList']
          .map<ExperimentCourse>((e) => ExperimentCourse.fromJson(e))
          .toList(),
    );
  }
}
