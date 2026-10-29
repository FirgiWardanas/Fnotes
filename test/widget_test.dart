import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note/main.dart';

void main() {
  testWidgets('Boot splash and navigate to login screen test', (WidgetTester tester) async {
    // Set realistic mobile phone screen size for test
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FNotesApp());

    expect(find.text('FNotes'), findsOneWidget);
    expect(find.text('Cepat & Ringan'), findsOneWidget);

    // Fast forward splash timer (2.2s)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify Login Screen appears
    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
    expect(find.text('Masuk ke Akun'), findsOneWidget);

    // Test Validation: tap login with empty fields
    await tester.tap(find.text('Masuk ke Akun'));
    await tester.pump();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi'), findsOneWidget);

    // Test Filling valid input
    await tester.enterText(find.byType(TextFormField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.pump();

    await tester.tap(find.text('Masuk ke Akun'));
    await tester.pump();

    // Verify loading indicator appears
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for simulation delay
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Berhasil masuk sebagai user@example.com'), findsOneWidget);
  });
}
