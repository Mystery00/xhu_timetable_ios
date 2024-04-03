import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xhu_timetable_ios/model/menu.dart';
import 'package:xhu_timetable_ios/model/user_info.dart';
import 'package:xhu_timetable_ios/repository/profile.dart';
import 'package:xhu_timetable_ios/store/menu_store.dart';
import 'package:xhu_timetable_ios/ui/theme/colors.dart';
import 'package:xhu_timetable_ios/ui/theme/icons.dart';
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
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: const Column(
        children: [
          _AccountInfo(),
          Expanded(child: _MenuList()),
        ],
      ),
    );
  }
}

class _AccountInfo extends StatefulWidget {
  const _AccountInfo();

  @override
  State<_AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<_AccountInfo> {
  var expand = true;
  UserInfo? userInfo;

  @override
  void initState() {
    super.initState();
    getMainUserWithCache().then((value) {
      setState(() {
        userInfo = value?.userInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> userMoreInfoList = [];
    if (userInfo == null) {
      return _build("账号未登录", "", userMoreInfoList);
    }
    userMoreInfoList.add(userInfo!.studentNo);
    userMoreInfoList.add("${userInfo!.xhuGrade}级 ${userInfo!.className}");
    userMoreInfoList.add(userInfo!.college);
    return _build(
      userInfo!.name,
      userInfo!.studentNo,
      userMoreInfoList,
    );
  }

  Widget _build(String title, String studentId, List<String> userMoreInfoList) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BigUserCard(
        backgroundColor: Theme.of(context).colorScheme.primary,
        userName: title,
        userNameColor: Theme.of(context).colorScheme.onPrimary,
        userMoreInfo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userMoreInfoList
                .map((e) => Text(e,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)))
                .toList()),
        userProfilePic: defaultProfileImageByStudentId(studentId),
        cardActionWidget: SettingsItem(
          icons: Icons.edit,
          iconStyle: IconStyle(
            withBackground: true,
            borderRadius: 50,
            iconsColor: Colors.white,
            backgroundColor: ProfileColor.hash(title),
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
      itemCount: _list.length,
      itemBuilder: (context, index) {
        var list = _list[index];
        return Container(
          margin: const EdgeInsets.all(8),
          child: SettingsGroup(
              margin: EdgeInsets.zero,
              iconItemSize: 18,
              dividerColor:
                  Theme.of(context).colorScheme.outline.withOpacity(0.24),
              items: list
                  .map(
                    (menu) => SettingsItem(
                      icons: _iconDataByMenuKey(menu.key),
                      iconStyle: IconStyle(
                        withBackground: true,
                        backgroundColor: ProfileColor.safeGet(menu.sort),
                      ),
                      titleStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                      title: menu.title,
                      onTap: _onTapByMenuKey(menu),
                    ),
                  )
                  .toList()),
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
      case "query_free_room":
        return IconsProfile.classroom;
      case "account_manage":
        return IconsProfile.accountSettings;
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
        return null;
      case "query_score":
        return null;
      case "query_free_room":
        return null;
      case "account_manage":
        return null;
      case "settings":
        return null;
      case "notice":
        return null;
      case "share":
        return null;
      case "join_group":
        return () => loadInBrowser(menu.link);
      case "server_detect":
        return () => loadInBrowser(menu.link);
      default:
        if (menu.hint.isEmpty && menu.link.isNotEmpty) {
          return () => loadInBrowser(menu.link);
        }
        if (menu.hint.isNotEmpty) {
          return () => Fluttertoast.showToast(
                msg: menu.hint,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
        } else {
          return () => Fluttertoast.showToast(
                msg: "当前版本暂不支持该功能，请更新到最新版本",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
        }
    }
  }
}
