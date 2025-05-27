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

Future<bool> apiCreateCustomThing(
  String sessionToken,
  CustomThingRequest request,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response =
      await dio.post("/api/rest/external/thing/custom", data: request.toJson());
  return response.data;
}

Future<bool> apiUpdateCustomThing(
  String sessionToken,
  int thingId,
  CustomThingRequest request,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response =
      await dio.put("/api/rest/external/thing/custom?id=$thingId", data: request.toJson());
  return response.data;
}

Future<bool> apiDeleteCustomThing(
  String sessionToken,
  int thingId,
) async {
  var dio = getServerClient();
  dio.options.headers["sessionToken"] = sessionToken;
  var response =
      await dio.delete("/api/rest/external/thing/custom?id=$thingId");
  return response.data;
}
