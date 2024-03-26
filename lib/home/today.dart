import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class TodayHomePage extends StatefulWidget {
  const TodayHomePage({super.key});

  @override
  State<TodayHomePage> createState() => _TodayHomePageState();
}

class _TodayHomePageState extends State<TodayHomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TodayListWidget(items: [
        PoemsItem(
          author: "李白",
          title: "静夜思",
          content: "床前明月光，疑是地上霜。",
          fullContent: "床前明月光，疑是地上霜。举头望明月，低头思故乡。",
        ),
        CourseItem(
          courseName: "课程名称",
          weekList: [1, 2, 3],
          day: 2,
          startDayTime: 1,
          endDayTime: 2,
          startTime: "08:00",
          endTime: "09:40",
          location: "上课教室",
          teacher: "授课教师",
        ),
        CourseItem(
          courseName: "课程名称2",
          weekList: [1, 2, 3],
          day: 2,
          startDayTime: 3,
          endDayTime: 4,
          startTime: "10:00",
          endTime: "11:40",
          location: "上课教室222",
          teacher: "授课教师22222",
        ),
      ]),
    );
  }
}

class TodayListWidget extends StatelessWidget {
  final List<TodayItem> items;

  const TodayListWidget({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 1,
            height: double.infinity,
            color: Colors.grey,
            margin: const EdgeInsets.only(left: 10, right: 10),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index].buildContent(context);
            },
          ),
        )
      ],
    );
  }
}

abstract class TodayItem {
  Widget buildContent(BuildContext context);
}

class PoemsItem extends TodayItem {
  final String title;
  final String author;
  final String content;
  final String fullContent;

  PoemsItem(
      {required this.title,
      required this.author,
      required this.content,
      required this.fullContent});

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(right: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        content,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      "—— $author《$title》",
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CourseItem extends TodayItem {
  final String courseName;
  final List<int> weekList;
  final int day;
  final int startDayTime;
  final int endDayTime;
  final String startTime;
  final String endTime;
  final String location;
  final String teacher;

  CourseItem(
      {required this.courseName,
      required this.weekList,
      required this.day,
      required this.startDayTime,
      required this.endDayTime,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.teacher});

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset("assets/icons/ic_watermelon.svg",
                                  height: 16,
                                  width: 16,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.red, BlendMode.srcIn)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, bottom: 1),
                                child: Text(
                                  startTime,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, bottom: 1),
                                child: Text(
                                  endTime,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 4,
                            height: 100,
                            color: Colors.grey,
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.only(left: 8, right: 8),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, bottom: 1),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text(
                                        "$startDayTime-$endDayTime节",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Expanded(
                                        child: Text(
                                          courseName,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, bottom: 1),
                                  child: Text(
                                    teacher,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 1, bottom: 1),
                                  child: Text(
                                    location,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
