import 'package:xhu_timetable_ios/model/course.dart';
import 'package:xhu_timetable_ios/model/custom_thing.dart';

class AggregationMainResponse {
  final List<Course> courseList;
  final List<ExperimentCourse> experimentCourseList;
  final List<PracticalCourse> practicalCourseList;
  final List<CustomThingResponse> customThingList;

  AggregationMainResponse({
    required this.courseList,
    required this.experimentCourseList,
    required this.practicalCourseList,
    required this.customThingList,
  });

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
      customThingList: json['customThingList']
          .map<CustomThingResponse>((e) => CustomThingResponse.fromJson(e))
          .toList(),
    );
  }
}
