import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkService {
  static const String _bookmarkKey = 'bookmarked_ayahs';

  static Future<void> addBookmark(Map<String, dynamic> ayah) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarkKey) ?? [];

    // Hindari duplikat
    if (!bookmarks.contains(json.encode(ayah))) {
      bookmarks.add(json.encode(ayah));
      await prefs.setStringList(_bookmarkKey, bookmarks);
    }
  }

  static Future<void> removeBookmark(Map<String, dynamic> ayah) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarkKey) ?? [];

    bookmarks.remove(json.encode(ayah));
    await prefs.setStringList(_bookmarkKey, bookmarks);
  }

  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarkKey) ?? [];

    return bookmarks.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }
}
