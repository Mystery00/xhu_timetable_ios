import 'package:xhu_timetable_ios/api/rest/aggregation.dart';
import 'package:xhu_timetable_ios/model/transfer/aggregation_view.dart';
import 'package:xhu_timetable_ios/model/transfer/today_course_view.dart';
import 'package:xhu_timetable_ios/repository/aggregation_local.dart';
import 'package:xhu_timetable_ios/repository/base_data_repo.dart';
import 'package:xhu_timetable_ios/store/cache_store.dart';
import 'package:xhu_timetable_ios/store/config_store.dart';
import 'package:xhu_timetable_ios/store/user_store.dart';

class AggregationRepo extends BaseDataRepo {
  Future<AggregationView> fetchAggregationMainPage(
    bool forceLoadFromCloud,
    bool forceLoadFromLocal,
    bool showCustomCourse,
    bool showCustomThing,
  ) async {
    checkForceLoadFromCloud(forceLoadFromCloud);
    var nowYear = await getNowYear();
    var nowTerm = await getNowTerm();
    var userList = await requestUserList();

    List<TodayCourseView> todayViewList = [];

    var (loadFromCloud, loadWarning) =
        checkLoadFromCloud(forceLoadFromCloud, forceLoadFromLocal);

    if (loadFromCloud) {
      for (var user in userList) {
        var response =
            await user.withAutoLoginOnce((sessionToken) => apiAggregationMain(
                  sessionToken,
                  nowYear,
                  nowTerm,
                  showCustomCourse,
                  showCustomThing,
                ));
        for (var course in response.courseList) {
          todayViewList.add(TodayCourseView.valueOfCourse(course, user));
        }
        AggregationLocalRepo.saveAggregationMainPageResponse(
            nowYear, nowTerm, user, response);
      }
      setLastSyncCourse(DateTime.now());
    } else {
      for (var user in userList) {
        var response = await AggregationLocalRepo.fetchAggregationMainPage(nowYear, nowTerm, user);
        for (var course in response.courseList) {
          todayViewList.add(TodayCourseView.valueOfCourse(course, user));
        }
      }
    }
    return AggregationView(
        todayViewList: todayViewList, loadWarning: loadWarning);
  }

  (bool, String) checkLoadFromCloud(
    bool forceLoadFromCloud,
    bool forceLoadFromLocal,
  ) {
    bool loadFromCloud;
    if (forceLoadFromCloud) {
      loadFromCloud = true;
    } else if (forceLoadFromLocal) {
      loadFromCloud = false;
    } else {
      loadFromCloud = isOnline();
    }
    var loadWarning = "";
    if (loadFromCloud && !isOnline()) {
      //需要从云端加载，但是网络不可用
      loadFromCloud = false;
      loadWarning = HINT_NETWORK;
    }
    return (loadFromCloud, loadWarning);
  }
}
