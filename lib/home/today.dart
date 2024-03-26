import 'package:flutter/material.dart';

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
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: items[index].buildContent(context),
            ),
          ),
        );
      },
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
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
          ),
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
    return Column(
      children: [
        Text(
          courseName,
        ),
        Text(
          teacher,
        ),
        Text(
          location,
        ),
      ],
    );
  }
}
