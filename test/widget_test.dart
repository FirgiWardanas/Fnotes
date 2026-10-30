import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note/main.dart';

void main() {
  testWidgets('Full flow: Splash -> Login -> Home -> Add Note Page -> Save', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FNotesApp());

    // 1. Splash Screen
    expect(find.text('FNotes'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 2. Login Screen
    expect(find.text('Selamat Datang Kembali'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.pump();

    await tester.tap(find.text('Masuk ke Akun'));
    await tester.pump();

    // Settle login delay & navigation to HomeScreen
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 3. Home Screen
    expect(find.text('Halo, Pengguna ✨'), findsOneWidget);
    expect(find.text('Catatan Baru'), findsOneWidget);

    // Test time filter tabs (Hari Ini vs Semua)
    await tester.tap(find.text('Hari Ini'));
    await tester.pumpAndSettle();
    expect(find.text('Rencana Aplikasi Mobile'), findsOneWidget);
    expect(find.text('Analisis Algoritma Machine Learning (Tugas 4)'), findsNothing);

    // Switch back to Semua
    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();
    expect(find.text('Analisis Algoritma Machine Learning (Tugas 4)'), findsOneWidget);

    // Test Category Filter ('Tugas Kuliah' chip)
    await tester.tap(find.text('Tugas Kuliah').first);
    await tester.pumpAndSettle();
    expect(find.text('Rencana Aplikasi Mobile'), findsOneWidget);
    expect(find.text('Finalisasi Pitch Deck Q4 & Peluncuran MVP'), findsNothing);

    // Switch back to Semua Kategori
    await tester.tap(find.text('Semua Kategori'));
    await tester.pumpAndSettle();
    expect(find.text('Finalisasi Pitch Deck Q4 & Peluncuran MVP'), findsOneWidget);

    // 4. Tap FAB to redirect to AddNoteScreen page
    await tester.tap(find.text('Catatan Baru'));
    await tester.pumpAndSettle();

    // Verify on Add Note page (not bottom sheet)
    expect(find.text('Tambah Catatan'), findsOneWidget);
    expect(find.text('Isi Catatan'), findsOneWidget);

    // Open more menu and verify option exists (no-op on tap)
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Tambah gambar / media'), findsOneWidget);
    await tester.tap(find.text('Tambah gambar / media'));
    await tester.pumpAndSettle();

    // Fill new note
    await tester.enterText(find.byType(TextField).at(0), 'Catatan Praktikum Flutter');
    await tester.enterText(find.byType(TextField).at(1), 'Implementasi halaman tambah catatan baru.');
    await tester.pump();

    // Tap save (check icon inside circular container)
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    // Verify redirected back to HomeScreen
    expect(find.text('Halo, Pengguna ✨'), findsOneWidget);

    // 5. Tap existing note card to navigate to DetailNoteScreen
    await tester.ensureVisible(find.text('Rencana Aplikasi Mobile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rencana Aplikasi Mobile'));
    await tester.pumpAndSettle();

    // Verify Detail Note Screen elements
    expect(find.text('Detail Catatan'), findsOneWidget);
    expect(find.text('Rencana Aplikasi Mobile'), findsOneWidget);

    // Test Edit flow via pencil button -> redirects to AddNoteScreen in edit mode
    await tester.tap(find.byTooltip('Ubah Catatan'));
    await tester.pumpAndSettle();
    expect(find.text('Ubah Catatan'), findsOneWidget);
    expect(find.text('Rencana Aplikasi Mobile'), findsOneWidget);

    // Update title and tap save (pure UI simulation)
    await tester.enterText(find.byType(TextField).at(0), 'Rencana Aplikasi Mobile (Draft)');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    // Verify back on DetailNoteScreen
    expect(find.text('Detail Catatan'), findsOneWidget);

    // Test Delete Dialog flow
    await tester.tap(find.byTooltip('Hapus Catatan'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus Catatan Ini?'), findsOneWidget);

    // Confirm Delete
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    // Verify redirected to Home and note is removed
    expect(find.text('Halo, Pengguna ✨'), findsOneWidget);
    expect(find.text('Rencana Aplikasi Mobile'), findsNothing);
  });
}
