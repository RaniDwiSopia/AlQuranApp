import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import '../services/bookmark_service.dart'; // Import bookmark service
import '../Services/last_read_service.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailPage({
    Key? key,
    required this.surahNumber,
    required this.surahName,
  }) : super(key: key);

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late Future<List<Map<String, dynamic>>> _ayahsWithTranslation;
  List<Map<String, dynamic>> _filteredAyahs = [];
  late AudioPlayer _audioPlayer;
  String selectedQari = 'ar.alafasy';

  final Map<String, String> qariList = {
    'Mishary Alafasy': 'ar.alafasy',
    'Minshawi': 'ar.minshawi',
    'Maher Al-Husary': 'ar.husary',
  };

  Future<List<Map<String, dynamic>>> fetchAyahsWithTranslation() async {
    final response = await http.get(Uri.parse(
        'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/editions/quran-uthmani,id.indonesian'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final arabicAyahs = data[0]['ayahs'];
      final translationAyahs = data[1]['ayahs'];

      List<Map<String, dynamic>> combined = [];
      for (int i = 0; i < arabicAyahs.length; i++) {
        combined.add({
          'number': arabicAyahs[i]['number'],
          'numberInSurah': arabicAyahs[i]['numberInSurah'],
          'arabic': arabicAyahs[i]['text'],
          'translation': translationAyahs[i]['text'],
        });
      }
      return combined;
    } else {
      throw Exception('Failed to load Surah');
    }
  }

  void filterAyahs(String query) {
    setState(() {
      _filteredAyahs = _filteredAyahs.where((ayah) {
        final translation = ayah['translation'].toString().toLowerCase();
        return translation.contains(query.toLowerCase());
      }).toList();
    });
  }

  String convertToArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _ayahsWithTranslation = fetchAyahsWithTranslation();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAyahAudio(int globalAyahNumber) async {
    final audioUrl = 'https://cdn.islamic.network/quran/audio/128/$selectedQari/$globalAyahNumber.mp3';
    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        backgroundColor: Colors.blue[800],
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
                onChanged: filterAyahs,
                decoration: const InputDecoration(
                  hintText: 'Cari Terjemahan...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: DropdownButton<String>(
                value: selectedQari,
                onChanged: (String? newQari) {
                  setState(() {
                    selectedQari = newQari!;
                  });
                },
                isExpanded: true,
                items: qariList.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _ayahsWithTranslation,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final ayahs = snapshot.data!;

                    if (_filteredAyahs.isEmpty) {
                      _filteredAyahs = ayahs;
                    }

                    return ListView.builder(
                      itemCount: _filteredAyahs.length,
                      itemBuilder: (context, index) {
                        final ayah = _filteredAyahs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 12),
                                  Text(
                                    '${ayah['arabic']}  (${convertToArabicNumber(ayah['numberInSurah'])})',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(width: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ayah['translation'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => _playAyahAudio(ayah['number']),
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text("Play Audio"),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            BookmarkService.addBookmark({
                                              'surah': widget.surahNumber,
                                              'surahName': widget.surahName,
                                              'numberInSurah': ayah['numberInSurah'],
                                              'arabic': ayah['arabic'],
                                              'translation': ayah['translation'],
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Ayat dibookmark')),
                                            );
                                          },
                                          icon: const Icon(Icons.bookmark),
                                          label: const Text("Bookmark"),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            LastReadService.setLastRead({
                                              'surah': widget.surahNumber,
                                              'surahName': widget.surahName,
                                              'numberInSurah': ayah['numberInSurah'],
                                              'arabic': ayah['arabic'],
                                              'translation': ayah['translation'],
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Tandai terakhir dibaca')),
                                            );
                                          },
                                          icon: const Icon(Icons.history), // Ikon history untuk Terakhir Dibaca
                                          label: const Text("Tandai Terakhir Dibaca"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
