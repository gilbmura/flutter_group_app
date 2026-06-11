import 'package:flutter/material.dart';
import '../models/campus.dart';
import '../theme/app_theme.dart';

/// Small coloured badge that makes a post's campus instantly readable, with a
/// "Hybrid" variant for cross-campus joinable posts.
class CampusChip extends StatelessWidget {
  final Campus campus;
  final bool hybrid;
  const CampusChip({super.key, required this.campus, this.hybrid = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: campus.color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 12, color: campus.color),
              const SizedBox(width: 4),
              Text(
                campus.label,
                style: TextStyle(
                  color: campus.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (hybrid) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi, size: 12, color: AppColors.amber),
                SizedBox(width: 4),
                Text('Hybrid',
                    style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
