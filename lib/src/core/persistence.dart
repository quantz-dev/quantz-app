import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _sharedPreferences;
SharedPreferences get sharedPreferences => _sharedPreferences!;

Future<void> initSharedPreferences() async {
  _sharedPreferences = await SharedPreferences.getInstance();
}

Future<bool> persistSave(BuildContext? context, String key, String? value) async {
  var result = await sharedPreferences.setString(key, value ?? '');
  return result;
}

Future<String?> persistGet(
  BuildContext? context,
  String key,
) async {
  var result = sharedPreferences.getString(key);
  return result;
}
