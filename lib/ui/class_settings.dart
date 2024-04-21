import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';

class ClassSettingsRoute extends StatefulWidget {
  const ClassSettingsRoute({super.key});
  @override
  State<ClassSettingsRoute> createState() => _ClassSettingsRouteState();
}

class _ClassSettingsRouteState extends State<ClassSettingsRoute> {
  EventBus eventBus = getEventBus();

  List<String> selectYearAndTermList = [];

  var _showNotThisWeek = false;
  var _showStatus = false;
  Customisable<int> _customNowYear = Customisable(data: 2023, custom: false);
  Customisable<int> _customNowTerm = Customisable(data: 2, custom: false);
  Customisable<DateTime> _customTermStartDate =
      Customisable(data: DateTime.now(), custom: false);

  @override
  void initState() {
    super.initState();
    loggedUserList().then((list) {
      list.sort((a, b) => a.userInfo.xhuGrade.compareTo(b.userInfo.xhuGrade));
      var startYear = list.firstOrNull?.userInfo.xhuGrade ?? 2019;
      var endYear = DateTime.now().year;
      var resultList = ["自动获取"];
      for (var i = startYear; i <= endYear; i++) {
        resultList.add("$i-${i + 1}学年 第1学期");
        resultList.add("$i-${i + 1}学年 第2学期");
      }
      setState(() {
        selectYearAndTermList = resultList;
      });
    });
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
            SettingsGroup(
                margin: const EdgeInsets.all(8),
                iconItemSize: 24,
                settingsGroupTitle: "显示设置",
                settingsGroupTitleStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                items: [
                  SettingsItem(
                    iconImage:
                        const Svg("assets/icons/svg/ic_show_not_this_week.svg"),
                    title: "显示非本周课程",
                    titleStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
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
                  SettingsItem(
                    iconImage: const Svg("assets/icons/svg/ic_show_status.svg"),
                    title: "显示今日课程状态",
                    titleStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
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
                ]),
            SettingsGroup(
                margin: const EdgeInsets.all(8),
                iconItemSize: 24,
                settingsGroupTitle: "时间设置",
                settingsGroupTitleStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                items: [
                  SettingsItem(
                    iconImage:
                        const Svg("assets/icons/svg/ic_now_year_term.svg"),
                    title: "更改当前学期",
                    titleStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    subtitle:
                        "当前学期：${_customNowYear.data}年 第${_customNowTerm.data}学期${!_customNowYear.custom && !_customNowTerm.custom ? "\n【根据当前时间自动计算所得】" : ""}",
                    subtitleStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(170)),
                    onTap: () => showCustomNowYearTermDialog(),
                  ),
                  SettingsItem(
                    iconImage:
                        const Svg("assets/icons/svg/ic_term_start_date.svg"),
                    title: "更改开学时间",
                    titleStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    subtitle:
                        "当前开学时间：${_customTermStartDate.data.formatDate()}${!_customTermStartDate.custom ? "\n【从云端获取】" : ""}",
                    subtitleStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(170)),
                    onTap: () => showCustomTermStartDateDialog(),
                  ),
                  SettingsItem(
                    iconImage: const Svg(
                        "assets/icons/svg/ic_set_term_start_date_server.svg"),
                    title: "设置开学时间为自动获取",
                    titleStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    onTap: () async {
                      await setCustomTermStartDate(Customisable.clearCustom(
                          DateTime.fromMillisecondsSinceEpoch(0)));
                      showToast("设置成功");
                      _init();
                    },
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Future<void> showCustomNowYearTermDialog() async {
    int? result = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('更改当前学期'),
            children: [
              for (var i = 0; i < selectYearAndTermList.length; i++)
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(selectYearAndTermList[i]),
                  ),
                ),
            ],
          );
        });
    if (result == 0) {
      await setCustomNowYear(Customisable.clearCustom(-1));
      await setCustomNowTerm(Customisable.clearCustom(-1));
    } else if (result != null) {
      var year = selectYearAndTermList[result].substring(0, 4);
      var term = selectYearAndTermList[result].substring(13, 14);
      await setCustomNowYear(Customisable.custom(int.parse(year)));
      await setCustomNowTerm(Customisable.custom(int.parse(term)));
      eventBus.fire(UIChangeEvent.changeCurrentYearAndTerm());
    }
    _init();
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
}
