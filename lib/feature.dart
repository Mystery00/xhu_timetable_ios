import 'package:device_info_plus/device_info_plus.dart';
import 'package:featurehub_client_sdk/featurehub.dart';
import 'package:featurehub_client_api/api.dart';
import 'package:logger/logger.dart';
import 'package:xhu_timetable_ios/store/app.dart';

ClientFeatureRepository? _fh;
Future<ClientFeatureRepository> _getFeatureHub() async {
  if (_fh != null) {
    return _fh!;
  }
  var deviceInfo = DeviceInfoPlugin();
  var iosInfo = await deviceInfo.iosInfo;
  var repository = ClientFeatureRepository();
  repository.readynessStream.listen((readyness) {
    Logger().i("ready: $readyness");
  });
  var fhConfig = FeatureHubConfig(
      'https://fh.api.mystery0.vip',
      [
        '65041db9-520c-4962-a512-34fd055abeae/FuNl49rsVbbysKoLtxUxZS3JbPz46e8Kfs2vB9fv'
      ],
      repository);
  repository.clientContext
      .userKey("${iosInfo.identifierForVendor}")
      .attr('deviceId', "ios-${iosInfo.identifierForVendor ?? "unknown"}")
      .attr('systemVersion', "iOS ${iosInfo.systemVersion}")
      .attr("factory", iosInfo.model)
      .attr("model", iosInfo.utsname.machine)
      .attr("rom", iosInfo.isPhysicalDevice ? "Physical" : "Simulator")
      .attr("packageName", getPackageName())
      .attr('versionName', getVersion())
      .attr('versionCode', getBuildNumber())
      .device(StrategyAttributeDeviceName.mobile)
      .platform(StrategyAttributePlatformName.ios)
      .version("${getVersion()}-${getBuildNumber()}");
  await fhConfig.request();
  _fh = repository;
  return repository;
}

Future<bool> isFeatureJRSC() async {
  var fh = await _getFeatureHub();
  var f = fh.feature("switch_jinrishici");
  if (!f.exists || f.booleanValue == null) return false;
  return f.booleanValue!;
}

Future<String> getFeatureLoginLabel() async {
  var fh = await _getFeatureHub();
  var f = fh.feature("data_login_label");
  if (!f.exists || f.stringValue == null) return "";
  return f.stringValue!;
}
