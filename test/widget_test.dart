import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build a simple mock tree to verify test harness runs and compiles.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('ALU Intercampus Connect'),
        ),
      ),
    ));

    expect(find.text('ALU Intercampus Connect'), findsOneWidget);
  });
}
