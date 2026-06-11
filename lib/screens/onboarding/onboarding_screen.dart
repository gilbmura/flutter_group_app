import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/app_user.dart';
import '../../models/campus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

/// Sign-in / onboarding. "Sign in with ALU Account" opens a sheet where the
/// user picks campus, role, and missions — the three things that personalise
/// the rest of the app. Google/Apple are mocked (visual parity with the brief).
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _openSignIn(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SignInSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1A35),
              Color(0xFF080E1C),
              Color(0xFF060A14),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: _GlowOrb(
                size: 260,
                color: AppColors.amber.withOpacity(0.18),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -70,
              child: _GlowOrb(
                size: 200,
                color: AppColors.kigali.withOpacity(0.14),
              ),
            ),
            Positioned(
              top: 140,
              left: 30,
              child: _GlowOrb(
                size: 80,
                color: AppColors.mauritius.withOpacity(0.12),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: AppColors.amber.withOpacity(0.22),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.amber.withOpacity(0.12),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                          const BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const _BrandMark(),
                          const SizedBox(height: 28),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppColors.textPrimary,
                                AppColors.textPrimary,
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'ALU Intercampus',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColors.amberSoft, AppColors.amber],
                            ).createShader(bounds),
                            child: const Text(
                              'Connect',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Text(
                              'Connect. Collaborate. Lead together.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _CampusBadge(
                                label: 'Kigali',
                                color: AppColors.kigali,
                              ),
                              const SizedBox(width: 10),
                              _CampusBadge(
                                label: 'Mauritius',
                                color: AppColors.mauritius,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Sign in with ALU Account',
                      icon: Icons.school_rounded,
                      onPressed: () => _openSignIn(context),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.border,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.border,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _SocialButton(
                          label: 'Google',
                          icon: Icons.g_mobiledata_rounded,
                          accent: const Color(0xFFEA4335),
                          onTap: () => _openSignIn(context),
                        ),
                        const SizedBox(width: 12),
                        _SocialButton(
                          label: 'Apple',
                          icon: Icons.apple_rounded,
                          accent: AppColors.textPrimary,
                          onTap: () => _openSignIn(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => _openSignIn(context),
                      child: const Text.rich(
                        TextSpan(
                          text: 'New here? ',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Create account',
                              style: TextStyle(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class _CampusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _CampusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.amber.withOpacity(0.2),
              width: 2,
            ),
          ),
        ),
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x33F5B301),
                Color(0x14F5B301),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.amber, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.amber.withOpacity(0.35),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.change_history_rounded,
            size: 52,
            color: AppColors.amber,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: accent, size: 22),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInSheet extends StatefulWidget {
  const _SignInSheet();
  @override
  State<_SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<_SignInSheet> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  Campus _campus = Campus.kigali;
  UserRole _role = UserRole.student;
  final Set<String> _missions = {};
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your name to continue.');
      return;
    }
    final missions = _missions.toList();
    await context.read<AuthProvider>().signIn(
          name: _name.text,
          email: _email.text,
          campus: _campus,
          role: _role,
          missions: missions,
        );
    if (mounted) {
      context.read<FeedProvider>().setMyMissions(missions);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(top: 40, bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(
            top: BorderSide(color: AppColors.amber, width: 3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.amberSoft, AppColors.amber],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFF1A1300),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Set up your profile',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Personalise your feed & posts',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _FormSection(
                      icon: Icons.badge_outlined,
                      title: 'About you',
                      child: Column(
                        children: [
                          TextField(
                            controller: _name,
                            decoration: const InputDecoration(
                              hintText: 'Full name',
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'ALU email (optional)',
                              prefixIcon: Icon(
                                Icons.mail_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FormSection(
                      icon: Icons.public_rounded,
                      title: 'Campus',
                      child: Row(
                        children: [
                          Expanded(
                            child: _CampusOption(
                              label: 'Kigali',
                              color: AppColors.kigali,
                              selected: _campus == Campus.kigali,
                              onTap: () =>
                                  setState(() => _campus = Campus.kigali),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _CampusOption(
                              label: 'Mauritius',
                              color: AppColors.mauritius,
                              selected: _campus == Campus.mauritius,
                              onTap: () =>
                                  setState(() => _campus = Campus.mauritius),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FormSection(
                      icon: Icons.work_outline_rounded,
                      title: 'Role',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _RoleOption(
                                  label: 'Student',
                                  icon: Icons.school_rounded,
                                  selected: _role == UserRole.student,
                                  onTap: () =>
                                      setState(() => _role = UserRole.student),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _RoleOption(
                                  label: 'Organizer',
                                  icon: Icons.campaign_rounded,
                                  selected: _role == UserRole.organizer,
                                  onTap: () => setState(
                                      () => _role = UserRole.organizer),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundElevated,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.border.withOpacity(0.8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                  color: _role == UserRole.organizer
                                      ? AppColors.amber
                                      : AppColors.textMuted,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _role == UserRole.organizer
                                        ? 'Organizers can post events & opportunities.'
                                        : 'Students can post community announcements.',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FormSection(
                      icon: Icons.flag_rounded,
                      title: 'Your missions',
                      subtitle: 'Pick what drives you',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MockData.missions.map((m) {
                          final selected = _missions.contains(m);
                          return GestureDetector(
                            onTap: () => setState(() {
                              selected
                                  ? _missions.remove(m)
                                  : _missions.add(m);
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.amber
                                    : AppColors.backgroundElevated,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.amber
                                      : AppColors.border,
                                  width: selected ? 2 : 1,
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.amber
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                m,
                                style: TextStyle(
                                  color: selected
                                      ? const Color(0xFF1A1300)
                                      : AppColors.textPrimary,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.danger.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: AppColors.danger, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: AppColors.danger,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Enter ALU Connect',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;
  const _FormSection({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.amber),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 6),
                Text(
                  '· $subtitle',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _CampusOption extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _CampusOption({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.18) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: selected ? color : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            if (selected) ...[
              const SizedBox(height: 4),
              Icon(Icons.check_circle_rounded, color: color, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.amber.withOpacity(0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.amber : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.amber : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.amber : AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
