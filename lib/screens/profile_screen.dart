import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.gradientScore,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.blue,
                      child: Text(
                        _initials(user?.name ?? 'Arjun Sharma'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'Arjun Sharma', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(
                            user?.email ?? user?.phone ?? '+91 98765 43210',
                            style: const TextStyle(fontSize: 14, color: AppColors.blue),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.star, size: 14, color: AppColors.amber),
                              SizedBox(width: 4),
                              Text('Premium Shield', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.amber)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    _ProfileStat(value: '87', label: 'Security Score', color: AppColors.blue),
                    _ProfileStat(value: '23', label: 'Threats Blocked', color: AppColors.rose),
                    _ProfileStat(value: '156', label: 'Items Scanned', color: AppColors.emerald),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._sections.map((s) => _SettingsSection(section: s)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.read<AuthService>().signOut();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.rose,
                backgroundColor: AppColors.rose.withValues(alpha: 0.1),
                side: BorderSide(color: AppColors.rose.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label, required this.color});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SettingsItem {
  const _SettingsItem({required this.icon, required this.label, this.value = ''});
  final IconData icon;
  final String label;
  final String value;
}

class _SectionData {
  const _SectionData({required this.title, required this.items});
  final String title;
  final List<_SettingsItem> items;
}

const _sections = [
  _SectionData(
    title: 'SECURITY',
    items: [
      _SettingsItem(icon: Icons.shield_outlined, label: 'Protection History', value: '23 threats blocked'),
      _SettingsItem(icon: Icons.phone_disabled_outlined, label: 'Blocked Numbers', value: '8 numbers'),
      _SettingsItem(icon: Icons.lock_outline, label: 'Privacy Settings'),
    ],
  ),
  _SectionData(
    title: 'AI & SCANS',
    items: [
      _SettingsItem(icon: Icons.memory_outlined, label: 'AI Preferences', value: 'High sensitivity'),
      _SettingsItem(icon: Icons.notifications_outlined, label: 'Notifications', value: 'All on'),
      _SettingsItem(icon: Icons.show_chart_outlined, label: 'Scan Frequency', value: 'Real-time'),
    ],
  ),
  _SectionData(
    title: 'PREMIUM',
    items: [
      _SettingsItem(icon: Icons.star_outline, label: 'Family Protection', value: '3 members'),
    ],
  ),
];

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.section});
  final _SectionData section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: List.generate(section.items.length, (i) {
                final item = section.items[i];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: i < section.items.length - 1
                            ? const Border(bottom: BorderSide(color: Color(0x0AFFFFFF)))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 14))),
                          if (item.value.isNotEmpty)
                            Text(item.value, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted.withValues(alpha: 0.6)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
