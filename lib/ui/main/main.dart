import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:xhu_timetable_ios/model/poems.dart';
import 'package:xhu_timetable_ios/repository/main.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/poems_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
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
  var _loading = false;
  var todayWeek = 1;
  var _week = 1;
  Poems? poems;
  DateTime _dateStart = DateTime.now().atStartOfDay();
  var todayCourseSheetList = <TodayCourseSheet>[];
  var weekCourseSheetList = <List<WeekCourseSheet>>[];

  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _showPoems();
    await _calculateWeek();
    await _loadLocalDataToState(false);
  }

  Future<void> _showPoems() async {
    try {
      var poems = await loadPoems();
      setState(() {
        this.poems = poems;
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> _calculateWeek() async {
    var termStartDate = await getTermStartDate();
    var currentWeek = await XhuRepo.calculateWeek();
    setState(() {
      todayWeek = currentWeek;
      _week = currentWeek;
    });
    var dateStart = termStartDate.add(Duration(days: 7 * (currentWeek - 1)));
    setState(() {
      _dateStart = dateStart;
    });
  }

  // 初始化时候加载数据的方法
  Future<void> _loadLocalDataToState(bool changeWeekOnly) async {
    try {
      setState(() {
        _loading = true;
      });
      var (currentWeek, loadFromCloud) =
          await _loadCourseConfig(changeWeekOnly);
      var (data, loadWarning) = await getMainPageData(false, true);
      if (loadWarning.isNotEmpty) {
        showToast(loadWarning);
      }
      var todayCourseList =
          await getTodayCourseSheetList(currentWeek, data.todayViewList);
      setState(() {
        todayCourseSheetList = todayCourseList;
      });
      var weekCourseList = await getWeekCourseSheetList(
          currentWeek, currentWeek, data.weekViewList, changeWeekOnly);
      setState(() {
        weekCourseSheetList = weekCourseList;
      });
      if (loadFromCloud) {
        //需要从云端加载数据
        var (cloudData, loadWarning) = await getMainPageData(true, false);
        if (loadWarning.isNotEmpty) {
          showToast(loadWarning);
        }
        var todayCourseList =
            await getTodayCourseSheetList(currentWeek, cloudData.todayViewList);
        setState(() {
          todayCourseSheetList = todayCourseList;
        });
        var weekCourseList = await getWeekCourseSheetList(
            currentWeek, currentWeek, cloudData.weekViewList, changeWeekOnly);
        setState(() {
          weekCourseSheetList = weekCourseList;
        });
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      Logger().e(e);
      setState(() {
        _loading = false;
      });
      showToast("数据加载失败, $e");
    }
  }

  //手动刷新加载数据的方法
  Future<void> _refreshCloudDataToState() async {
    try {
      setState(() {
        _loading = true;
      });
      var (currentWeek, _) = await _loadCourseConfig(false);
      //从云端加载数据
      var (cloudData, loadWarning) = await getMainPageData(true, false);
      if (loadWarning.isNotEmpty) {
        showToast(loadWarning);
      }
      var todayCourseList =
          await getTodayCourseSheetList(currentWeek, cloudData.todayViewList);
      var weekCourseList = await getWeekCourseSheetList(
          currentWeek, currentWeek, cloudData.weekViewList, false);
      setState(() {
        todayCourseSheetList = todayCourseList;
        weekCourseSheetList = weekCourseList;
        _loading = false;
      });
      showToast("数据同步成功");
    } catch (e) {
      Logger().e(e);
      setState(() {
        _loading = false;
      });
      showToast("数据同步失败, $e");
    }
  }

  Future<(int, bool)> _loadCourseConfig(bool forceUpdate) async {
    //加载多账号模式
    var loadFromCloud = forceUpdate;
    if (!loadFromCloud) {
      var lastSyncCourseDate = await getLastSyncCourse();
      var now = DateTime.now().atStartOfDay();
      loadFromCloud = lastSyncCourseDate.isBefore(now);
    }
    var currentWeek = await XhuRepo.calculateWeek();
    _week = currentWeek;
    return (currentWeek, loadFromCloud);
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      TodayHomePage(
        poems: poems,
        todayCourseSheetList: todayCourseSheetList,
      ),
      WeekHomePage(
        weekDateStart: _dateStart,
        weekCourseSheetList: weekCourseSheetList,
      ),
      const AccountHomePage(),
    ];
    var title = "西瓜课表";
    switch (_currentIndex) {
      case 0:
        title = "第$todayWeek周 ${DateTime.now().getDayOfWeek()}";
        break;
      case 1:
        title = "第$_week周";
        break;
      case 2:
        title = "个人中心";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            if (_currentIndex == 1) {
              _calculateWeek();
            }
          },
          child: Text(title),
        ),
        actions: [
          if (_loading)
            SizedBox(
              height: 48,
              width: 48,
              child: SpinKitFadingCube(
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ),
          if (!_loading && _currentIndex == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                if (!_loading) {
                  await _refreshCloudDataToState();
                }
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/main_bg.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _currentIndex,
        onItemSelected: (value) => setState(() => _currentIndex = value),
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: const Duration(milliseconds: 360),
        iconSize: 24,
        shadows: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
        items: [
          FlashyTabBarItem(
            icon: const Icon(IconsProfile.navigationToday),
            title: const Text("今日"),
          ),
          FlashyTabBarItem(
            icon: const Icon(IconsProfile.navigationWeek),
            title: const Text("本周"),
          ),
          FlashyTabBarItem(
            icon: const Icon(IconsProfile.navigationProfile),
            title: const Text("我的"),
          ),
        ],
      ),
    );
  }
}
