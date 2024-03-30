import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xhu_timetable_ios/model/poems.dart';
import 'package:xhu_timetable_ios/store/poems_store.dart';

class TodayHomePage extends StatefulWidget {
  const TodayHomePage({super.key});

  @override
  State<TodayHomePage> createState() => _TodayHomePageState();
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
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              buildPoems(context),
            ],
          ),
        )
      ],
    );
  }
}

Widget buildPoems(BuildContext context) {
  return FutureBuilder(
      future: loadPoems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          var data = snapshot.data!;
          return PoemsItem(poems: data).buildContent(context);
        }
        return const SizedBox();
      });
}

class PoemsItem {
  final Poems poems;

  PoemsItem({required this.poems});

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
                        poems.content,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        "—— ${poems.author}《${poems.title}》",
                        style: const TextStyle(fontSize: 12),
                      ),
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

class CourseItem {
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

  Widget buildContent(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Text(
                                  startTime,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Text(
                                  endTime,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 4,
                            height: 80,
                            color: Colors.grey,
                            padding: const EdgeInsets.all(12.0),
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
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(
                                    teacher,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
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
