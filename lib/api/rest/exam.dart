import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/exam.dart';
import 'package:xhu_timetable_ios/model/page.dart';

Future<PageResult<ExamResponse>> apiExamList(
  String sessionToken,
  int year,
  int term,
  int index,
  int size,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response =
      await dio.get("/api/rest/external/exam/list", queryParameters: {
    "year": year,
    "term": term,
    "index": index,
    "size": size,
  });
  return PageResult.fromJson(response.data, (e) => ExamResponse.fromJson(e));
}
