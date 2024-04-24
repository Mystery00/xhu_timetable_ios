import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xhu_timetable_ios/api/rest/notice.dart';
import 'package:xhu_timetable_ios/model/notice.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/transfer/select_view.dart';
import 'package:xhu_timetable_ios/model/user.dart';
import 'package:xhu_timetable_ios/repository/xhu.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';
import 'package:xhu_timetable_ios/toast.dart';
import 'package:xhu_timetable_ios/url.dart';

class QueryNoticeRoute extends StatefulWidget {
  const QueryNoticeRoute({super.key});

  @override
  State<QueryNoticeRoute> createState() => _QueryNoticeRouteState();
}

class _QueryNoticeRouteState extends SelectState<QueryNoticeRoute> {
  int index = 0;
  int size = 10;

  List<NoticeResponse> noticeList = [];
  final _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async {
    try {
      var result = await _getNoticeList(0, size);
      index = 0;
      var list = result.items;
      setState(() {
        noticeList = list;
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      Logger().e(e);
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      var result = await _getNoticeList(index + 1, size);
      if (result.items.isEmpty) {
        return _refreshController.loadNoData();
      }
      index++;
      var list = result.items;
      setState(() {
        noticeList.addAll(list);
      });
      _refreshController.loadComplete();
    } catch (e) {
      Logger().e(e);
      _refreshController.loadFailed();
    }
  }

  Future<PageResult<NoticeResponse>> _getNoticeList(int index, size) async {
    User user = await mainUser();
    return await user.withAutoLoginOnce(
        (sessionToken) => apiNoticeList(sessionToken, index, size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("通知公告"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemCount: noticeList.length,
          itemBuilder: (context, index) => _buildItem(noticeList[index]),
        ),
      ),
    );
  }

  Widget _buildItem(NoticeResponse notice) => Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  notice.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: SelectableText.rich(
                  _textSpan(
                    notice.content,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  notice.createTime.formatChinaDateTime(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      );

  final RegExp regex = RegExp(r'(https?://[^\s\t\n]+)|(\d{4}\d+)');
  TextSpan _textSpan(String content) {
    Iterable<RegExpMatch> tokens = regex.allMatches(content);
    List<TextSpan> spans = [];
    var cursorPosition = 0;
    for (var token in tokens) {
      if (token.start > cursorPosition) {
        spans.add(TextSpan(
          text: content.substring(cursorPosition, token.start),
        ));
      }
      var span = _detectSymbol(token, content);
      spans.add(span);
      cursorPosition = token.end;
    }
    if (cursorPosition < content.length) {
      spans.add(TextSpan(
        text: content.substring(cursorPosition),
      ));
    }
    return TextSpan(children: spans);
  }

  TextSpan _detectSymbol(RegExpMatch matchResult, String content) {
    var first = content.substring(matchResult.start, matchResult.start + 1);
    if (first == "h") {
      return TextSpan(
        text: content.substring(matchResult.start, matchResult.end),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => loadInBrowser(
              content.substring(matchResult.start, matchResult.end)),
      );
    } else {
      return TextSpan(
        text: content.substring(matchResult.start, matchResult.end),
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Clipboard.setData(ClipboardData(
                text: content.substring(matchResult.start, matchResult.end)));
            showToast("已复制到剪贴板");
          },
      );
    }
  }
}
