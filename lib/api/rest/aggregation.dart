import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/aggregation.dart';

Future<AggregationMainResponse> apiAggregationMain(
  String sessionToken,
  int year,
  int term,
  bool showCustomCourse,
  bool showCustomThing,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response = await dio
      .get("/api/rest/external/aggregation/page/main", queryParameters: {
    "year": year,
    "term": term,
    "showCustomCourse": showCustomCourse,
    "showCustomThing": showCustomThing,
  });
  return AggregationMainResponse.fromJson(response.data);
}
