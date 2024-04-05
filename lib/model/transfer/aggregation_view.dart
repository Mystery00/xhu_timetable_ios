import 'package:xhu_timetable_ios/model/transfer/today_course_view.dart';

class AggregationView {
  final List<TodayCourseView> todayViewList;
  final String? loadWarning;

  AggregationView({required this.todayViewList, required this.loadWarning});
}
