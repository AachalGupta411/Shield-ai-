import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BadgeVariant { safe, danger, warning, spam, update, autoBlocked }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.variant});

  final String label;
  final BadgeVariant variant;

  Color get _color => switch (variant) {
        BadgeVariant.safe => AppColors.emerald,
        BadgeVariant.danger => AppColors.rose,
        BadgeVariant.warning => AppColors.amber,
        BadgeVariant.spam => AppColors.rose,
        BadgeVariant.update => AppColors.blue,
        BadgeVariant.autoBlocked => AppColors.rose,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
