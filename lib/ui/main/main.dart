import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/main/today.svg",
              height: 24,
              width: 24,
            ),
            label: "今日",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/main/week.svg",
              height: 24,
              width: 24,
            ),
            label: "本周",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/main/profile.svg",
              height: 24,
              width: 24,
            ),
            label: "我的",
          ),
        ],
      ),
    );
  }
}
