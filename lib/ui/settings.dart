import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/model/team_member.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/app.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/poems_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/theme/settings.dart';
import 'package:xhu_timetable_ios/url.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({super.key});

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  EventBus eventBus = getEventBus();

  DateTime lastClickTime = DateTime(2000, 0, 0);
  List<TeamMember> teamMemberList = [];

  var _disablePoems = false;
  var _showPoemsTranslate = true;
  var _showDeveloperOptions = false;

  var debugLastSyncCourseTime = "";
  var debugPoemsToken = "";

  @override
  void initState() {
    super.initState();
    getTeamMemberList().then((value) {
      setState(() {
        teamMemberList = value;
      });
    });
    isDisablePoems().then((value) {
      setState(() {
        _disablePoems = value;
      });
    });
    isShowTranslate().then((value) {
      setState(() {
        _showPoemsTranslate = value;
      });
    });

    isDebugMode().then((value) {
      setState(() {
        _showDeveloperOptions = value;
      });
    });
    getLastSyncCourse().then((value) {
      setState(() {
        debugLastSyncCourseTime = value.formatDate();
      });
    });
    getToken().then((value) {
      setState(() {
        debugPoemsToken = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("软件设置"),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: ListView(
          children: [
            context.buildSettingsGroup(
              title: "界面设置",
              items: [
                context.buildSettingsItem(
                  iconImage:
                      const Svg("assets/icons/svg/ic_custom_background.svg"),
                  title: "自定义背景图片",
                  onTap: () => Navigator.pushNamed(context, routeBackground),
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "诗词设置",
              items: [
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_poems_disable.svg"),
                  title: "禁用今日诗词",
                  trailing: Switch(
                      value: _disablePoems,
                      onChanged: (value) {
                        setDisablePoems(value).then((_) {
                          setState(() {
                            _disablePoems = value;
                          });
                          showToast("重启应用后生效");
                        });
                      }),
                ),
                context.buildSettingsItem(
                  iconImage:
                      const Svg("assets/icons/svg/ic_poems_show_translate.svg"),
                  title: "显示诗词大意",
                  trailing: Switch(
                      value: _showPoemsTranslate,
                      onChanged: (value) {
                        setShowTranslate(value).then((_) {
                          setState(() {
                            _showPoemsTranslate = value;
                          });
                          showToast("重启应用后生效");
                        });
                      }),
                ),
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_poems_reset.svg"),
                  title: "重置Token",
                  subtitle: "如果一直无法显示今日诗词，可能是缓存的Token出现了问题，点击此处可以进行重置",
                  onTap: () async {
                    await setToken("");
                    showToast("重置成功，重启应用后生效");
                  },
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "其他设置",
              items: [
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_join_group.svg"),
                  title: "点击加入『西瓜课表用户交流反馈』",
                  onTap: () {
                    loadInBrowser("https://blog.mystery0.vip/xgkb-group");
                  },
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "应用关于",
              items: [
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_update_log.svg"),
                  title: "更新日志",
                  onTap: () {
                    loadInBrowser(
                        "https://blog.mystery0.vip/xgkb-changelog-ios");
                  },
                ),
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_home_page.svg"),
                  title: "西瓜课表官网",
                  subtitle: "点击访问 https://xgkb.mystery0.vip",
                  onTap: () {
                    loadInBrowser("https://xgkb.mystery0.vip");
                  },
                ),
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_github.svg"),
                  title: "开源地址",
                  subtitle: "https://github.com/Mystery00/xhu_timetable_ios",
                  onTap: () {
                    loadInBrowser(
                        "https://github.com/Mystery00/xhu_timetable_ios");
                  },
                ),
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_poems.svg"),
                  title: "今日诗词",
                  subtitle: "感谢作者@xenv，点击访问『今日诗词』官网",
                  onTap: () {
                    loadInBrowser("https://www.jinrishici.com");
                  },
                ),
              ],
            ),
            context.buildSettingsGroup(
              title: "版本关于",
              items: [
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_beian.svg"),
                  title: "ICP备案号",
                  subtitle: "蜀ICP备19031621号-2A",
                  onTap: () {
                    loadInBrowser("https://beian.miit.gov.cn");
                  },
                ),
                context.buildSettingsItem(
                  iconImage: const Svg("assets/icons/svg/ic_version.svg"),
                  title: "版本号",
                  subtitle: "${getVersion()} - ${getBuildNumber()}",
                  onTap: () {
                    if (DateTime.now().difference(lastClickTime).inSeconds <
                        1) {
                      showToast('开发者模式已启动');
                      setDebugMode(true).then((_) {
                        setState(() {
                          _showDeveloperOptions = true;
                        });
                      });
                    }
                    lastClickTime = DateTime.now();
                  },
                ),
              ],
            ),
            SettingsGroup(
              margin: const EdgeInsets.all(8),
              settingsGroupTitle: "西瓜课表团队出品",
              settingsGroupTitleStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              items: [
                for (var teamMember in teamMemberList)
                  context.buildSettingsItem(
                    iconImage: NetworkImage(teamMember.icon),
                    iconSize: 36.0,
                    title: teamMember.title,
                    subtitle: teamMember.subtitle,
                  ),
              ],
            ),
            if (_showDeveloperOptions)
              SettingsGroup(
                margin: const EdgeInsets.all(8),
                settingsGroupTitle: "开发者选项",
                settingsGroupTitleStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                items: [
                  context.buildSettingsItem(
                    iconImage: const Svg("assets/icons/svg/ic_debug.svg"),
                    title: "启用开发者模式",
                    trailing: Switch(
                        value: _showDeveloperOptions,
                        onChanged: (value) {
                          setDebugMode(value).then((_) {
                            setState(() {
                              _showDeveloperOptions = value;
                            });
                          });
                        }),
                  ),
                  context.buildSettingsItem(
                    title: "设备id",
                    subtitle: getDeviceId(),
                    onTap: () {
                      showToast("设备id已复制到剪贴板");
                      Clipboard.setData(ClipboardData(text: getDeviceId()));
                    },
                  ),
                  context.buildSettingsItem(
                    title: "上一次同步课程数据时间",
                    subtitle: debugLastSyncCourseTime,
                  ),
                  context.buildSettingsItem(
                    title: "今日诗词Token",
                    subtitle: debugPoemsToken,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
