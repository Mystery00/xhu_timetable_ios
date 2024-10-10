import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:xhu_timetable_ios/api/rest/user.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user_campus.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/app.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/theme/settings.dart';

class ClassSettingsRoute extends StatefulWidget {
  const ClassSettingsRoute({super.key});
  @override
  State<ClassSettingsRoute> createState() => _ClassSettingsRouteState();
}

class _ClassSettingsRouteState extends SelectState<ClassSettingsRoute> {
  EventBus eventBus = getEventBus();

  List<String> selectYearAndTermList = [];
  UserCampus? userCampus;

  var _showNotThisWeek = false;
  var _showStatus = false;
  Customisable<int> _customNowYear =
      Customisable(data: initNowYear, custom: false);
  Customisable<int> _customNowTerm =
      Customisable(data: initNowTerm, custom: false);
  Customisable<DateTime> _customTermStartDate =
      Customisable(data: DateTime.now(), custom: false);

  @override
  void initState() {
    super.initState();
    loggedUserList().then((list) {
      list.sort((a, b) => a.userInfo.xhuGrade.compareTo(b.userInfo.xhuGrade));
      var startYear = list.firstOrNull?.userInfo.xhuGrade ?? 2019;
      var endYear = DateTime.now().year;
      var resultList = <String>[];
      for (var i = startYear; i <= endYear; i++) {
        resultList.add("$i-${i + 1}学年 第1学期");
        resultList.add("$i-${i + 1}学年 第2学期");
      }
      resultList.add("auto");
      setState(() {
        selectYearAndTermList = resultList.reversed.toList();
      });
    });
    loadUserCampus();
    _init();
  }

  void _init() {
    getShowNotThisWeek().then((value) {
      setState(() {
        _showNotThisWeek = value;
      });
    });
    getShowStatus().then((value) {
      setState(() {
        _showStatus = value;
      });
    });
    getCustomNowYear().then((value) {
      setState(() {
        _customNowYear = value;
      });
    });
    getCustomNowTerm().then((value) {
      setState(() {
        _customNowTerm = value;
      });
    });
    getCustomTermStartDate().then((value) {
      setState(() {
        _customTermStartDate = value;
      });
    });
  }

