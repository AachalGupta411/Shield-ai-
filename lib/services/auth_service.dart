import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/auth_config.dart';
import '../models/user_model.dart';
import 'biometric_service.dart';

class AuthService extends ChangeNotifier {
  AuthService({BiometricService? biometricService, GoogleSignIn? googleSignIn})
      : _biometrics = biometricService ?? BiometricService(),
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email', 'profile'],
              clientId: kIsWeb && AuthConfig.hasGoogleWebClientId
                  ? AuthConfig.googleWebClientId
                  : null,
            );

  final BiometricService _biometrics;
  final GoogleSignIn _googleSignIn;

  UserModel? _user;
  bool _loading = true;

  UserModel? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;

  static const _sessionKey = 'shieldpay_session';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw != null) {
      _user = UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> _persistSession(UserModel user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(user.toJson()));
    await _biometrics.saveUserForBiometric(user.toJson());
    notifyListeners();
  }

  Future<void> signInWithPhone(String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      throw Exception('Enter a valid 10-digit phone number');
    }
    await Future<void>.delayed(const Duration(milliseconds: 800));
    await _persistSession(
      UserModel(
        id: 'user-phone-$digits',
        name: 'Arjun Sharma',
        phone: '+91 ${digits.substring(0, 5)} ${digits.substring(5)}',
        authProvider: 'phone',
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb && !AuthConfig.hasGoogleWebClientId) {
      throw Exception(
        'Google Sign-In needs a web client ID. Run with '
        '--dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_ID.apps.googleusercontent.com',
      );
    }

    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in was cancelled');
    }

    final name = account.displayName?.trim();
    final email = account.email.trim();
    final id = account.id;

    await _persistSession(
      UserModel(
        id: 'google-$id',
        name: name?.isNotEmpty == true ? name! : email.split('@').first,
        phone: '+91 — —',
        email: email,
        authProvider: 'google',
      ),
    );
  }

  Future<UserModel> signInWithBiometrics() async {
    final supported = await _biometrics.isDeviceSupported();
    if (!supported) {
      throw Exception('Biometrics are not available on this device');
    }

    final label = await _biometrics.biometricLabel();
    final ok = await _biometrics.authenticate(
      reason: 'Verify $label to sign in to ShieldAI',
    );
    if (!ok) {
      throw Exception('Biometric authentication failed');
    }

    final stored = await _biometrics.loadUserForBiometric();
    if (stored != null) {
      final restored = UserModel.fromJson(stored);
      await _persistSession(restored);
      return restored;
    }

    // First-time / no stored account — demo user after biometric pass
    const demo = UserModel(
      id: 'user-biometric-demo',
      name: 'Arjun Sharma',
      phone: '+91 98765 43210',
      authProvider: 'biometric',
    );
    await _persistSession(demo);
    return demo;
  }

  Future<bool> canUseBiometrics() => _biometrics.isDeviceSupported();

  Future<String> biometricButtonLabel() => _biometrics.biometricLabel();

  Future<bool> hasBiometricAccount() => _biometrics.hasStoredBiometricUser();

  Future<void> signOut() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    notifyListeners();
  }
}
