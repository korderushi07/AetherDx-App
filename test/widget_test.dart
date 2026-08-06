import 'package:flutter_test/flutter_test.dart';

import 'package:aetherdx/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that SplashScreen is displayed and contains 'AetherDx'.
    expect(find.text('AetherDx'), findsOneWidget);

    // Let the splash screen timer fire and navigate to clear pending timers.
    await tester.pump(const Duration(seconds: 3));
  });
}
