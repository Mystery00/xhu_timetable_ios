import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/calendar.dart';

Future<List<SchoolCalendarResponse>> apiSchoolCalendarList(
    String sessionToken) async {
  var dio = getServerClient();
  dio.options.headers['sessionToken'] = sessionToken;
  var response = await dio.get('/api/rest/external/calendar/school/list');
  return (response.data as List)
      .map((e) => SchoolCalendarResponse.fromJson(e))
      .toList();
}
