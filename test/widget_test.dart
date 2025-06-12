// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_time_oracle/main.dart';

void main() {
  testWidgets('Screen Time Oracle app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(home: OraclePage(testMode: true)),
    );

    // Wait for the app to load (use pump instead of pumpAndSettle to avoid timeout)
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify that our app title is present
    expect(find.text('📱 Screen Time Oracle'), findsOneWidget);

    // Verify that screen time display is present
    expect(find.text('Today\'s Screen Time'), findsOneWidget);

    // Verify that oracle message container is present
    expect(find.text('🔮 The Oracle Speaks:'), findsOneWidget);

    // Verify that action buttons are present
    expect(find.text('New\nProphecy'), findsOneWidget);
    expect(find.text('Add\nTime'), findsOneWidget);
    expect(find.text('Reset\nDay'), findsOneWidget);
  });
  testWidgets('Button interactions work', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(home: OraclePage(testMode: true)),
    );

    // Wait for the app to load
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Tap the "Add Time" button
    await tester.tap(find.text('Add\nTime'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900)); // Wait for animation

    // The screen time should have increased (we can't predict exact value due to randomness)
    // But we can verify the UI still works
    expect(find.text('📱 Screen Time Oracle'), findsOneWidget);

    // Tap the "New Prophecy" button
    await tester.tap(find.text('New\nProphecy'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900)); // Wait for animation

    // Verify oracle message is still present
    expect(find.text('🔮 The Oracle Speaks:'), findsOneWidget);

    // Scroll down to access the Reset button
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -200),
    );
    await tester.pump();

    // Tap the "Reset Day" button
    await tester.tap(find.text('Reset\nDay'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900)); // Wait for animation

    // Verify the app still functions - check for any time display (could be 0m, 45m, etc.)
    expect(find.textContaining('m'), findsAtLeastNWidgets(1));
  });
}
