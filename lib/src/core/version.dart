import 'package:package_info_plus/package_info_plus.dart';

String _version = '';
String get appVersion => _version;

Future<void> checkAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  _version = packageInfo.version;
}
