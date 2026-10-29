import 'package:flutter_test/flutter_test.dart';
import 'package:note/main.dart';

void main() {
  testWidgets('FNotesApp boots into SplashScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FNotesApp());

    expect(find.text('FNotes'), findsOneWidget);
    expect(find.text('Cepat & Ringan'), findsOneWidget);
    expect(find.text('Tersimpan Aman'), findsOneWidget);
    expect(find.text('Terorganisir Rapi'), findsOneWidget);
  });
}
