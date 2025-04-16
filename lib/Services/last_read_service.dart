import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LastReadService {
  static const _key = 'lastReadAyah';

  static Future<void> setLastRead(Map<String, dynamic> ayahData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, json.encode(ayahData));
  }

  static Future<Map<String, dynamic>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }
}
