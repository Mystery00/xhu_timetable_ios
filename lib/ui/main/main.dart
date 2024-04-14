import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:xhu_timetable_ios/model/poems.dart';
import 'package:xhu_timetable_ios/repository/main.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
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
  var _week = 1;
  Poems? poems;
  var todayCourseSheetList = <TodayCourseSheet>[];

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
    var currentWeek = await XhuRepo.calculateWeek();
    setState(() {
      _week = currentWeek;
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
        todayCourseSheetList.addAll(todayCourseList);
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
          todayCourseSheetList.addAll(todayCourseList);
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
      setState(() {
        todayCourseSheetList = todayCourseList;
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
      WeekHomePage(),
      const AccountHomePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("西瓜课表"),
        actions: [
          if (_loading)
            SizedBox(
              height: 48,
              width: 48,
              child: SpinKitFadingCube(
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            )
          else
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
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
