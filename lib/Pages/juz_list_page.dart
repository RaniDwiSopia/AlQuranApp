import 'package:flutter/material.dart';
import 'juz_detail_page.dart';

class JuzListPage extends StatelessWidget {
  const JuzListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> juzData = [
      {'name': 'Juz 1', 'firstSurah': 'Al-Fatiha', 'lastSurah': 'Al-Baqarah'},
      {'name': 'Juz 2', 'firstSurah': 'Al-Baqarah', 'lastSurah': 'Ali Imran'},
      {'name': 'Juz 3', 'firstSurah': 'Ali Imran', 'lastSurah': 'An-Nisa'},
      {'name': 'Juz 4', 'firstSurah': 'An-Nisa', 'lastSurah': 'Al-Ma’idah'},
      {'name': 'Juz 5', 'firstSurah': 'Al-Ma’idah', 'lastSurah': 'Al-An’am'},
      {'name': 'Juz 6', 'firstSurah': 'Al-An’am', 'lastSurah': 'Al-A’raf'},
      {'name': 'Juz 7', 'firstSurah': 'Al-A’raf', 'lastSurah': 'Al-Anfal'},
      {'name': 'Juz 8', 'firstSurah': 'Al-Anfal', 'lastSurah': 'At-Tawbah'},
      {'name': 'Juz 9', 'firstSurah': 'At-Tawbah', 'lastSurah': 'Yunus'},
      {'name': 'Juz 10', 'firstSurah': 'Yunus', 'lastSurah': 'Hud'},
      {'name': 'Juz 11', 'firstSurah': 'Hud', 'lastSurah': 'Yusuf'},
      {'name': 'Juz 12', 'firstSurah': 'Yusuf', 'lastSurah': 'Ibrahim'},
      {'name': 'Juz 13', 'firstSurah': 'Ibrahim', 'lastSurah': 'Al-Hijr'},
      {'name': 'Juz 14', 'firstSurah': 'Al-Hijr', 'lastSurah': 'An-Nahl'},
      {'name': 'Juz 15', 'firstSurah': 'An-Nahl', 'lastSurah': 'Al-Isra'},
      {'name': 'Juz 16', 'firstSurah': 'Al-Isra', 'lastSurah': 'Al-Kahf'},
      {'name': 'Juz 17', 'firstSurah': 'Al-Kahf', 'lastSurah': 'Maryam'},
      {'name': 'Juz 18', 'firstSurah': 'Maryam', 'lastSurah': 'Taha'},
      {'name': 'Juz 19', 'firstSurah': 'Taha', 'lastSurah': 'Al-Anbiya'},
      {'name': 'Juz 20', 'firstSurah': 'Al-Anbiya', 'lastSurah': 'Al-Hajj'},
      {'name': 'Juz 21', 'firstSurah': 'Al-Hajj', 'lastSurah': 'Al-Mu’minun'},
      {'name': 'Juz 22', 'firstSurah': 'Al-Mu’minun', 'lastSurah': 'An-Nur'},
      {'name': 'Juz 23', 'firstSurah': 'An-Nur', 'lastSurah': 'Al-Furqan'},
      {'name': 'Juz 24', 'firstSurah': 'Al-Furqan', 'lastSurah': 'Ash-Shu’ara'},
      {'name': 'Juz 25', 'firstSurah': 'Ash-Shu’ara', 'lastSurah': 'An-Naml'},
      {'name': 'Juz 26', 'firstSurah': 'An-Naml', 'lastSurah': 'Al-Ankabut'},
      {'name': 'Juz 27', 'firstSurah': 'Al-Ankabut', 'lastSurah': 'Ar-Rum'},
      {'name': 'Juz 28', 'firstSurah': 'Ar-Rum', 'lastSurah': 'Luqman'},
      {'name': 'Juz 29', 'firstSurah': 'Luqman', 'lastSurah': 'As-Sajda'},
      {'name': 'Juz 30', 'firstSurah': 'As-Sajda', 'lastSurah': 'Al-Ahzab'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Juz'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.white],
          ),
        ),
        child: ListView.builder(
          itemCount: 30,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final juzNumber = index + 1;
            final juzInfo = juzData[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  juzInfo['name'] ?? 'Juz $juzNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  '${juzInfo['firstSurah'] ?? ''} - ${juzInfo['lastSurah'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JuzDetailPage(
                        juzNumber: juzNumber,
                        juzName: juzInfo['name'] ?? 'Juz $juzNumber',
                        firstSurah: juzInfo['firstSurah'] ?? '',
                        lastSurah: juzInfo['lastSurah'] ?? '',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
