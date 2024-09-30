import 'package:event_bus/event_bus.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/model/transfer/week_course_view.dart';
import 'package:xhu_timetable_ios/repository/main.dart';
import 'package:xhu_timetable_ios/repository/profile.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/main/model.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
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
  EventBus eventBus = getEventBus();

  Image? _background;
  final PageController _pageController = PageController();
  var todayTitle = "";
  var weekTitle = "";
  var _week = 1;
  List<WeekView> weekViewList = List.generate(
    20,
    (index) => WeekView(
        weekNum: index + 1,
        thisWeek: false,
        array: List.generate(5, (_) => List.generate(5, (_) => false))),
  );

  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    MainModel mainModel = MainModel.of(context, listen: false);
    _loadBackground();
    eventBus.on<UIChangeEvent>().listen((event) {
      if (event.isMultiModeChanged() || event.isChangeMainUser()) {
        _checkMainUser().then((needLogin) => needLogin
            ? Navigator.pushReplacementNamed(context, routeLogin)
            : _refreshCloudDataToState(mainModel));
      } else if (event.isMainUserLogout()) {
        _checkMainUser().then((needLogin) => needLogin
            ? Navigator.pushReplacementNamed(context, routeLogin)
            : {});
      } else if (event.isChangeCurrentYearAndTerm() || event.isChangeCampus()) {
        _refreshCloudDataToState(mainModel);
      } else if (event.isChangeTermStartDate() ||
          event.isShowNotThisWeek() ||
          event.isShowStatus() ||
          event.isChangeCustomAccountTitle()) {
        _loadLocalDataToState(mainModel, true);
      } else if (event.isChangeBackground()) {
        _loadBackground();
      }
    });
  }

  void _initWithModel(MainModel mainModel) async {
    mainModel.setRefreshing(true);
    await _calculateWeek(mainModel);
    await _loadLocalDataToState(mainModel, false);
  }

  void _loadBackground() async {
    var backgroundImage = await getBackgroundImage();
    if (backgroundImage.data != null) {
      setState(() {
        _background = Image.file(
          backgroundImage.data!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      });
    } else {
      setState(() {
        _background = Image.asset(
          "assets/images/main_bg.png",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      });
    }
  }

  Future<bool> _checkMainUser() async {
    var mainUser = await getMainUser();
    if (mainUser == null) {
      await clearMainUserCache();
      return true;
    }
    return false;
  }

  Future<void> _calculateWeek(MainModel mainModel) async {
    var initWeek = await XhuRepo.calculateWeek();
    var todayTitle = await XhuRepo.calculateTodayTitle(false);
    var weekTitle = XhuRepo.calculateWeekTitle(initWeek);
    var dateStart = await XhuRepo.calculateWeekStartDay(initWeek);
    mainModel.setWeekDateStart(dateStart);
    setState(() {
      this.todayTitle = todayTitle;
      this.weekTitle = weekTitle;
      _week = initWeek;
    });
  }

  Future<void> _changeWeek(MainModel mainModel, int week) async {
    var termStartDate = await getTermStartDate();
    var currentWeek = await XhuRepo.calculateWeek();
    var weekTitle = XhuRepo.calculateWeekTitle(week);
    setState(() {
      this.weekTitle = weekTitle;
      _week = week;
    });
    var (data, loadWarning) = await getMainPageData(false, true);
    if (loadWarning.isNotEmpty) {
      showToast(loadWarning);
    }
    var weekCourseList =
        await getWeekCourseSheetList(currentWeek, week, data.weekViewList);
    mainModel.setWeekCourseSheetList(weekCourseList);
    var dateStart = termStartDate.add(Duration(days: 7 * (week - 1)));
    mainModel.setWeekDateStart(dateStart);
  }

  // 初始化时候加载数据的方法
  Future<void> _loadLocalDataToState(
      MainModel mainModel, bool changeWeekOnly) async {
    try {
      mainModel.setRefreshing(true);
      var (currentWeek, loadFromCloud) = await _loadCourseConfig(false);
      var (data, loadWarning) = await getMainPageData(false, true);
      if (loadWarning.isNotEmpty) {
        showToast(loadWarning);
      }
      var todayCourseList =
          await getTodayCourseSheetList(currentWeek, data.todayViewList);
      mainModel.setTodayCourseSheetList(todayCourseList);
      var weekCourseList = await getWeekCourseSheetList(
          currentWeek, currentWeek, data.weekViewList);
      mainModel.setWeekCourseSheetList(weekCourseList);
      if (!changeWeekOnly) {
        var weekList = await _calculateWeekView(data.weekViewList, currentWeek);
        setState(() {
          weekViewList = weekList;
        });
      }
      if (loadFromCloud) {
        //需要从云端加载数据
        var (cloudData, loadWarning) = await getMainPageData(true, false);
        if (loadWarning.isNotEmpty) {
          showToast(loadWarning);
        }
        var todayCourseList =
            await getTodayCourseSheetList(currentWeek, cloudData.todayViewList);
        mainModel.setTodayCourseSheetList(todayCourseList);
        var weekCourseList = await getWeekCourseSheetList(
            currentWeek, currentWeek, cloudData.weekViewList);
        mainModel.setWeekCourseSheetList(weekCourseList);
        if (!changeWeekOnly) {
          var weekList =
              await _calculateWeekView(cloudData.weekViewList, currentWeek);
          setState(() {
            weekViewList = weekList;
          });
        }
      }
      mainModel.setRefreshing(false);
    } catch (e) {
      Logger().e(e);
      mainModel.setRefreshing(false);
      showToast("数据加载失败, ${handleException(e)}");
    }
  }

  //手动刷新加载数据的方法
  Future<void> _refreshCloudDataToState(MainModel mainModel) async {
    try {
      mainModel.setRefreshing(true);
      var (currentWeek, _) = await _loadCourseConfig(false);
      //从云端加载数据
      var (cloudData, loadWarning) = await getMainPageData(true, false);
      if (loadWarning.isNotEmpty) {
        showToast(loadWarning);
      }
      var todayCourseList =
          await getTodayCourseSheetList(currentWeek, cloudData.todayViewList);
      var weekCourseList = await getWeekCourseSheetList(
          currentWeek, currentWeek, cloudData.weekViewList);
      var weekList =
          await _calculateWeekView(cloudData.weekViewList, currentWeek);
      mainModel.setTodayCourseSheetList(todayCourseList);
      mainModel.setWeekCourseSheetList(weekCourseList);
      setState(() {
        weekViewList = weekList;
      });
      mainModel.setRefreshing(false);
      showToast("数据同步成功");
      var todayTitle = await XhuRepo.calculateTodayTitle(false);
      var weekTitle = XhuRepo.calculateWeekTitle(currentWeek);
      setState(() {
        this.todayTitle = todayTitle;
        this.weekTitle = weekTitle;
      });
    } catch (e) {
      Logger().e(e);
      mainModel.setRefreshing(false);
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
    return ChangeNotifierProvider(
      create: (context) {
        var model = MainModel();
        _initWithModel(model);
        return model;
      },
      child: Consumer<MainModel>(
        builder: (context, MainModel mainModel, child) {
          var pages = [
            const TodayHomePage(),
            const WeekHomePage(),
            const AccountHomePage(),
          ];
          var title = "西瓜课表";
          switch (_currentIndex) {
            case 0:
              if (todayTitle.isNotEmpty) {
                title = todayTitle;
              }
              break;
            case 1:
              if (weekTitle.isNotEmpty) {
                title = weekTitle;
              }
              break;
            case 2:
              title = "个人中心";
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                if (_currentIndex == 1)
                  IconButton(
                    icon: const Icon(IconsProfile.showWeekView),
                    onPressed: () {
                      _showWeekChooser(context, _week, weekViewList,
                          (week) async {
                        await _changeWeek(mainModel, week);
                      });
                    },
                  ),
                if (mainModel.isRefreshing)
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: SpinKitFadingCube(
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ),
                if (!mainModel.isRefreshing && _currentIndex == 1)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      if (!mainModel.isRefreshing) {
                        await _refreshCloudDataToState(mainModel);
                      }
                    },
                  ),
              ],
            ),
            body: Stack(
              children: [
                _background ?? const SizedBox(),
                PageView(
                  controller: _pageController,
                  children: pages,
                  onPageChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                ),
              ],
            ),
            bottomNavigationBar: FlashyTabBar(
              selectedIndex: _currentIndex,
              onItemSelected: (value) {
                _pageController.animateToPage(value,
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.fastLinearToSlowEaseIn);
                setState(() => _currentIndex = value);
              },
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
        },
      ),
    );
  }
}

