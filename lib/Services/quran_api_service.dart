import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranApiService {
  // Method untuk mengambil daftar Surah
  static Future<List<dynamic>> getSurahList() async {
    final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load surah list');
    }
  }

  // Method untuk mengambil detail Surah berdasarkan nomor
  static Future<Map<String, dynamic>> getSurahDetail(int surahNumber) async {
    final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/en.asad'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load surah detail');
    }
  }

  // Method untuk mengambil detail Juz berdasarkan nomor dengan API yang benar
  static Future<Map<String, dynamic>> getJuzDetail(int juzNumber) async {
    final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/meta'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      // Mengambil detail Juz berdasarkan nomor (indexing mulai dari 0)
      if (data != null && data.isNotEmpty && juzNumber <= 30) {
        return data[juzNumber - 1];  // Mengambil data sesuai dengan nomor juz
      } else {
        throw Exception('Data Juz tidak ditemukan');
      }
    } else {
      throw Exception('Failed to load juz detail');
    }
  }
}
