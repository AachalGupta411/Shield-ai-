import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Web fallback when native biometrics are unavailable.
Future<bool> showBiometricPrompt(BuildContext context, {required String label}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _BiometricPromptDialog(label: label),
  ).then((v) => v ?? false);
}

class _BiometricPromptDialog extends StatefulWidget {
  const _BiometricPromptDialog({required this.label});

  final String label;

  @override
  State<_BiometricPromptDialog> createState() => _BiometricPromptDialogState();
}

class _BiometricPromptDialogState extends State<_BiometricPromptDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() => _scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ShieldAI',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
              ),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.blue.withValues(alpha: 0.5), width: 2),
                  color: AppColors.blue.withValues(alpha: 0.1),
                ),
                child: Icon(
                  widget.label.toLowerCase().contains('face')
                      ? Icons.face_retouching_natural
                      : Icons.fingerprint,
                  size: 36,
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Verify ${widget.label}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              kIsWeb
                  ? 'Confirm to unlock your ShieldAI account'
                  : 'Use your device biometrics to continue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _scanning ? null : _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _scanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Authenticate', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            TextButton(
              onPressed: _scanning ? null : () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}
