import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/score_ring.dart';
import '../widgets/status_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning,', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      Text(
                        '${user?.name ?? 'Arjun Sharma'} 👋',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/alerts'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.notifications_outlined, color: Color(0xFFD1D5DB), size: 22),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 16,
                            height: 16,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: AppColors.rose, shape: BoxShape.circle),
                            child: const Text('3', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ScoreCard(),
              const SizedBox(height: 20),
              _QuickActions(),
              const SizedBox(height: 24),
              _RiskLevelCard(),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Recent Activity', action: 'See all', onAction: () => context.go('/alerts')),
              const SizedBox(height: 12),
              ..._activities.map((a) => _ActivityTile(data: a)),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Scam Alerts Near You', action: 'More'),
              const SizedBox(height: 12),
              ..._scamAlerts.map((a) => _ScamAlertTile(data: a)),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () => context.go('/scan'),
            backgroundColor: AppColors.purple,
            elevation: 8,
            child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradientScore,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI SECURITY SCORE',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: AppColors.blue),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('87', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('Excellent Protection', style: TextStyle(color: AppColors.emerald, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Last scan: 2 minutes ago', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              const ScoreRing(score: 87),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatCol(value: '23', label: 'Blocked', color: AppColors.rose),
              _StatCol(value: '156', label: 'Scanned', color: AppColors.blue),
              _StatCol(value: '133', label: 'Safe', color: AppColors.emerald),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({required this.value, required this.label, required this.color});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  static const _actions = [
    (Icons.qr_code_scanner, 'Scan QR', AppColors.blue, '/scan'),
    (Icons.credit_card, 'Check UPI', AppColors.purple, '/scan?tab=upi'),
    (Icons.phone, 'Phone', AppColors.yellow, '/scan?tab=phone'),
    (Icons.warning_amber_rounded, 'Report', AppColors.rose, '/alerts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _actions.map((a) {
        return Expanded(
          child: GestureDetector(
            onTap: () => context.go(a.$4),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(a.$1, color: a.$3, size: 22),
                  const SizedBox(height: 8),
                  Text(a.$2, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: a.$3)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RiskLevelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today\'s Risk Level', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)),
              StatusBadge(label: 'Low', variant: BadgeVariant.safe),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.22,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: const AlwaysStoppedAnimation(AppColors.emerald),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Low', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              Text('Medium', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              Text('High', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action, this.onAction});

  final String title;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)),
        GestureDetector(
          onTap: onAction,
          child: Text(action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.blue)),
        ),
      ],
    );
  }
}

class _ActivityData {
  const _ActivityData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.badge,
    this.amount,
    this.sub,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final BadgeVariant badge;
  final String? amount;
  final String? sub;
}

const _activities = [
  _ActivityData(icon: Icons.check_circle_outline, iconColor: AppColors.emerald, title: 'Payment to Swiggy verified', time: '2m ago', amount: '₹249', badge: BadgeVariant.safe),
  _ActivityData(icon: Icons.cancel_outlined, iconColor: AppColors.rose, title: 'Phishing SMS blocked', time: '14m ago', sub: 'VM-HDFC', badge: BadgeVariant.danger),
  _ActivityData(icon: Icons.warning_amber_rounded, iconColor: AppColors.amber, title: 'Unknown QR code detec...', time: '1h ago', sub: 'Scanner', badge: BadgeVariant.warning),
  _ActivityData(icon: Icons.check_circle_outline, iconColor: AppColors.emerald, title: 'UPI verified: zomato@okaxis', time: '2h ago', amount: '₹399', badge: BadgeVariant.safe),
];

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.data});

  final _ActivityData data;

  String get _badgeLabel => switch (data.badge) {
        BadgeVariant.safe => 'Safe',
        BadgeVariant.danger => 'Danger',
        _ => 'Warning',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(data.icon, color: data.iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(data.time, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (data.amount != null) Text(data.amount!, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
              if (data.sub != null) Text(data.sub!, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              StatusBadge(label: _badgeLabel, variant: data.badge),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScamAlertData {
  const _ScamAlertData({required this.title, required this.time, required this.badge});
  final String title;
  final String time;
  final BadgeVariant badge;
}

const _scamAlerts = [
  _ScamAlertData(title: 'New KYC phishing campaign targeting HDFC users', time: '1h ago', badge: BadgeVariant.danger),
  _ScamAlertData(title: 'Fake Flipkart QR codes circulating in Delhi NCR', time: '3h ago', badge: BadgeVariant.warning),
];

class _ScamAlertTile extends StatelessWidget {
  const _ScamAlertTile({required this.data});
  final _ScamAlertData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(data.title, style: const TextStyle(color: Colors.white, fontSize: 14))),
              StatusBadge(
                label: data.badge == BadgeVariant.danger ? 'Danger' : 'Warning',
                variant: data.badge,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(data.time, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
