import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/shield_logo.dart';

enum ScanTab { qr, sms, upi, phone, link }

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.initialTab = ScanTab.qr});

  final ScanTab initialTab;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late ScanTab _activeTab;
  final _controller = TextEditingController();
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  void didUpdateWidget(covariant ScanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _activeTab = widget.initialTab;
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAction() async {
    if (_activeTab == ScanTab.qr) {
      setState(() => _scanning = true);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _scanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR code scanned — Safe to proceed')),
        );
      }
      return;
    }
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter content to analyze')),
      );
      return;
    }
    setState(() => _scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _scanning = false);
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Analysis complete — No threats detected')),
      );
    }
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
              const Text('AI Scanner', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.blue, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ScanTab.values.map((tab) {
                final active = _activeTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeTab = tab;
                        _controller.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.blue : AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _tabLabel(tab),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: active ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          if (_activeTab == ScanTab.qr) _QrViewfinder() else _InputCard(tab: _activeTab, controller: _controller),
          const SizedBox(height: 24),
          PrimaryButton(
            label: _scanning ? 'Analyzing...' : _buttonLabel(_activeTab),
            icon: Icons.visibility_outlined,
            loading: _scanning,
            onPressed: _scanning ? null : _handleAction,
          ),
        ],
      ),
    );
  }

  String _tabLabel(ScanTab tab) => switch (tab) {
        ScanTab.qr => 'QR Code',
        ScanTab.sms => 'SMS',
        ScanTab.upi => 'UPI ID',
        ScanTab.phone => 'Phone No.',
        ScanTab.link => 'Link',
      };

  String _buttonLabel(ScanTab tab) => tab == ScanTab.qr ? 'Start Scan' : 'Analyze Now';
}

class _QrViewfinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: CustomPaint(painter: _CornerPainter()),
                    ),
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: 25,
                      itemBuilder: (_, __) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.qr_code_scanner, size: 32, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Align QR code within frame', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const len = 32.0;
    final corners = [
      [Offset.zero, Offset(len, 0), Offset(0, len)],
      [Offset(size.width, 0), Offset(size.width - len, 0), Offset(size.width, len)],
      [Offset(0, size.height), Offset(len, size.height), Offset(0, size.height - len)],
      [Offset(size.width, size.height), Offset(size.width - len, size.height), Offset(size.width, size.height - len)],
    ];
    for (final c in corners) {
      canvas.drawLine(c[0], c[1], paint);
      canvas.drawLine(c[0], c[2], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InputCard extends StatelessWidget {
  const _InputCard({required this.tab, required this.controller});

  final ScanTab tab;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final label = switch (tab) {
      ScanTab.sms => 'ENTER SMS TO ANALYZE',
      ScanTab.upi => 'ENTER UPI ID TO ANALYZE',
      ScanTab.phone => 'ENTER PHONE NO. TO ANALYZE',
      ScanTab.link => 'ENTER LINK TO ANALYZE',
      _ => '',
    };
    final placeholder = switch (tab) {
      ScanTab.sms => 'Paste SMS text here...',
      ScanTab.upi => 'e.g. merchant@okaxis',
      ScanTab.phone => '+91 XXXXX XXXXX',
      ScanTab.link => 'https://payment-link.com/...',
      _ => '',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1, color: AppColors.textMuted)),
          const SizedBox(height: 12),
          if (tab == ScanTab.sms)
            TextField(
              controller: controller,
              maxLines: 6,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(color: Color(0xFF4B5563)),
              ),
            )
          else
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(color: Color(0xFF4B5563)),
              ),
            ),
        ],
      ),
    );
  }
}
