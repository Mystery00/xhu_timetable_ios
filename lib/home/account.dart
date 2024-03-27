import 'package:flutter/material.dart';
import 'package:xhu_timetable_ios/model/account.dart';

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
          color: Theme.of(context).colorScheme.outline,
        ),
        const _Menu(),
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
  var showAccount = AccountShowEntity(
    name: "王琛",
    studentNo: "3120150905411",
    className: "软件工程4班",
    gender: "男",
    xhuGrade: "2015",
    majorName: "软件工程",
    college: "计算机学院",
    majorDirection: "软件工程方向",
  );
  var expand = true;

  @override
  Widget build(BuildContext context) {
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
                        "${showAccount.name}(${showAccount.studentNo})",
                        style: const TextStyle(fontSize: 17),
                      ),
                      Text(showAccount.className),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(expand ? Icons.expand_more : Icons.expand_less),
                  onPressed: () {
                    setState(() {
                      expand = !expand;
                    });
                  },
                ),
              ],
            ),
          ),
          if (expand)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "性别：${showAccount.gender}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "年级${showAccount.xhuGrade}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (showAccount.majorName != null)
                    Text(
                      "专业：${showAccount.majorName}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  if (showAccount.college != null)
                    Text(
                      "学院：${showAccount.college}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  if (showAccount.majorDirection != null)
                    Text(
                      "方向：${showAccount.majorDirection}",
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

class _Menu extends StatelessWidget {
  const _Menu();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _MenuItem(
          icon: Icons.settings,
          title: "考试管理",
          hasNext: true,
        ),
        _MenuItem(
          icon: Icons.settings,
          title: "成绩查询",
          hasNext: true,
        ),
        _MenuItem(
          icon: Icons.settings,
          title: "实验成绩",
          hasNext: true,
        ),
        _MenuItem(
          icon: Icons.settings,
          title: "空闲教室",
          hasNext: true,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final bool hasNext;
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem(
      {super.key,
      required this.hasNext,
      required this.icon,
      required this.title,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(icon),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(title),
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
          const Divider(
            height: 1,
          ),
      ],
    );
  }
}
