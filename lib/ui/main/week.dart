import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xhu_timetable_ios/repository/main.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';

class WeekHomePage extends StatefulWidget {
  final DateTime weekDateStart;
  final List<List<WeekCourseSheet>> weekCourseSheetList;

  const WeekHomePage({
    super.key,
    required this.weekDateStart,
    required this.weekCourseSheetList,
  });

  @override
  State<WeekHomePage> createState() => _WeekHomePageState();
}

const _dateBackgroundColor = Color(0x2E000000);
const itemHeight = 72;

class _WeekHomePageState extends State<WeekHomePage> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: _dateBackgroundColor,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "${widget.weekDateStart.month}\n月",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              for (var i = 0; i < 7; i++)
                _buildDateItem(widget.weekDateStart.add(Duration(days: i))),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _controller,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: _dateBackgroundColor,
                      child: Column(
                        children: [
                          for (var i = 0; i < 11; i++)
                            _buildTimeItem(i + 1, itemHeight),
                        ],
                      ),
                    ),
                  ),
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      flex: 10,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: itemHeight * 11.toDouble(),
                          child: Column(
                            children: [
                              for (var sheet in widget.weekCourseSheetList[i])
                                _buildWeekItem(
                                    sheet.color,
                                    sheet.step,
                                    sheet.showTitle,
                                    sheet.textColor,
                                    sheet.course.length > 1, () {
                                  //TODO: 点击事件
                                }),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWeekItem(
    Color backgroundColor,
    int itemStep,
    String title,
    Color textColor,
    bool showMore,
    VoidCallback onClick,
  ) {
    return Stack(
      children: [
        Container(
          height: (itemHeight * itemStep).toDouble(),
          margin: const EdgeInsets.all(1),
          color: backgroundColor.withOpacity(0.8),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(DateTime dateTime) {
    var dateStr = "${dateTime.day.toString().padLeft(2, '0')}日";
    if (dateTime.day == 1) {
      dateStr = "${dateTime.month}月";
    }
    return Expanded(
      flex: 10,
      child: Container(
        color:
            dateTime.isToday() ? const Color(0x80000000) : Colors.transparent,
        child: Column(
          children: [
            Text(
              "${dateTime.getDayOfWeek()}\n$dateStr",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(int time, int itemHeight) {
    return SizedBox(
      height: itemHeight.toDouble(),
      child: Center(
        child: Text(
          time.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
