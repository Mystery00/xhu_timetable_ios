import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xhu_timetable_ios/ui/theme/icons.dart';

import 'today.dart';
import 'week.dart';
import 'profile.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  var pages = [
    const TodayHomePage(),
    const WeekHomePage(),
    const AccountHomePage(),
  ];
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("西瓜课表"),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconsProfile.navigationToday),
            label: "今日",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsProfile.navigationWeek),
            label: "本周",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsProfile.navigationProfile),
            label: "我的",
          ),
        ],
      ),
    );
  }
}
