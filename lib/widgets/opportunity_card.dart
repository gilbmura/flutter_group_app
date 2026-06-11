import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../theme/app_theme.dart';
import 'campus_chip.dart';

/// The single card used to render any feed item. Adapts its accent and meta
/// row to the post type. Reused on Home, Explore, and My RSVPs so the look is
/// identical everywhere (DRY).
class OpportunityCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final bool compact;
  const OpportunityCard({
    super.key,
    required this.post,
    required this.onTap,
    this.compact = false,
  });

  Color get _accent {
    switch (post.type) {
      case PostType.event:
        return AppColors.amber;
      case PostType.opportunity:
        return AppColors.kigali;
      case PostType.announcement:
        return AppColors.mauritius;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = post.startTime != null
        ? DateFormat('MMM d • h:mm a').format(post.startTime!)
        : (post.applyBy ?? 'Ongoing');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.md)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(post.type.label,
                                style: TextStyle(
                                    color: _accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const Spacer(),
                          Text(dateStr,
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(post.authorName,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      const SizedBox(height: 10),
                      CampusChip(campus: post.campus, hybrid: post.isHybrid),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
