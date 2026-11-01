import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/status_badge.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late List<_AlertData> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = List.of(_initialAlerts);
  }

  void _markAllRead() {
    setState(() => _alerts = _alerts.map((a) => a.copyWith(read: true)).toList());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All alerts marked as read')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Alert Center', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              GestureDetector(
                onTap: _markAllRead,
                child: const Text('Mark all read', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._alerts.map((a) => _AlertTile(alert: a)),
        ],
      ),
    );
  }
}

class _AlertData {
  const _AlertData({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.badge,
    required this.badgeLabel,
    required this.desc,
    required this.time,
    this.read = false,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final BadgeVariant badge;
  final String badgeLabel;
  final String desc;
  final String time;
  final bool read;

  _AlertData copyWith({bool? read}) => _AlertData(
        icon: icon,
        iconBg: iconBg,
        iconColor: iconColor,
        title: title,
        badge: badge,
        badgeLabel: badgeLabel,
        desc: desc,
        time: time,
        read: read ?? this.read,
      );
}

const _initialAlerts = [
  _AlertData(
    icon: Icons.cancel_outlined,
    iconBg: Color(0x33F87171),
    iconColor: AppColors.rose,
    title: 'Phishing SMS Blocked',
    badge: BadgeVariant.autoBlocked,
    badgeLabel: 'Auto-blocked',
    desc: 'VM-HDFC KYC link intercepted before you opened it.',
    time: '10:23 AM',
  ),
  _AlertData(
    icon: Icons.check_circle_outline,
    iconBg: Color(0x334ADE80),
    iconColor: AppColors.emerald,
    title: 'Payment Verified',
    badge: BadgeVariant.safe,
    badgeLabel: 'Safe',
    desc: '₹249 to Swiggy (zomato@okaxis) confirmed safe.',
    time: '9:45 AM',
  ),
  _AlertData(
    icon: Icons.warning_amber_rounded,
    iconBg: Color(0x33FBBF24),
    iconColor: AppColors.amber,
    title: 'Suspicious QR Detected',
    badge: BadgeVariant.warning,
    badgeLabel: 'Warning',
    desc: 'Unknown merchant QR with limited transaction history.',
    time: '8:12 AM',
    read: true,
  ),
  _AlertData(
    icon: Icons.cancel_outlined,
    iconBg: Color(0x33F87171),
    iconColor: AppColors.rose,
    title: 'Spam Call Warning',
    badge: BadgeVariant.spam,
    badgeLabel: 'Spam',
    desc: '+91 98887 65432 has 34 spam reports in our database.',
    time: '8:00 AM',
    read: true,
  ),
  _AlertData(
    icon: Icons.check_circle_outline,
    iconBg: Color(0x333B82F6),
    iconColor: AppColors.blue,
    title: 'AI Database Updated',
    badge: BadgeVariant.update,
    badgeLabel: 'Update',
    desc: '1,247 new fraud patterns added to the AI model.',
    time: '7:00 AM',
    read: true,
  ),
];

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});
  final _AlertData alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert.read ? AppColors.border : AppColors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: alert.iconBg, shape: BoxShape.circle),
            child: Icon(alert.icon, color: alert.iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14))),
                    StatusBadge(label: alert.badgeLabel, variant: alert.badge),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert.desc, style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 8),
                Text(alert.time, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
