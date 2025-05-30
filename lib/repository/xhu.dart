import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';

class XhuRepo {
  static Future<int> calculateWeek({DateTime? date}) async {
    date ??= DateTime.now();
    var dateStart = date.atStartOfDay();
    var termStartDate = await getTermStartDate();
    var days = dateStart.difference(termStartDate).inDays;
    if (days < 0) {
      return 0;
    }
    int week = ((days / 7) + 1).toInt();
    if (week > 20) {
      return 21;
    }
    return week;
  }

  static Future<String> calculateTodayTitle(bool showTomorrow) async {
    var termStartDate = await getTermStartDate();
    var now = DateTime.now().atStartOfDay();
    var todayWeekIndex = now.getDayOfWeek();
    if (now.isBefore(termStartDate)) {
      var remainDays = now.difference(termStartDate).inDays.abs();
      return "距离开学还有$remainDays天 $todayWeekIndex";
    }
    var date = showTomorrow ? now.add(const Duration(days: 1)) : now;
    var days = date.difference(termStartDate).inDays;
    var weekIndex = date.getDayOfWeek();
    var week = ((days / 7) + 1).toInt();
    if (week > 20) {
      return "本学期已结束";
    } else {
      return "第$week周 $weekIndex";
    }
  }

  static String calculateWeekTitle(int initWeek) {
    if (initWeek < 1) {
      return "还没开学呢～";
    } else if (initWeek > 20) {
      return "本学期已结束";
    } else {
      return "第$initWeek周";
    }
  }

  static Future<DateTime> calculateWeekStartDay(int initWeek) async {
    var termStartDate = await getTermStartDate();
    if (initWeek < 1) {
      return termStartDate;
    } else if (initWeek > 20) {
      var now = DateTime.now().atStartOfDay();
      while (now.weekday != DateTime.monday) {
        now = now.subtract(const Duration(days: 1));
      }
      return now;
    } else {
      return termStartDate.add(Duration(days: 7 * (initWeek - 1)));
    }
  }
}

extension DateTimeExt on DateTime {
  static DateTime localTime(String timeStr) {
    var time = timeStr.split(":");
    return DateTime.now().atStartOfDay().add(Duration(
          hours: int.parse(time[0]),
          minutes: int.parse(time[1]),
          seconds: int.parse(time[2]),
        ));
  }

  static DateTime localTimeNoSeconds(String timeStr) {
    var time = timeStr.split(":");
    return DateTime.now().atStartOfDay().add(Duration(
          hours: int.parse(time[0]),
          minutes: int.parse(time[1]),
          seconds: 0,
        ));
  }

  static DateTime localDate(String dateStr) {
    var date = dateStr.split("-");
    return DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))
        .atStartOfDay();
  }

  static DateTime instant(dynamic instant) {
    if (instant is int) {
      return DateTime.fromMillisecondsSinceEpoch(instant);
    } else if (instant is String) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(instant));
    } else {
      throw ArgumentError("instant must be int or String");
    }
  }

  DateTime atStartOfDay() => DateTime(year, month, day);

  DateTime atHourStart() => DateTime(year, month, day, hour);

  TimeOfDay toTimeOfDay() => TimeOfDay.fromDateTime(this);

  DateTime atDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute, second);
  }

  DateTime atTime(TimeOfDay time){
    return DateTime(year, month, day, time.hour, time.minute, second);
  }

  String getDayOfWeek() {
    switch (weekday) {
      case 1:
        return "周一";
      case 2:
        return "周二";
      case 3:
        return "周三";
      case 4:
        return "周四";
      case 5:
        return "周五";
      case 6:
        return "周六";
      case 7:
        return "周日";
      default:
        return "";
    }
  }

  String formatTimeNoSecond() =>
      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

  String formatDate() =>
      "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  String formatChinaDate() =>
      "$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日";

  String formatChinaDateTime() =>
      "$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日 ${hour.toString().padLeft(2, '0')}时${minute.toString().padLeft(2, '0')}分${second.toString().padLeft(2, '0')}秒";

  String formatThingDateTime() =>
      "$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日 ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

  bool isToday() {
    var now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

extension TimeOfDayExt on TimeOfDay {
  String formatTime() =>
      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}
