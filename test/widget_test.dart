import 'package:alu_connect/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows onboarding when not signed in', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AluConnectApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Intercampus'), findsOneWidget);
    expect(find.text('Sign in with ALU Account'), findsOneWidget);
  });
}
