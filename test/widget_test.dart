import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alquran_app/main.dart';  // Mengimpor main.dart untuk mengakses MyApp

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app dan trigger a frame.
    await tester.pumpWidget(const MyApp());  // Memanggil MyApp dengan const

    // Verifikasi bahwa counter kita mulai dari 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap ikon '+' dan trigger frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi bahwa counter kita telah meningkat.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
