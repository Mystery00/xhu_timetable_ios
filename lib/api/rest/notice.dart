import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/notice.dart';
import 'package:xhu_timetable_ios/model/page.dart';

Future<PageResult<NoticeResponse>> apiNoticeList(
  String sessionToken,
  int index,
  int size,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response =
      await dio.get("/api/rest/external/notice/list", queryParameters: {
    "platform": "IOS",
    "index": index,
    "size": size,
  });
  return PageResult.fromJson(response.data, (e) => NoticeResponse.fromJson(e));
}
