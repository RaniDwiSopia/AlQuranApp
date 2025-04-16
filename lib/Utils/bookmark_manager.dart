import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _key = 'bookmarked_surahs';

  static Future<List<int>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(_key);
    if (stored == null) return [];
    return stored.map(int.parse).toList();
  }

  static Future<void> toggleBookmark(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList(_key) ?? [];

    if (stored.contains(surahNumber.toString())) {
      stored.remove(surahNumber.toString());
    } else {
      stored.add(surahNumber.toString());
    }

    await prefs.setStringList(_key, stored);
  }
}