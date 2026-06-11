import 'package:flutter_test/flutter_test.dart';

import 'package:alu_connect/app.dart';

void main() {
  testWidgets('shows onboarding on first launch', (WidgetTester tester) async {
    await tester.pumpWidget(const AluConnectApp());
    await tester.pumpAndSettle();

    expect(find.text('ALU Intercampus'), findsOneWidget);
    expect(find.text('Connect'), findsWidgets);
    expect(find.text('Sign in with ALU Account'), findsOneWidget);
  });
}
