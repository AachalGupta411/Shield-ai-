import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/biometric_prompt_dialog.dart';
import '../widgets/mobile_shell.dart';
import '../widgets/shield_logo.dart';

enum _AuthAction { phone, google, biometric }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  _AuthAction? _loadingAction;
  String? _error;
  String _biometricLabel = 'Biometrics / Face ID';
  bool _biometricsAvailable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBiometricInfo());
  }

  Future<void> _loadBiometricInfo() async {
    final auth = context.read<AuthService>();
    final available = await auth.canUseBiometrics();
    final label = await auth.biometricButtonLabel();
    if (mounted) {
      setState(() {
        _biometricsAvailable = available;
        _biometricLabel = label;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isLoading => _loadingAction != null;

  Future<void> _signInWithPhone() async {
    final phone = _phoneController.text;
    setState(() {
      _loadingAction = _AuthAction.phone;
      _error = null;
    });
    try {
      await context.read<AuthService>().signInWithPhone(phone);
      if (mounted) {
        _showSuccess('OTP verified! Welcome to ShieldAI');
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loadingAction = _AuthAction.google;
      _error = null;
    });
    try {
      await context.read<AuthService>().signInWithGoogle();
      if (mounted) {
        _showSuccess('Signed in with Google');
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }

  Future<void> _signInWithBiometrics() async {
    if (!_biometricsAvailable) {
      setState(() => _error = 'Biometrics are not available on this device');
      return;
    }

    if (kIsWeb) {
      final confirmed = await showBiometricPrompt(context, label: _biometricLabel);
      if (!confirmed || !mounted) return;
    }

    setState(() {
      _loadingAction = _AuthAction.biometric;
      _error = null;
    });
    try {
      await context.read<AuthService>().signInWithBiometrics();
      if (mounted) {
        _showSuccess('Biometric verified');
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _message(Object e) => e.toString().replaceFirst('Exception: ', '');

  @override
  Widget build(BuildContext context) {
    final phone = _phoneController.text;
    final valid = phone.length >= 10;

    return MobileShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                ShieldLogo(size: 40),
                SizedBox(width: 10),
                Text(
                  'ShieldAI',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your phone number to continue',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceInput,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: AppColors.border)),
                    ),
                    child: const Row(
                      children: [
                        Text('🇮🇳', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text('+91', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        hintText: 'Enter phone number',
                        hintStyle: TextStyle(color: Color(0xFF4B5563)),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.rose, fontSize: 13)),
            ],
            const SizedBox(height: 16),
            PrimaryButton(
              label: _loadingAction == _AuthAction.phone ? 'Sending OTP...' : 'Send OTP',
              loading: _loadingAction == _AuthAction.phone,
              onPressed: valid && !_isLoading ? _signInWithPhone : null,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Container(height: 1, color: AppColors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ),
                Expanded(child: Container(height: 1, color: AppColors.border)),
              ],
            ),
            const SizedBox(height: 16),
            _OutlineButton(
              onPressed: !_isLoading ? _signInWithGoogle : null,
              loading: _loadingAction == _AuthAction.google,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleIcon(),
                  const SizedBox(width: 12),
                  Text(
                    _loadingAction == _AuthAction.google ? 'Signing in...' : 'Continue with Google',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _OutlineButton(
              onPressed: !_isLoading && _biometricsAvailable ? _signInWithBiometrics : null,
              loading: _loadingAction == _AuthAction.biometric,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _biometricLabel.toLowerCase().contains('face')
                        ? Icons.face_retouching_natural
                        : Icons.fingerprint,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _loadingAction == _AuthAction.biometric
                        ? 'Verifying...'
                        : 'Use $_biometricLabel',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  children: const [
                    TextSpan(text: 'By continuing you agree to our '),
                    TextSpan(text: 'Terms', style: TextStyle(color: AppColors.blue)),
                    TextSpan(text: ' & '),
                    TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.blue)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.onPressed,
    required this.child,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.surfaceInput,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : child,
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paints = [
      Paint()..color = const Color(0xFF4285F4),
      Paint()..color = const Color(0xFF34A853),
      Paint()..color = const Color(0xFFFBBC05),
      Paint()..color = const Color(0xFFEA4335),
    ];
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, 3.14, true, paints[0]);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 3.14, 1.57, true, paints[3]);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.2, paints[1]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
