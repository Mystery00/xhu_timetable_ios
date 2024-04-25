import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
        Expanded(
            child: SingleChildScrollView(
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
                      child: Column(
                        children: [
                          for (var sheet in widget.weekCourseSheetList[i])
                            _buildWeekItem(
                                sheet.color,
                                sheet.step,
                                sheet.showTitle,
                                sheet.textColor,
                                sheet.course.length > 1, () {
                              _handleCourseItemTap(sheet);
                            }),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
        )),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCourseItemTap(WeekCourseSheet sheet) {
    showMaterialModalBottomSheet(
        context: context,
        shape: ShapeBorder.lerp(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            0),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        duration: const Duration(milliseconds: 300),
        builder: (context) {
          return Container(
            constraints: const BoxConstraints(
              maxHeight: 576,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "共${sheet.course.length}节课",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    for (var course in sheet.course)
                      Container(
                        decoration: BoxDecoration(
                          color: course.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(4),
                        width: double.infinity,
                        child: Column(
                          children: [
                            SelectableText(
                              course.courseName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SelectableText(
                              course.teacher,
                              style: const TextStyle(color: Colors.white),
                            ),
                            SelectableText(
                              course.location,
                              style: const TextStyle(color: Colors.white),
                            ),
                            SelectableText(
                              course.weekStr,
                              style: const TextStyle(color: Colors.white),
                            ),
                            SelectableText(
                              course.courseTime,
                              style: const TextStyle(color: Colors.white),
                            ),
                            if (course.extraData.isNotEmpty)
                              for (var element in course.extraData)
                                if (element.isNotEmpty)
                                  SelectableText(element,
                                      style:
                                          const TextStyle(color: Colors.white)),
                            Container(
                              decoration: BoxDecoration(
                                color: course.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                course.accountTitle,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontSize: 12,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildWeekItem(
    Color backgroundColor,
    int itemStep,
    String title,
    Color textColor,
    bool showMore,
    VoidCallback onClick,
  ) {
    return SizedBox(
      height: (itemHeight * itemStep).toDouble(),
      child: InkWell(
        onTap: showMore ? onClick : null,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.all(1),
                color: backgroundColor.withOpacity(0.8),
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (showMore)
              const Positioned(
                bottom: 0,
                right: 0,
                child: Image(
                  width: 6,
                  height: 6,
                  image: Svg("assets/icons/svg/ic_radius_cell.svg"),
                ),
              ),
          ],
        ),
      ),
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
                fontSize: 11,
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
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
