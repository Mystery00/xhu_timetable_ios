import 'package:xhu_timetable_ios/api/server.dart';
import 'package:xhu_timetable_ios/model/page.dart';
import 'package:xhu_timetable_ios/model/score.dart';

Future<PageResult<ScoreResponse>> apiScoreList(
  String sessionToken,
  int year,
  int term,
  int index,
  int size,
) async {
  var dio = getServerClient();
  dio.options.headers['sessionToken'] = sessionToken;
  var response =
      await dio.get("/api/rest/external/score/list", queryParameters: {
    "year": year,
    "term": term,
    "index": index,
    "size": size,
  });
  return PageResult.fromJson(
      response.data, (json) => ScoreResponse.fromJson(json));
}

Future<List<ExperimentScoreResponse>> apiExperimentScore(
  String sessionToken,
  int year,
  int term,
) async {
  var dio = getServerClient();
  dio.options.headers['sessionToken'] = sessionToken;
  var response =
      await dio.get("/api/rest/external/score/experiment", queryParameters: {
    "year": year,
    "term": term,
  });
  return (response.data as List)
      .map((json) => ExperimentScoreResponse.fromJson(json))
      .toList();
}

Future<ScoreGpaResponse> apiScoreGpa(
  String sessionToken,
  int year,
  int term,
) async {
  var dio = getServerClient();
  dio.options.headers['sessionToken'] = sessionToken;
  var response =
      await dio.get("/api/rest/external/score/gpa", queryParameters: {
    "year": year,
    "term": term,
  });
  return ScoreGpaResponse.fromJson(response.data);
}
