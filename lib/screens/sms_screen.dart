import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/status_badge.dart';

class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _messages.where((m) {
      final q = _query.toLowerCase();
      return m.sender.toLowerCase().contains(q) || m.text.toLowerCase().contains(q);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SMS Shield', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatCard(count: 2, label: 'Safe', color: AppColors.emerald, border: AppColors.emerald),
              const SizedBox(width: 8),
              _StatCard(count: 1, label: 'Suspicious', color: AppColors.amber, border: AppColors.amber),
              const SizedBox(width: 8),
              _StatCard(count: 2, label: 'Danger', color: AppColors.rose, border: AppColors.rose),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search messages...',
                      hintStyle: TextStyle(color: Color(0xFF4B5563)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...filtered.map((m) => _MessageTile(message: m)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.count, required this.label, required this.color, required this.border});

  final int count;
  final String label;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}

class _SmsMessage {
  const _SmsMessage({
    required this.sender,
    required this.time,
    required this.text,
    required this.badge,
    required this.dotColor,
    this.hasLink = false,
  });

  final String sender;
  final String time;
  final String text;
  final BadgeVariant badge;
  final Color dotColor;
  final bool hasLink;
}

const _messages = [
  _SmsMessage(
    sender: 'VM-HDFC',
    time: '10:23 AM',
    text: 'URGENT: Your KYC is expired. Click to update: bit.ly/hdfc-kyc',
    badge: BadgeVariant.danger,
    dotColor: AppColors.rose,
    hasLink: true,
  ),
  _SmsMessage(sender: 'GP-Swiggy', time: '9:45 AM', text: 'Your order #SW1234 from Paradise Biryani is confirmed!', badge: BadgeVariant.safe, dotColor: AppColors.emerald),
  _SmsMessage(sender: 'BZ-Lottery', time: '9:12 AM', text: "Congratulations! You've won ₹50,000 in BHIM lottery!", badge: BadgeVariant.danger, dotColor: AppColors.rose),
  _SmsMessage(sender: 'SB-AXIS', time: '8:30 AM', text: 'A/c XX1234 debited ₹500.00 on 03-Jul-26. UPI Ref: 1234567.', badge: BadgeVariant.safe, dotColor: AppColors.emerald),
  _SmsMessage(sender: 'TM-Unknown', time: '8:05 AM', text: "Verification code: 847291. Valid 10 mins. Don't share.", badge: BadgeVariant.warning, dotColor: AppColors.amber),
];

class _MessageTile extends StatelessWidget {
  const _MessageTile({required this.message});
  final _SmsMessage message;

  String get _badgeLabel => switch (message.badge) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: message.dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(message.sender, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14))),
                    Text(message.time, style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    const SizedBox(width: 8),
                    StatusBadge(label: _badgeLabel, variant: message.badge),
                  ],
                ),
                const SizedBox(height: 4),
                if (message.hasLink)
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                      children: const [
                        TextSpan(text: 'URGENT: Your KYC is expired. Click to update: '),
                        TextSpan(text: 'bit.ly/hdfc-kyc', style: TextStyle(color: AppColors.blue, decoration: TextDecoration.underline)),
                      ],
                    ),
                  )
                else
                  Text(message.text, style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
