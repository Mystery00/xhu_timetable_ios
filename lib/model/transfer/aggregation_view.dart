import 'package:xhu_timetable_ios/model/transfer/today_course_view.dart';
import 'package:xhu_timetable_ios/model/transfer/today_thing_view.dart';
import 'package:xhu_timetable_ios/model/transfer/week_course_view.dart';

class AggregationView {
  final List<TodayCourseView> todayViewList;
  final List<TodayThingView> todayThingViewList;
  final List<WeekCourseView> weekViewList;
  final String? loadWarning;

  AggregationView({
    required this.todayViewList,
    required this.todayThingViewList,
    required this.weekViewList,
    required this.loadWarning,
  });
}
