import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/mock_data.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/rsvp_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/app_shell.dart';
import 'theme/app_theme.dart';

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // All providers are created once at the root and shared down the tree.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RsvpProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider(MockData.posts())),
        ChangeNotifierProvider(
            create: (_) => ChatProvider(MockData.conversations())),
      ],
      child: MaterialApp(
        title: 'ALU Intercampus Connect',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const AuthGate(),
      ),
    );
  }
}

/// Decides the first screen: a splash while we load persisted state, then either
/// the onboarding flow or the signed-in app shell. This is where SharedPreferences
/// is read on launch.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<AuthProvider>().load();
      await context.read<RsvpProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.loaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.amber),
        ),
      );
    }
    return auth.isLoggedIn ? const AppShell() : const OnboardingScreen();
  }
}
