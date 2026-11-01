import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MobileShell extends StatelessWidget {
  const MobileShell({
    super.key,
    required this.child,
    this.bottomNavigationBar,
  });

  final Widget child;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 390, minHeight: 844),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withValues(alpha: 0.15),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const _StatusBar(),
              Expanded(child: child),
              if (bottomNavigationBar != null) bottomNavigationBar!,
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('9:41', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Row(
            children: [
              const Text('5G', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [3.0, 5.0, 7.0, 9.0]
                    .map((h) => Container(
                          width: 3,
                          height: h,
                          margin: const EdgeInsets.only(left: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 10,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: const EdgeInsets.all(1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
