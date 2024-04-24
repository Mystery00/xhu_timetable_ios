import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class XhuHeader extends StatelessWidget {
  const XhuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClassicHeader(
      completeDuration: Duration(milliseconds: 150),
      refreshStyle: RefreshStyle.Follow,
      releaseText: "松开开始加载",
      refreshingIcon: CupertinoActivityIndicator(),
      idleText: "下拉刷新数据",
      completeText: "数据加载完成",
      failedText: "数据加载失败，点击重试",
    );
  }
}

class XhuFooter extends StatelessWidget {
  const XhuFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClassicFooter(
      completeDuration: Duration(milliseconds: 150),
      loadStyle: LoadStyle.ShowAlways,
      idleText: "上拉加载更多数据",
      loadingIcon: CupertinoActivityIndicator(),
      failedText: "数据加载失败，点击重试",
      canLoadingText: "松开加载更多数据",
      noDataText: "o(´^｀)o 再怎么滑也没有啦~",
    );
  }
}
