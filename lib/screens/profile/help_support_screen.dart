import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();
  String _category = 'Technical Issue';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How does cross-campus RSVP work?',
      'answer': 'If an event is marked as Hybrid, students on either campus can attend. Simply click "RSVP" to let the organizers know you are joining, and you will see the online link details.',
    },
    {
      'question': 'How do I start a new community or club?',
      'answer': 'To start a community, navigate to the "Explore" or "Home" tab, click the "+" button, select "Community", fill out the registration form, and submit. The Student Life office will review your request.',
    },
    {
      'question': 'Can I message students from the other campus?',
      'answer': 'Absolutely! The "Chats" tab search supports finding students across both Kigali and Mauritius campuses to enable cross-campus collaboration.',
    },
    {
      'question': 'How do I change my campus or missions?',
      'answer': 'Go to the Profile screen and tap the Settings gear icon in the top right. There you can change your active campus and select which ALU Grand Challenges/missions you are pursuing.',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Show success modal
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.success, size: 28),
              SizedBox(width: 10),
              Text('Ticket Submitted', style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thank you for reaching out! Our support team will respond to ${_emailController.text} shortly.',
                style: const TextStyle(color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 12),
              Text('Category: $_category', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(this.context).pop(); // Go back to profile screen
              },
              child: const Text('Done', style: TextStyle(color: AppColors.amber, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

      // Clear the inputs
      _messageController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.amber),
          ),
          const SizedBox(height: 12),
          ..._faqs.map((faq) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    iconColor: AppColors.amber,
                    collapsedIconColor: AppColors.textMuted,
                    children: [
                      Text(
                        faq['answer']!,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),
          const Text(
            'Contact Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.amber),
          ),
          const SizedBox(height: 6),
          const Text(
            'Submit a ticket and our support agents will respond to you.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    dropdownColor: AppColors.surfaceAlt,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['Technical Issue', 'Campus Inquiry', 'Event Suggestion', 'Other']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _category = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Your Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'e.g. student@alu.edu',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('How can we help?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Describe your issue or feedback in detail...',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Message content cannot be empty';
                      }
                      if (val.trim().length < 10) {
                        return 'Please explain in at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Submit Ticket',
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Links & Resources',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.amber),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book, color: AppColors.amber),
                  title: const Text('ALU Student Handbook', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.arrow_outward, size: 16, color: AppColors.textMuted),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening ALU Student Handbook link...')),
                    );
                  },
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  leading: const Icon(Icons.gavel, color: AppColors.amber),
                  title: const Text('Community Guidelines', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.arrow_outward, size: 16, color: AppColors.textMuted),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Community Guidelines...')),
                    );
                  },
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  leading: const Icon(Icons.security, color: AppColors.amber),
                  title: const Text('Campus Safety & Contacts', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.arrow_outward, size: 16, color: AppColors.textMuted),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Safety Contacts...')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