void _showWeekChooser(BuildContext context, int showWeek,
    List<WeekView> weekViewList, Function(int) onWeekChange) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [
          for (var i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  for (var j = 0; j < 4; j++)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onWeekChange(weekViewList[i * 4 + j].weekNum);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: i * 4 + j == showWeek - 1
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  )
                                : null,
                            color: weekViewList[i * 4 + j].thisWeek
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CustomPaint(
                                  size: const Size(36, 36),
                                  painter: WeekPointPainer(
                                      array: weekViewList[i * 4 + j].array),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "第${weekViewList[i * 4 + j].weekNum}周",
                                style: const TextStyle(fontSize: 10),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      );
    },
  );
}

class WeekPointPainer extends CustomPainter {
  final List<List<bool>> array;

  WeekPointPainer({super.repaint, required this.array});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color(0xFF3FCAB8)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    var paint2 = Paint()
      ..color = const Color(0xFFCFDBDB)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    var width = size.width / 5;
    var height = size.height / 5;
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        canvas.drawCircle(
            Offset(width * i + width / 2, height * j + height / 2),
            2.5,
            array[i][j] ? paint1 : paint2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Future<List<WeekView>> _calculateWeekView(
    List<WeekCourseView> courseList, int currentWeek) async {
  List<WeekView> result = List.generate(
    20,
    (index) => WeekView(
        weekNum: index + 1,
        thisWeek: index + 1 == currentWeek,
        array: List.generate(5, (_) => List.generate(5, (_) => false))),
  );
  for (var course in courseList) {
    if (course.dayIndex > 5 || course.startDayTime > 10) {
      continue;
    }
    for (var w in course.weekList) {
      for (var index = course.startDayTime;
          index <= course.endDayTime && index <= 10;
          index++) {
        result[w - 1].array[course.dayIndex - 1][(index - 1) ~/ 2] = true;
      }
    }
  }
  return result;
}

class WeekView {
  final int weekNum;
  final bool thisWeek;
  final List<List<bool>> array;

  WeekView({
    required this.weekNum,
    required this.thisWeek,
    required this.array,
  });
}
