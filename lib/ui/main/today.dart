import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xhu_timetable_ios/model/poems.dart';
import 'package:xhu_timetable_ios/repository/main.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';
import 'package:xhu_timetable_ios/ui/theme/icons.dart';

class TodayHomePage extends StatefulWidget {
  final Poems? poems;
  final List<TodayCourseSheet> todayCourseSheetList;

  const TodayHomePage(
      {super.key, this.poems, required this.todayCourseSheetList});

  @override
  State<StatefulWidget> createState() => _TodayHomePageState();
}

class _TodayHomePageState extends State<TodayHomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 1,
            height: double.infinity,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemCount: widget.todayCourseSheetList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _PoemsItem(
                  poems: widget.poems,
                );
              }
              return _buildTodayCourseContent(
                  context, widget.todayCourseSheetList[index - 1]);
            },
          ),
        )
      ],
    );
  }
}

class _PoemsItem extends StatefulWidget {
  final Poems? poems;

  const _PoemsItem({this.poems});

  @override
  State<StatefulWidget> createState() => _PoemsItemState();
}

class _PoemsItemState extends State<_PoemsItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.poems == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ColorPool.hash(widget.poems!.content),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _showPoemsDetail(context, widget.poems!);
              },
              child: Card(
                margin: const EdgeInsets.only(right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          widget.poems!.content,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "—— ${widget.poems!.author}《${widget.poems!.title}》",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void _showPoemsDetail(BuildContext context, Poems poems) {
  showMaterialModalBottomSheet(
      context: context,
      shape: ShapeBorder.lerp(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          0),
      duration: const Duration(milliseconds: 200),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 32, left: 32, right: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SelectableText(
                  "《${poems.title}》",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: SelectableText(
                  "[${poems.dynasty}] ${poems.author}",
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: SelectableText(
                  poems.fullContent.join("\n"),
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              if (poems.translate != null && poems.translate!.isNotEmpty)
                const SizedBox(height: 6),
              if (poems.translate != null && poems.translate!.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: SelectableText(
                    "诗词大意：${poems.translate!.join("")}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      });
}

Widget _buildTodayCourseContent(BuildContext context, TodayCourseSheet course) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: course.color,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconsProfile.watermelon,
                              color: course.color,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                course.startTime.formatTimeNoSecond(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                course.endTime.formatTimeNoSecond(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: course.color,
                            borderRadius: BorderRadius.circular(36),
                          ),
                          width: 4,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Text(
                                      course.timeString,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                        child: Text(
                                      course.courseName,
                                      style: const TextStyle(fontSize: 16),
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Text(
                                  course.teacherName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Text(
                                  course.location,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (course.courseStatus.isNotEmpty)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        course.courseStatus,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
