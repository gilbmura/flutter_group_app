import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/mock_data.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/communities_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/rsvp_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/app_shell.dart';
import 'theme/app_theme.dart';

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RsvpProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider(MockData.posts())),
        ChangeNotifierProvider(
            create: (_) => ChatProvider(MockData.conversations())),
        ChangeNotifierProvider(create: (_) => CommunitiesProvider()),
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

/// Loads persisted state, then routes to onboarding or the signed-in shell.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    final feed = context.read<FeedProvider>();
    final chat = context.read<ChatProvider>();
    final communities = context.read<CommunitiesProvider>();
    final rsvp = context.read<RsvpProvider>();

    await Future.wait([
      auth.load(),
      feed.load(),
      chat.load(),
      communities.load(MockData.communities()),
      rsvp.load(),
    ]);

    if (auth.user != null) {
      feed.setMyMissions(auth.user!.missions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final feed = context.watch<FeedProvider>();
    final chat = context.watch<ChatProvider>();
    final communities = context.watch<CommunitiesProvider>();

    final ready = auth.loaded &&
        feed.loaded &&
        chat.loaded &&
        communities.loaded;

    if (!ready) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.amber),
        ),
      );
    }
    return auth.isLoggedIn ? const AppShell() : const OnboardingScreen();
  }
}
