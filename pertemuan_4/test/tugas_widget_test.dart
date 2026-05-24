import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan_4/tugas_pertemuan_4.dart';

void main() {
  testWidgets('Tugas Pertemuan 4 app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify AppBar title is present.
    expect(find.text('Catatan Mahasiswa'), findsOneWidget);

    // Verify initial note and its specific email are present.
    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('Kuliah'), findsOneWidget);
    expect(find.text('Pengirim: fajri@mahasiswa.ac.id'), findsOneWidget);

    // Tap on the FAB to open the Tambah page.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify we are on the Tambah Catatan page and the email form field exists.
    expect(find.text('Tambah Catatan'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email Pengirim'), findsOneWidget);
  });
}
