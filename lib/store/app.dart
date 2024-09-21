import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

bool _isDebug = false;

DateTime initTermStartDate = DateTime(2024, 9, 2, 0, 0, 0);
int initNowYear = 2024;
int initNowTerm = 1;

String _appName = "";
String _packageName = "";
String _version = "";
String _buildNumber = "";
String _deviceId = "";

Future<void> initApp() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  _appName = packageInfo.appName;
  _packageName = packageInfo.packageName;
  _version = packageInfo.version;
  _buildNumber = packageInfo.buildNumber;
  var deviceInfo = DeviceInfoPlugin();
  var iosInfo = await deviceInfo.iosInfo;
  _deviceId = "ios-${iosInfo.identifierForVendor ?? "unknown"}";
  if (!iosInfo.isPhysicalDevice) {
    _isDebug = true;
    _deviceId = "debug";
  }
}

bool isDebug() {
  return _isDebug;
}

String getAppName() {
  return _appName;
}

String getPackageName() {
  return _packageName;
}

String getVersion() {
  return _version;
}

String getBuildNumber() {
  return _buildNumber;
}

String getDeviceId() {
  return _deviceId;
}
