import 'package:flutter_test/flutter_test.dart';
import 'package:note/main.dart';

void main() {
  testWidgets('FNotesApp boots into SplashScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FNotesApp());

    expect(find.text('FNotes'), findsOneWidget);
    expect(find.text('Cepat & Ringan'), findsOneWidget);

    // Fast-forward pending timer to transition to /login
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Selamat Datang'), findsOneWidget);
  });
}
