import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountSettingsRoute extends StatefulWidget {
  const AccountSettingsRoute({super.key});

  @override
  State<StatefulWidget> createState() => _AccountSettingsRouteState();
}

class _AccountSettingsRouteState extends State<AccountSettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("账号设置"),
      ),
      child: ListView(
        children: [
          SettingRow(
            rowData: SettingsYesNoConfig(
              initialValue: false,
              title: "多账号模式",
            ),
            onSettingDataRowChange: (value) {
              print(value);
            },
          ),
          // SettingsGroup(
          //     settingsGroupTitle: "多账号设置",
          //     settingsGroupTitleStyle:
          //         TextStyle(color: Theme.of(context).colorScheme.outline),
          //     items: [
          //       SettingsItem(
          //         icons: Icons.abc,
          //         title: "多账号模式",
          //         subtitle: "将当前所有已登录账号的课表全部显示出来",
          //         trailing: CupertinoSwitch(
          //             value: false,
          //             onChanged: (value) {
          //               print(value);
          //             }),
          //       )
          //     ])
        ],
      ),
    );
  }
}
