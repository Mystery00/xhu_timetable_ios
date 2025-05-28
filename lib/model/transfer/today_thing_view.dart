import 'dart:convert';
import 'dart:ui';

import 'package:xhu_timetable_ios/model/custom_thing.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

class TodayThingView {
  final String title;
  final String location;
  final bool allDay;
  final DateTime startTime;
  final DateTime endTime;
  final String remark;
  final Color color;
  final bool saveAsCountDown;
  final User user;

  TodayThingView({
    required this.title,
    required this.location,
    required this.allDay,
    required this.startTime,
    required this.endTime,
    required this.remark,
    required this.color,
    required this.saveAsCountDown,
    required this.user,
  });

  int getSort() {
    if (saveAsCountDown) {
      //倒计时优先
      return 0;
    }
    return startTime.millisecondsSinceEpoch;
  }

  bool showOnDay(DateTime showInstant) {
    if (endTime.isBefore(showInstant)) {
      //事项结束时间比需要显示的时间早，说明事件结束了
      return false;
    }
    if (saveAsCountDown) {
      //显示为倒计时，那么只要不结束就始终显示
      return true;
    }
    //只要是今天的事项就显示，在一天内不计算是否结束
    var startDate = startTime.atStartOfDay();
    var endDate = endTime.atStartOfDay();
    var showDate = showInstant.atStartOfDay();
    return !startDate.isAfter(showDate) && !endDate.isBefore(showDate);
  }

  factory TodayThingView.valueOf(CustomThingResponse thing, User user) {
    var metadataJson = json.decode(thing.metadata);
    var value = metadataJson['key_save_as_count_down'] ?? "false";
    var saveAsCountDown = bool.parse(value);
    return TodayThingView(
      title: thing.title,
      location: thing.location,
      allDay: thing.allDay,
      startTime: thing.startTime,
      endTime: thing.endTime,
      remark: thing.remark,
      color: thing.color,
      saveAsCountDown: saveAsCountDown,
      user: user,
    );
  }
}
