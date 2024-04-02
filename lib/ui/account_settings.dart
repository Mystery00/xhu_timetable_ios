import 'package:flutter/material.dart';

class AccountSettingsRoute extends StatefulWidget {
  const AccountSettingsRoute({super.key});

  @override
  State<StatefulWidget> createState() => _AccountSettingsRouteState();
}

class _AccountSettingsRouteState extends State<AccountSettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Account Settings"),
    ));
  }
}
