import 'package:flutter/material.dart';
import 'pages/home_page.dart';    // Mengimpor HomePage

void main() {
  runApp(const MyApp());  // MyApp dipanggil dengan const
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  // Konstruktor const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),  // HomePage dipanggil dengan const
    );
  }
}
