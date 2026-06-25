import 'package:flutter_test/flutter_test.dart';

import 'package:maroapp/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that SplashScreen is displayed and contains 'Medcare'.
    expect(find.text('Medcare'), findsOneWidget);

    // Let the splash screen timer fire and navigate to clear pending timers.
    await tester.pump(const Duration(seconds: 3));
  });
}
