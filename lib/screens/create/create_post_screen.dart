import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/mock_data.dart';
import '../../models/app_user.dart';
import '../../models/campus.dart';
import '../../models/post.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

/// Create Post — this is where the "who can post what" decision lives.
/// Students can only publish Announcements; Events/Opportunities are gated to
/// organizers. The gate is enforced both in the type selector and at publish.
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  PostType _type = PostType.announcement;
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController();
  Campus _campus = Campus.kigali;
  bool _hybrid = false;
  DateTime? _start;
  final Set<String> _missions = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    // Organizers default to creating an Event; students to an Announcement.
    if (user != null && user.canPostOpportunities) _type = PostType.event;
    _campus = user?.campus ?? Campus.kigali;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (!mounted) return;
    setState(() {
      _start = DateTime(date.year, date.month, date.day, time?.hour ?? 9,
          time?.minute ?? 0);
    });
  }

  void _publish(AppUser user) {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Give your post a title.');
      return;
    }
    if (_desc.text.trim().isEmpty) {
      setState(() => _error = 'Add a short description so people know more.');
      return;
    }
    if (_type != PostType.announcement && !user.canPostOpportunities) {
      setState(() => _error = 'Only organizers can post events or opportunities.');
      return;
    }
    final post = Post(
      id: const Uuid().v4(),
      type: _type,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      authorName: user.name,
      authorRole: user.role.label,
      campus: _campus,
      isHybrid: _hybrid,
      startTime: _start,
      location: _location.text.trim().isEmpty ? null : _location.text.trim(),
      missions: _missions.toList(),
    );
    context.read<FeedProvider>().addPost(post);
    // Capture the messenger BEFORE popping, otherwise `context` is deactivated.
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Posted to the feed 🎉')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final canPostOpp = user.canPostOpportunities;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Type selector (role-gated).
          Row(
            children: [
              _TypeTab(
                label: 'Event',
                selected: _type == PostType.event,
                locked: !canPostOpp,
                onTap: () => canPostOpp
                    ? setState(() => _type = PostType.event)
                    : _showLocked(),
              ),
              const SizedBox(width: 8),
              _TypeTab(
                label: 'Opportunity',
                selected: _type == PostType.opportunity,
                locked: !canPostOpp,
                onTap: () => canPostOpp
                    ? setState(() => _type = PostType.opportunity)
                    : _showLocked(),
              ),
              const SizedBox(width: 8),
              _TypeTab(
                label: 'Notice',
                selected: _type == PostType.announcement,
                locked: false,
                onTap: () => setState(() => _type = PostType.announcement),
              ),
            ],
          ),
          if (!canPostOpp)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(children: const [
                Icon(Icons.lock_outline, size: 14, color: AppColors.textMuted),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'You\'re posting as a student — you can share announcements. '
                    'Events & opportunities are reserved for organizers.',
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
              ]),
            ),
          const SizedBox(height: 20),
          _label('Title'),
          TextField(
              controller: _title,
              decoration: const InputDecoration(hintText: 'e.g. Leadership Workshop')),
          const SizedBox(height: 16),
          _label('Description'),
          TextField(
            controller: _desc,
            maxLines: 4,
            decoration:
                const InputDecoration(hintText: 'Tell people more...'),
          ),
          const SizedBox(height: 16),
          _label('Campus'),
          SegmentedButton<Campus>(
            segments: const [
              ButtonSegment(value: Campus.kigali, label: Text('Kigali')),
              ButtonSegment(value: Campus.mauritius, label: Text('Mauritius')),
              ButtonSegment(value: Campus.all, label: Text('Both')),
            ],
            selected: {_campus},
            onSelectionChanged: (s) => setState(() => _campus = s.first),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.amber,
            value: _hybrid,
            onChanged: (v) => setState(() => _hybrid = v),
            title: const Text('Allow remote / cross-campus joining'),
            subtitle: const Text('Students on the other campus can RSVP',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ),
          if (_type != PostType.announcement) ...[
            const SizedBox(height: 8),
            _label('Date & Time'),
            InkWell(
              onTap: _pickDateTime,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: AppColors.amber),
                  const SizedBox(width: 10),
                  Text(
                    _start == null
                        ? 'Select date & time'
                        : DateFormat('EEE, MMM d • h:mm a').format(_start!),
                    style: TextStyle(
                        color: _start == null
                            ? AppColors.textMuted
                            : AppColors.textPrimary),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            _label('Location'),
            TextField(
                controller: _location,
                decoration:
                    const InputDecoration(hintText: 'e.g. Innovation Lab')),
          ],
          const SizedBox(height: 16),
          _label('Linked missions'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockData.missions.map((m) {
              final sel = _missions.contains(m);
              return FilterChip(
                label: Text(m),
                selected: sel,
                onSelected: (_) => setState(
                    () => sel ? _missions.remove(m) : _missions.add(m)),
                selectedColor: AppColors.amber,
                backgroundColor: AppColors.surfaceAlt,
                labelStyle: TextStyle(
                    color: sel
                        ? const Color(0xFF1A1300)
                        : AppColors.textPrimary),
                checkmarkColor: const Color(0xFF1A1300),
                side: const BorderSide(color: AppColors.border),
              );
            }).toList(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: 24),
          PrimaryButton(label: 'Publish', onPressed: () => _publish(user)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLocked() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Only organizers can post events & opportunities.')),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}

class _TypeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;
  const _TypeTab(
      {required this.label,
      required this.selected,
      required this.locked,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.amber : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
                color: selected ? AppColors.amber : AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (locked)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.lock,
                      size: 13,
                      color: selected
                          ? const Color(0xFF1A1300)
                          : AppColors.textMuted),
                ),
              Text(label,
                  style: TextStyle(
                      color: selected
                          ? const Color(0xFF1A1300)
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
