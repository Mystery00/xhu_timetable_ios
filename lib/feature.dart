import 'package:device_info_plus/device_info_plus.dart';
import 'package:xhu_timetable_ios/feature_probe/featureprobe.dart';
import 'package:xhu_timetable_ios/feature_probe/user.dart';
import 'package:xhu_timetable_ios/store/app.dart';

FeatureProbe? _fp;
Future<FeatureProbe> _getFeatureProbe() async {
  if (_fp != null) {
    return _fp!;
  }
  var deviceInfo = DeviceInfoPlugin();
  var iosInfo = await deviceInfo.iosInfo;
  var user = FPUser();
  user.stableRolloutKey(iosInfo.identifierForVendor!);
  user.set("deviceId", "ios-${iosInfo.identifierForVendor ?? "unknown"}");
  user.set("systemVersion", "iOS ${iosInfo.systemVersion}");
  user.set("factory", iosInfo.model);
  user.set("model", iosInfo.utsname.machine);
  user.set("rom", iosInfo.isPhysicalDevice ? "Physical" : "Simulator");
  user.set("packageName", getPackageName());
  _fp = FeatureProbe(
      "https://feature.api.mystery0.vip",
      "client-27a2a0787d92993d66680ac75f2fb050859c97d1",
      user,
      60 * 1000,
      10 * 1000);
  await _fp!.start();
  return _fp!;
}

Future<bool> isFeatureJRSC() async {
  var fp = await _getFeatureProbe();
  return fp.boolValue("switch_jinrishici", false);
}

Future<String> getFeatureLoginLabel() async {
  var fp = await _getFeatureProbe();
  return fp.stringValue("data_login_label", "");
}
