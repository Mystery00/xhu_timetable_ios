import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/custom_thing.dart';
import 'package:xhu_timetable_ios/model/page.dart';

Future<PageResult<CustomThingResponse>> apiCustomThingList(
  String sessionToken,
  int index,
  int size,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response =
      await dio.get("/api/rest/external/thing/custom/list", queryParameters: {
    "index": index,
    "size": size,
  });
  return PageResult.fromJson(
      response.data, (e) => CustomThingResponse.fromJson(e));
}
