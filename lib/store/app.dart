import 'package:package_info_plus/package_info_plus.dart';

String _appName = "";
String _packageName = "";
String _version = "";
String _buildNumber = "";

Future<void> initApp() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  _appName = packageInfo.appName;
  _packageName = packageInfo.packageName;
  _version = packageInfo.version;
  _buildNumber = packageInfo.buildNumber;
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
