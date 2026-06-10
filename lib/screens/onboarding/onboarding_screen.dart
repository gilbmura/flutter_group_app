import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/app_user.dart';
import '../../models/campus.dart';
import '../../providers/auth_provider.dart';
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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _SignInSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _BrandMark(),
              const SizedBox(height: 24),
              const Text('ALU Intercampus',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              const Text('Connect',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.amber)),
              const SizedBox(height: 12),
              const Text('Connect. Collaborate. Lead together.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Sign in with ALU Account',
                icon: Icons.school,
                onPressed: () => _openSignIn(context),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Expanded(child: Divider(color: AppColors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
                const Expanded(child: Divider(color: AppColors.border)),
              ]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata,
                      onTap: () => _openSignIn(context)),
                  const SizedBox(width: 16),
                  _SocialButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      onTap: () => _openSignIn(context)),
                ],
              ),
              const SizedBox(height: 28),
              TextButton(
                onPressed: () => _openSignIn(context),
                child: const Text.rich(TextSpan(
                  text: 'New here? ',
                  style: TextStyle(color: AppColors.textMuted),
                  children: [
                    TextSpan(
                        text: 'Create account',
                        style: TextStyle(
                            color: AppColors.amber,
                            fontWeight: FontWeight.w700)),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(Icons.change_history, size: 48, color: AppColors.amber),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textPrimary),
        label: Text(label,
            style: const TextStyle(color: AppColors.textPrimary)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md)),
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
    await context.read<AuthProvider>().signIn(
          name: _name.text,
          email: _email.text,
          campus: _campus,
          role: _role,
          missions: _missions.toList(),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Set up your profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('This personalises your feed and what you can post.',
                style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              decoration: const InputDecoration(hintText: 'Full name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'ALU email (optional)'),
            ),
            const SizedBox(height: 18),
            const Text('Campus', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SegmentedButton<Campus>(
              segments: const [
                ButtonSegment(value: Campus.kigali, label: Text('Kigali')),
                ButtonSegment(
                    value: Campus.mauritius, label: Text('Mauritius')),
              ],
              selected: {_campus},
              onSelectionChanged: (s) => setState(() => _campus = s.first),
            ),
            const SizedBox(height: 18),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SegmentedButton<UserRole>(
              segments: const [
                ButtonSegment(value: UserRole.student, label: Text('Student')),
                ButtonSegment(
                    value: UserRole.organizer, label: Text('Organizer')),
              ],
              selected: {_role},
              onSelectionChanged: (s) => setState(() => _role = s.first),
            ),
            const SizedBox(height: 6),
            Text(
              _role == UserRole.organizer
                  ? 'Organizers can post events & opportunities.'
                  : 'Students can post community announcements.',
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            const Text('Your missions',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MockData.missions.map((m) {
                final selected = _missions.contains(m);
                return FilterChip(
                  label: Text(m),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    selected ? _missions.remove(m) : _missions.add(m);
                  }),
                  selectedColor: AppColors.amber,
                  backgroundColor: AppColors.surfaceAlt,
                  labelStyle: TextStyle(
                    color: selected
                        ? const Color(0xFF1A1300)
                        : AppColors.textPrimary,
                  ),
                  checkmarkColor: const Color(0xFF1A1300),
                  side: const BorderSide(color: AppColors.border),
                );
              }).toList(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
            const SizedBox(height: 22),
            PrimaryButton(label: 'Enter ALU Connect', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
