import 'package:intl/intl.dart';

import 'app_typedefs.dart';

extension JsonMapExtension on JsonMap {
  String getString(String key) {
    final value = this[key];

    if (value == null) {
      throw "The key \"$key\" not found in the json map";
    }

    if (value is String) {
      return value;
    }

    throw "The value is not a String => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }

  String? getStringOrNull(String key) {
    final value = this[key];

    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    throw "The value is not a String => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }

  int getInt(String key) {
    final value = this[key];

    if (value == null) {
      throw "The key \"$key\" not found in the json map";
    }

    if (value is int) {
      return value;
    }

    if (value is String) {
      try {
        return int.parse(value);
      } catch (_) {
        throw "Parse value to int error => key: \"$key\", value: \"$value\"";
      }
    }

    throw "The value is not an int or int as string => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }

  int? getIntOrNull(String key) {
    final value = this[key];

    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is String) {
      if (value.isEmpty) {
        return null;
      }

      try {
        return int.parse(value);
      } catch (_) {
        throw "Parse value to int error => key: \"$key\", value: \"$value\"";
      }
    }

    throw "The value is not an int or int as string => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }

  double getDouble(String key) {
    final value = this[key];

    if (value == null) {
      throw "The key \"$key\" not found in the json map";
    }

    if (value is double) {
      return value;
    }

    if (value is String) {
      try {
        final result = double.parse(value);
        if (result.isNaN) {
          throw "";
        } else {
          return result;
        }
      } catch (_) {
        throw "Parse value to double error:\nkey: \"$key\"\nvalue: \"$value\"";
      }
    }

    throw "The value is not double or double as string\nkey: \"$key\"\nvalue: \"$value\"\nvalue type: ${value.runtimeType}";
  }

  double? getDoubleOrNull(String key) {
    final value = this[key];

    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is String) {
      if (value.isEmpty) {
        return null;
      }

      try {
        return double.parse(value);
      } catch (_) {
        throw "Parse value to double error => key: \"$key\", value: \"$value\"";
      }
    }

    throw "The value is not double or double as string => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }

  DateTime getDateTime(String key, String pattern) {
    final value = this[key];

    if (value == null) {
      throw "The key \"$key\" not found in the json map";
    }

    if (value is String) {
      try {
        return DateFormat(pattern).parse(value, true);
      } catch (error) {
        throw "DateTime parsing error => key: \"$key\", value: \"$value\", expected pattern: $pattern";
      }
    }

    throw "The value is not an String of DateTime => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }

  DateTime? getDateTimeOrNull(String key, String pattern) {
    final value = this[key];

    if (value == null) {
      return null;
    }

    if (value is String) {
      if (value.isEmpty) {
        return null;
      }

      try {
        return DateFormat(pattern).parse(value, true);
      } catch (error) {
        throw "DateTime parsing error => key: \"$key\", value: \"$value\", expected pattern: $pattern";
      }
    }

    throw "The value is not an String of DateTime => key: \"$key\", value: \"$value\", value type: ${value.runtimeType}";
  }
}

extension DateTimeExtension on DateTime {
  static DateTime parseDDMMYY(String dateString) => DateFormat('dd.MM.yy').parse(dateString);

  static DateTime get empty => DateTime(0);

  String formatString(String Function(DateTime) formatter) => formatter(this);

  String format(String pattern) => DateFormat(pattern).format(this);

  bool isDateIsToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    return date == today;
  }
}
