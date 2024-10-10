import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/feature.dart';
import 'package:xhu_timetable_ios/repository/login.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/ui/routes.dart';
import 'package:xhu_timetable_ios/toast.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  LoginRouteState createState() => LoginRouteState();
}

class LoginRouteState extends State<LoginRoute> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  String loginLabel = "";

  @override
  void initState() {
    super.initState();
    getFeatureLoginLabel().then((value) => setState(() {
          loginLabel = value;
        }));
  }

  void showLoading() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("登录中"),
        content: SizedBox(
          height: 64,
          child: SpinKitSquareCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
        ),
      ),
    );
  }

  void dismissLoading() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool fromSettings =
        ModalRoute.of(context)!.settings.arguments as bool? ?? false;
    return Scaffold(
      appBar: fromSettings
          ? AppBar(
              title: const Text("登录其他账号"),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_header.png",
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                  const SizedBox(
                    height: 62,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "学号",
                      hintText: "请输入学号",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                    controller: _unameController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "密码",
                      hintText: "请输入密码",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    controller: _pwdController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  if (loginLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        loginLabel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => {
                        _doLogin().then((loginSuccess) {
                          if (loginSuccess) {
                            if (fromSettings) {
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            } else {
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, routeMain);
                              }
                            }
                          }
                        })
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text(
                        "登 录",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _doLogin() async {
    if (_unameController.text.isEmpty) {
      showToast("学号不能为空");
      return false;
    }
    if (_pwdController.text.isEmpty) {
      showToast("密码不能为空");
      return false;
    }
    showLoading();
    if (await getUserByStudentId(_unameController.text) != null) {
      showToast("该用户已登录！");
      dismissLoading();
      return false;
    }
    try {
      await doLogin(_unameController.text, _pwdController.text);
      showToast("登录成功，欢迎使用西瓜课表");
      return true;
    } catch (e) {
      showToast(handleException(e));
    } finally {
      dismissLoading();
    }
    return false;
  }
}