  void loadUserCampus() {
    mainUser()
        .then((user) => user.withAutoLoginOnce(
            (sessionToken) => apiGetCampusList(sessionToken)))
        .then((value) => setState(() {
              userCampus = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("课程设置"),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: ListView(
          children: [
            context.buildSettingsGroup(
              title: "显示设置",
              items: [
                context.buildSettingsItem(
                  iconImage:
                      const Svg("assets/icons/svg/ic_show_not_this_week.svg"),
                  title: "显示非本周课程",
                  trailing: Switch(
                      value: _showNotThisWeek,
                      onChanged: (value) {
                        setShowNotThisWeek(value).then((_) {
                          setState(() {
                            _showNotThisWeek = value;
                          });
                          eventBus.fire(UIChangeEvent.showNotThisWeek());
                        });
                      }),
                ),
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_show_status.svg"),
                  title: "显示今日课程状态",
                  trailing: Switch(
                      value: _showStatus,
                      onChanged: (value) {
                        setShowStatus(value).then((_) {
                          setState(() {
                            _showStatus = value;
                          });
                          eventBus.fire(UIChangeEvent.showStatus());
                        });
                      }),
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "时间设置",
              items: [
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_now_year_term.svg"),
                  title: "更改当前学期",
                  subtitle:
                      "当前学期：${_customNowYear.data}年 第${_customNowTerm.data}学期${!_customNowYear.custom && !_customNowTerm.custom ? "\n【根据当前时间自动计算所得】" : ""}",
                  onTap: () => showCustomNowYearTermDialog(),
                ),
                context.buildSettingsItem(
                  iconImage:
                      const Svg("assets/icons/svg/ic_term_start_date.svg"),
                  title: "更改开学时间",
                  subtitle:
                      "当前开学时间：${_customTermStartDate.data.formatDate()}${!_customTermStartDate.custom ? "\n【从云端获取】" : ""}",
                  onTap: () => showCustomTermStartDateDialog(),
                ),
                context.buildSettingsItem(
                  iconImage: const Svg(
                      "assets/icons/svg/ic_set_term_start_date_server.svg"),
                  title: "设置开学时间为自动获取",
                  onTap: () async {
                    await setCustomTermStartDate(Customisable.clearCustom(
                        DateTime.fromMillisecondsSinceEpoch(0)));
                    showToast("设置成功");
                    _init();
                  },
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "校区设置",
              items: [
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_user_campus.svg"),
                  title: "更新当前主用户校区",
                  subtitle: "当前校区：${userCampus?.selected}",
                  onTap: () => showCustomCampusDialog(),
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "自定义设置",
              items: [
                context.buildSettingsItem(
                  iconImage:
                      const Svg("assets/icons/svg/ic_custom_course_color.svg"),
                  title: "自定义课程颜色",
                  onTap: () =>
                      {Navigator.pushNamed(context, routeCustomCourseColor)},
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "额外功能",
              items: [
                context.buildSettingsItem(
                  iconImage:
                      const Svg("assets/icons/svg/ic_school_calendar.svg"),
                  title: "查看校历",
                  onTap: () =>
                      Navigator.pushNamed(context, routeSchoolCalendar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showCustomNowYearTermDialog() async {
    var auto = !_customNowYear.custom && !_customNowTerm.custom;
    var selected =
        "${_customNowYear.data}-${_customNowYear.data + 1}学年 第${_customNowTerm.data}学期";
    var list = selectYearAndTermList.map((e) {
      if (e == "auto") {
        return SelectView(
          title: "自动获取",
          valueTitle: "自动获取",
          value: "auto",
          selected: auto,
        );
      } else {
        return SelectView(
          title: e,
          valueTitle: e,
          value: e,
          selected: e == selected,
        );
      }
    }).toList();
    showSelectDialog(
        title: '更改当前学期',
        list: list,
        updateState: (list) async {
          var select = list.firstWhere((element) => element.selected).value;
          if (select == "auto") {
            await setCustomNowYear(Customisable.clearCustom(-1));
            await setCustomNowTerm(Customisable.clearCustom(-1));
          } else {
            var year = select.substring(0, 4);
            var term = select.substring(13, 14);
            await setCustomNowYear(Customisable.custom(int.parse(year)));
            await setCustomNowTerm(Customisable.custom(int.parse(term)));
          }
          eventBus.fire(UIChangeEvent.changeCurrentYearAndTerm());
          _init();
        });
  }

  Future<void> showCustomTermStartDateDialog() async {
    var now = DateTime.now();
    var date = _customTermStartDate.data;
    DateTime? selectDate = await showDatePicker(
      helpText: "选择开学日期",
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: date,
      currentDate: DateTime.now(),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selectDate != null) {
      await setCustomTermStartDate(Customisable.custom(selectDate));
      eventBus.fire(UIChangeEvent.changeTermStartDate());
    }
    _init();
  }

  Future<void> showCustomCampusDialog() async {
    if (userCampus == null) {
      showToast("校区列表加载中，请稍后再试");
      return;
    }
    var selected = userCampus!.selected;
    var list = userCampus!.items
        .map((e) => SelectView(
              title: e,
              valueTitle: e,
              value: e,
              selected: e == selected,
            ))
        .toList();
    showSelectDialog(
        title: '更改校区',
        list: list,
        updateState: (list) async {
          var campus = list.firstWhere((element) => element.selected).value;
          var user = await mainUser();
          await user.withAutoLoginOnce(
              (sessionToken) => apiSetCampus(sessionToken, campus));
          eventBus.fire(UIChangeEvent.changeCampus());
          loadUserCampus();
        });
  }
}
