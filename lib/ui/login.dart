import 'package:flutter/material.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  LoginRouteState createState() => LoginRouteState();
}

class LoginRouteState extends State<LoginRoute> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  String loginLabel = "密码填写说明";
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                  ),
                  controller: _unameController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 48,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "密码",
                    hintText: "请输入密码",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  controller: _pwdController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                if (loginLabel.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      errorText,
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
                    onPressed: () => {_doLogin()},
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
    );
  }

  void _doLogin() {
    if (_unameController.text.isEmpty) {
      setState(() {
        errorText = "学号不能为空";
      });
      return;
    }
    if (_pwdController.text.isEmpty) {
      setState(() {
        errorText = "密码不能为空";
      });
      return;
    }
    //doLogin
    Navigator.pushNamed(context, "/main");
  }
}
