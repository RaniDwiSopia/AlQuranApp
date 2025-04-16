import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, dynamic>> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('bookmarked_ayahs'); // Perbaikan di sini
    if (saved != null) {
      setState(() {
        bookmarks = saved.map((b) => json.decode(b) as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _removeBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarks.removeAt(index);
    });
    final updated = bookmarks.map((b) => json.encode(b)).toList();
    await prefs.setStringList('bookmarks', updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
      ),
      body: bookmarks.isEmpty
          ? const Center(child: Text('Belum ada bookmark'))
          : ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final item = bookmarks[index];
          return ListTile(
            title: Text('Surah ${item['surahName']} - Ayat ${item['numberInSurah']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['arabic'],
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  item['translation'],
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeBookmark(index),
            ),
          );

        },
      ),
    );
  }
}
