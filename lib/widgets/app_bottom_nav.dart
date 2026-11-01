import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = ['/home', '/scan', '/sms', '/alerts', '/profile'];
  static const _labels = ['Home', 'Scan', 'SMS', 'Alerts', 'Profile'];
  static const _icons = [
    Icons.home_outlined,
    Icons.qr_code_scanner_outlined,
    Icons.message_outlined,
    Icons.notifications_outlined,
    Icons.person_outline,
  ];
  static const _activeIcons = [
    Icons.home,
    Icons.qr_code_scanner,
    Icons.message,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.bg,
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (i) {
          final active = currentIndex == i;
          return GestureDetector(
            onTap: () => context.go(_routes[i]),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    active ? _activeIcons[i] : _icons[i],
                    size: 22,
                    color: active ? AppColors.blue : AppColors.textMuted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[i],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: active ? AppColors.blue : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
