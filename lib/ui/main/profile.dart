import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xhu_timetable_ios/model/menu.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/model/user_info.dart';
import 'package:xhu_timetable_ios/repository/profile.dart';
import 'package:xhu_timetable_ios/store/menu_store.dart';
import 'package:xhu_timetable_ios/ui/url.dart';

class AccountHomePage extends StatefulWidget {
  const AccountHomePage({super.key});

  @override
  State<AccountHomePage> createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AccountInfo(),
        Divider(
          thickness: 6,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.36),
        ),
        const Expanded(child: _MenuList()),
      ],
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
  UserInfo? userInfo = null;

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
    if (userInfo == null) {
      return _build("账号未登录", "", null);
    }
    return _build(
      "${userInfo!.name}(${userInfo!.studentNo})",
      userInfo!.className,
      userInfo,
    );
  }

  Widget _build(String title, String subtitle, UserInfo? userInfo) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 90,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://github.com/Mystery00/XhuTimetable/raw/master/app/src/main/res/drawable/img_boy1.webp",
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 17),
                      ),
                      if (subtitle.isNotEmpty) Text(subtitle),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(expand ? Icons.expand_more : Icons.expand_less),
                  onPressed: () {
                    if (userInfo == null) {
                      setState(() {
                        expand = false;
                      });
                    } else {
                      setState(() {
                        expand = !expand;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          if (expand && userInfo != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "性别：${userInfo.gender}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "年级：${userInfo.xhuGrade}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (userInfo.majorName.isNotEmpty)
                    Text(
                      "专业：${userInfo.majorName}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  if (userInfo.college.isNotEmpty)
                    Text(
                      "学院：${userInfo.college}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  if (userInfo.majorDirection.isNotEmpty)
                    Text(
                      "方向：${userInfo.majorDirection}",
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            )
        ],
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
    return ListView.separated(
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return _buildMenuList(_list[index]);
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 6,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.36),
        );
      },
    );
  }

  Widget _buildMenuList(List<Menu> list) {
    var result = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      var menu = list[i];
      result.add(_MenuItem(
        hasNext: i < list.length - 1,
        menu: menu,
      ));
    }
    return Column(
      children: result,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Menu menu;
  final bool hasNext;

  const _MenuItem({required this.menu, required this.hasNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _onTapByMenuKey(menu),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(
                    _assetPathByMenuKey(menu.key),
                    height: 24,
                    width: 24,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(menu.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasNext)
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
          ),
      ],
    );
  }

  String _assetPathByMenuKey(String menuKey) {
    switch (menuKey) {
      case "query_exam":
        return "assets/icons/profile/icon/exam.svg";
      case "query_score":
        return "assets/icons/profile/icon/score.svg";
      case "query_free_room":
        return "assets/icons/profile/icon/classroom.svg";
      case "account_manage":
        return "assets/icons/profile/icon/account_settings.svg";
      case "settings":
        return "assets/icons/profile/icon/settings.svg";
      case "notice":
        return "assets/icons/profile/icon/notice.svg";
      case "share":
        return "assets/icons/profile/icon/share.svg";
      case "join_group":
        return "assets/icons/profile/icon/join_group.svg";
      case "server_detect":
        return "assets/icons/profile/icon/server_detect.svg";
      default:
        return "assets/icons/profile/icon/unknown.svg";
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
