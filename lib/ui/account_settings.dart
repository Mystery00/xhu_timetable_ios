import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/repository/user.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/theme/profile.dart';
import 'package:xhu_timetable_ios/ui/theme/settings.dart';

class AccountSettingsRoute extends StatefulWidget {
  const AccountSettingsRoute({super.key});

  @override
  State<StatefulWidget> createState() => _AccountSettingsRouteState();
}

class _AccountSettingsRouteState extends State<AccountSettingsRoute> {
  EventBus eventBus = getEventBus();

  var editMode = false;
  List<LoggedUserItem> list = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    loadLoggedUserList().then((value) {
      setState(() {
        list = value;
      });
    });
  }

  void _logout(String studentId) async {
    var result = await logout(studentId);
    if (result) {
      eventBus.fire(UIChangeEvent.mainUserLogout());
    }
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("账号设置"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                editMode = !editMode;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var loginOther =
                await Navigator.pushNamed(context, routeLogin, arguments: true);
            bool loginOtherAccount = loginOther as bool;
            if (loginOtherAccount) {
              refresh();
            }
          },
          label: const Text("登录其他账号")),
      body: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: ListView(
            children: [
              context.buildSettingsGroup(
                title: "多账号设置",
                items: [
                  context.buildSettingsItem(
                    icons: Icons.account_circle,
                    title: "多账号模式",
                    subtitle: "将当前所有已登录账号的课表全部显示出来",
                    trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          showToast("暂未实现");
                        }),
                  ),
                ],
              ),
              context.buildSettingsGroup(
                title: "账号管理",
                items: [
                  context.buildSettingsItem(
                    title: "长按用户卡片可强制更新用户信息",
                    subtitle: "转了专业或者因为某些原因，导致教务系统的个人信息变更，可通过此方式更新服务端的缓存",
                    trailing: const SizedBox(),
                  ),
                ],
              ),
              Column(
                children: list
                    .map(
                      (u) => InkWell(
                        onTap: () async {
                          await setMainUserById(u.studentId);
                          eventBus.fire(UIChangeEvent.changeMainUser());
                          refresh();
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              if (u.isMain)
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      "主用户",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image(
                                            width: 48,
                                            height: 48,
                                            image:
                                                defaultProfileImageByStudentId(
                                                    u.studentId)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${u.studentId}(${u.userName})",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "年级：${u.xhuGrade}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (u.majorName.isNotEmpty)
                                            Text(
                                              "专业：${u.majorName}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          if (u.college.isNotEmpty)
                                            Text(
                                              "学院：${u.college}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          if (u.majorDirection.isNotEmpty)
                                            Text(
                                              "专业方向：${u.majorDirection}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: editMode ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: SizedBox(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.white),
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.red),
                                          ),
                                          onPressed: () {
                                            _logout(u.studentId);
                                          },
                                          child: const Text(
                                            "退出登录",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
    );
  }
}
