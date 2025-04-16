import 'package:flutter/material.dart';
import 'package:alquran_app/pages/surah_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurahListPage extends StatefulWidget {
  const SurahListPage({Key? key}) : super(key: key);

  @override
  _SurahListPageState createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  late Future<List<dynamic>> _surahList;
  List<dynamic> _allSurahs = [];
  List<dynamic> _filteredSurahs = [];

  Future<List<dynamic>> fetchSurahList() async {
    final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Gagal memuat daftar surah');
    }
  }

  @override
  void initState() {
    super.initState();
    _surahList = fetchSurahList();
  }

  void filterSurahs(String query) {
    final filtered = _allSurahs.where((surah) {
      final name = surah['name'].toString().toLowerCase();
      final englishName = surah['englishName'].toString().toLowerCase();
      final number = surah['number'].toString();
      return name.contains(query.toLowerCase()) ||
          englishName.contains(query.toLowerCase()) ||
          number.contains(query);
    }).toList();

    setState(() {
      _filteredSurahs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Surah'),
        backgroundColor: Colors.blue[800], // Menambahkan warna pada AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterSurahs,
                decoration: const InputDecoration(
                  hintText: 'Cari Surah atau Nomor...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _surahList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final surahList = snapshot.data!;
                    _allSurahs = surahList;
                    _filteredSurahs = _filteredSurahs.isEmpty ? surahList : _filteredSurahs;

                    return ListView.builder(
                      itemCount: _filteredSurahs.length,
                      itemBuilder: (context, index) {
                        final surah = _filteredSurahs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              title: Text(
                                '${surah['englishName']} (${surah['name']})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                '${surah['englishNameTranslation']} • ${surah['revelationType']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: Text(
                                surah['number'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SurahDetailPage(
                                      surahNumber: surah['number'],
                                      surahName: surah['englishName'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
