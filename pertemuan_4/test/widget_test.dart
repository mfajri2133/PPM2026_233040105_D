import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan_4/latihan.dart';

void main() {
  testWidgets('Catatan Mahasiswa app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title of the AppBar is present.
    expect(find.text('Catatan Mahasiswa'), findsOneWidget);

    // Verify that the initial dummy note is shown.
    expect(find.text('Belajar Flutter'), findsOneWidget);
    expect(find.text('Kuliah'), findsOneWidget);

    // Tap on the FAB to open the Add Note page.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that we are on the Tambah Catatan page.
    expect(find.text('Tambah Catatan'), findsOneWidget);
  });
}
