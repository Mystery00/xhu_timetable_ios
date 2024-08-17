import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/event/bus.dart';
import 'package:xhu_timetable_ios/event/ui.dart';
import 'package:xhu_timetable_ios/model/custom_account_title.dart';
import 'package:xhu_timetable_ios/repository/user.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/ui/theme/icons.dart';
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
  var _multiAccountMode = false;
  var _customAccountTitle = DEFAULT_CUSTOM_ACCOUNT_TITLE;
  List<LoggedUserItem> list = [];

  @override
  void initState() {
    super.initState();
    _init();
    refresh();
  }

  void _init() {
    getMultiAccountMode().then((value) {
      setState(() {
        _multiAccountMode = value;
      });
    });
    getCustomAccountTitle().then((value) {
      setState(() {
        _customAccountTitle = value;
      });
    });
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
            if (loginOther == null) {
              return;
            }
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
                        value: _multiAccountMode,
                        onChanged: (value) {
                          setMultiAccountMode(value).then((_) {
                            setState(() {
                              _multiAccountMode = value;
                            });
                            eventBus.fire(UIChangeEvent.multiModeChanged());
                          });
                        }),
                  ),
                  context.buildSettingsItem(
                    icons: IconsProfile.navigationToday,
                    title: "今日课程界面账号信息模板",
                    subtitle: "启动多账号模式之后，使用该模板来显示对应的账号信息",
                    onTap: () => showCustomAccountTitleDialog(
                        _customAccountTitle.todayTemplate,
                        DEFAULT_CUSTOM_ACCOUNT_TITLE.todayTemplate,
                        (todayTemplate) async {
                      await setCustomAccountTitle(CustomAccountTitle(
                          todayTemplate: todayTemplate,
                          weekTemplate: _customAccountTitle.weekTemplate));
                      eventBus.fire(UIChangeEvent.changeCustomAccountTitle());
                    }),
                  ),
                  context.buildSettingsItem(
                    icons: IconsProfile.navigationWeek,
                    title: "本周课程界面账号信息模板",
                    subtitle: "启动多账号模式之后，使用该模板来显示对应的账号信息",
                    onTap: () => showCustomAccountTitleDialog(
                        _customAccountTitle.weekTemplate,
                        DEFAULT_CUSTOM_ACCOUNT_TITLE.weekTemplate,
                        (weekTemplate) async {
                      await setCustomAccountTitle(CustomAccountTitle(
                          todayTemplate: _customAccountTitle.todayTemplate,
                          weekTemplate: weekTemplate));
                      eventBus.fire(UIChangeEvent.changeCustomAccountTitle());
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
                                              u.userName,
                                              u.gender,
                                            )),
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
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith(
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

  Future<void> showCustomAccountTitleDialog(
      String oldData, String resetData, Function(String) func) async {
    var inputController = TextEditingController(text: oldData);
    String? result = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("请输入模板内容"),
            content: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                    maxLines: 3,
                    controller: inputController,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(4)),
                        ),
                        onPressed: () {
                          inputController.text =
                              "${inputController.text}{studentNo}";
                        },
                        child: const Text("学号"),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(4)),
                        ),
                        onPressed: () {
                          inputController.text =
                              "${inputController.text}{name}";
                        },
                        child: const Text("姓名"),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(4)),
                        ),
                        onPressed: () {
                          inputController.text =
                              "${inputController.text}{nickName}";
                        },
                        child: const Text("昵称"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  inputController.text = resetData;
                },
                child: const Text("重置"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, inputController.text);
                },
                child: const Text("确定"),
              ),
            ],
          );
        });
    if (result == null) {
      return;
    }
    await func(result);
    _customAccountTitle = await getCustomAccountTitle();
  }
}
