import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../theme/app_theme.dart';
import '../chats/chats_screen.dart';
import '../create/create_post_screen.dart';
import '../explore/explore_screen.dart';
import '../home/home_feed_screen.dart';
import '../profile/profile_screen.dart';

/// Root of the signed-in experience. Holds the bottom navigation and keeps each
/// tab's state alive with an IndexedStack (so scroll position / filters persist
/// when you switch tabs — part of the "state handling across screens" story).
class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _screens = [
    HomeFeedScreen(),
    ExploreScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Push the signed-in user's missions into the feed so mission-matching works
    // immediately. Done post-frame to avoid notifying during the first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<FeedProvider>().setMyMissions(auth.user!.missions);
      }
    });
  }

  void _openCreate() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: _BottomBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        onCreate: _openCreate,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onCreate;
  const _BottomBar(
      {required this.index, required this.onTap, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.96),
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  active: index == 0,
                  onTap: () => onTap(0)),
              _NavItem(
                  icon: Icons.search_rounded,
                  label: 'Explore',
                  active: index == 1,
                  onTap: () => onTap(1)),
              _CreateButton(onTap: onCreate),
              _NavItem(
                  icon: Icons.chat_bubble_rounded,
                  label: 'Chats',
                  active: index == 2,
                  onTap: () => onTap(2)),
              _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  active: index == 3,
                  onTap: () => onTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.amber : AppColors.textMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: active ? AppColors.amber.withOpacity(0.14) : null,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.amberSoft, AppColors.amber],
          ),
          shape: BoxShape.circle,
          boxShadow: AppDecorations.amberGlow(opacity: 0.45),
        ),
        child: const Icon(Icons.add_rounded, color: Color(0xFF1A1300), size: 28),
      ),
    );
  }
}
