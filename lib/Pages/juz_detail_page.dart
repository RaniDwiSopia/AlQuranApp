import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JuzDetailPage extends StatefulWidget {
  final int juzNumber;
  final String juzName;
  final String firstSurah;
  final String lastSurah;

  const JuzDetailPage({
    Key? key,
    required this.juzNumber,
    required this.juzName,
    required this.firstSurah,
    required this.lastSurah,
  }) : super(key: key);

  @override
  State<JuzDetailPage> createState() => _JuzDetailPageState();
}

class _JuzDetailPageState extends State<JuzDetailPage> {
  late Future<Map<String, dynamic>> juzData;

  Future<Map<String, dynamic>> fetchJuzData() async {
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/juz/${widget.juzNumber}/quran-uthmani'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load juz data');
    }
  }

  @override
  void initState() {
    super.initState();
    juzData = fetchJuzData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.firstSurah} - ${widget.lastSurah}'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: juzData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Data not available'));
            } else {
              final juzInfo = snapshot.data!;
              final ayatList = juzInfo['ayahs'];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: ayatList.length,
                  itemBuilder: (context, index) {
                    final ayat = ayatList[index];
                    final ayatNumberInSurah = ayat['numberInSurah'];
                    final arabicNumber = _convertToArabicNumber(ayatNumberInSurah);

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    arabicNumber,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${ayat['text']} ﴿$arabicNumber﴾',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 2,
                                fontFamily: 'Amiri', // jika tersedia font arab
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  String _convertToArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicDigits[int.parse(digit)])
        .join('');
  }
}
