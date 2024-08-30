import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_typedefs.dart';

class SpManager {
  final SharedPreferences _prefs;

  static Future<SpManager> createInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SpManager._(prefs);
  }

  const SpManager._(this._prefs);

  JsonMap readJson(String key) => _decodeJson(_prefs.getString(key), "readJson", key);

  Future<bool> writeJson(String key, JsonMap jsonMap) => _prefs.setString(key, json.encode(jsonMap));

  List<JsonMap> readJsonList(String key) {
    final stringList = _prefs.getStringList(key);
    return stringList == null
        ? []
        : stringList.map((item) => _decodeJson(item, "readJsonList", key)).toList(growable: false);
  }

  Future<bool> writeJsonList(String key, List<JsonMap> jsonList) {
     final stringList = jsonList.map((item) => json.encode(item)).toList(growable: false);
    return _prefs.setStringList(key, stringList);
  }

  JsonMap _decodeJson(String? value, String methodName, String key) {
    try {
      return value == null ? null : json.decode(value);
    } catch (_) {
      throw "SPManager $methodName() error => key: $key, value: $value is not valid json string";
    }
  }
}
