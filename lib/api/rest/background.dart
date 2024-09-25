import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/background.dart';

Future<List<BackgroundResponse>> apiBackgroundList(String sessionToken) async {
  var dio = getServerClient();
  dio.options.headers['sessionToken'] = sessionToken;
  var response = await dio.get('/api/rest/external/background/list');
  return (response.data as List)
      .map((e) => BackgroundResponse.fromJson(e))
      .toList();
}
