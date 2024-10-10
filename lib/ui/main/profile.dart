import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xhu_timetable_ios/model/menu.dart';
import 'package:xhu_timetable_ios/store/menu_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/main/model.dart';
import 'package:xhu_timetable_ios/ui/theme/icons.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/theme/profile.dart';
import 'package:xhu_timetable_ios/url.dart';

class AccountHomePage extends StatefulWidget {
  const AccountHomePage({super.key});

  @override
  State<AccountHomePage> createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const _MenuList(),
    );
  }
}

class _AccountInfo extends StatefulWidget {
  const _AccountInfo();

  @override
  State<_AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<_AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MainModel mainModel, child) {
      List<String> userMoreInfoList = [];
      if (mainModel.userInfo == null) {
        return _build("账号未登录", "男", userMoreInfoList);
      }
      userMoreInfoList.add(mainModel.userInfo!.studentNo);
      userMoreInfoList.add(
          "${mainModel.userInfo!.xhuGrade}级 ${mainModel.userInfo!.className}");
      userMoreInfoList.add(mainModel.userInfo!.college);
      return _build(
        mainModel.userInfo!.name,
        mainModel.userInfo!.gender,
        userMoreInfoList,
      );
    });
  }

  Widget _build(
    String userName,
    String gender,
    List<String> userMoreInfoList,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BigUserCard(
        cardRadius: 16,
        backgroundColor: Theme.of(context).colorScheme.primary,
        userName: userName,
        userNameColor: Theme.of(context).colorScheme.onPrimary,
        userMoreInfo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userMoreInfoList
                .map((e) => Text(e,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)))
                .toList()),
        userProfilePic: defaultProfileImageByStudentId(userName, gender),
        cardActionWidget: SettingsItem(
          icons: IconsProfile.accountSettings,
          iconStyle: IconStyle(
            withBackground: true,
            borderRadius: 50,
            iconsColor: Colors.white,
            backgroundColor: ProfileColor.hash(userName),
            iconSize: 18.0,
          ),
          title: "编辑账号",
          onTap: () {
            Navigator.pushNamed(context, routeAccountSettings);
          },
        ),
      ),
    );
  }
}

class _MenuList extends StatefulWidget {
  const _MenuList();

  @override
  State<_MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<_MenuList> {
  final _list = <List<Menu>>[];

  @override
  void initState() {
    super.initState();
    loadAllMenu().then((value) {
      setState(() {
        _list.clear();
        _list.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _list.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _AccountInfo();
        }
        var list = _list[index - 1];
        return SettingsGroup(
          margin: const EdgeInsets.all(8),
          dividerColor: Theme.of(context).colorScheme.outline.withOpacity(0.24),
          items: list
              .map(
                (menu) => SettingsItem(
                  icons: _iconDataByMenuKey(menu.key),
                  iconStyle: IconStyle(
                    withBackground: true,
                    backgroundColor: ProfileColor.safeGet(menu.sort),
                    iconSize: 18.0,
                  ),
                  titleStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                  title: menu.title,
                  onTap: _onTapByMenuKey(menu),
                ),
              )
              .toList(),
        );
      },
    );
  }

  IconData _iconDataByMenuKey(String menuKey) {
    switch (menuKey) {
      case "query_exam":
        return IconsProfile.exam;
      case "query_score":
        return IconsProfile.score;
      case "exp_score":
        return IconsProfile.expScore;
      case "query_free_room":
        return IconsProfile.classroom;
      case "account_manage":
        return IconsProfile.accountSettings;
      case "class_setting":
        return IconsProfile.classSettings;
      case "settings":
        return IconsProfile.settings;
      case "notice":
        return IconsProfile.notice;
      case "share":
        return IconsProfile.share;
      case "join_group":
        return IconsProfile.joinGroup;
      case "server_detect":
        return IconsProfile.serverDetect;
      default:
        return IconsProfile.unknown;
    }
  }

  VoidCallback? _onTapByMenuKey(Menu menu) {
    switch (menu.key) {
      case "query_exam":
        return () => Navigator.pushNamed(context, routeQueryExam);
      case "query_score":
        return () => Navigator.pushNamed(context, routeQueryScore);
      case "exp_score":
        return () => Navigator.pushNamed(context, routeQueryExpScore);
      case "query_free_room":
        return () => showToast("暂未实现");
      case "class_setting":
        return () => Navigator.pushNamed(context, routeClassSettings);
      case "settings":
        return () => Navigator.pushNamed(context, routeSettings);
      case "notice":
        return () => Navigator.pushNamed(context, routeQueryNotice);
      case "share":
        return () => showToast("暂未实现");
      case "join_group":
        return () => loadInBrowser(menu.link);
      case "server_detect":
        return () => loadInBrowser(menu.link);
      default:
        if (menu.hint.isEmpty && menu.link.isNotEmpty) {
          return () => loadInBrowser(menu.link);
        }
        if (menu.hint.isNotEmpty) {
          return () => showToast(menu.hint);
        } else {
          return () => showToast("当前版本暂不支持该功能，请更新到最新版本");
        }
    }
  }
}
