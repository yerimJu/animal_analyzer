// Basic Flutter widget test. Learn more at https://flutter.io/docs/testing.

import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('Example app smoke test', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Animal Analyzer Demo'), findsOneWidget);
  });
}