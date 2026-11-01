import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService({LocalAuthentication? auth, FlutterSecureStorage? storage})
      : _auth = auth ?? LocalAuthentication(),
        _storage = storage ?? const FlutterSecureStorage();

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  static const _biometricUserKey = 'shieldpay_biometric_user';

  Future<bool> isDeviceSupported() async {
    if (kIsWeb) return true;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> availableBiometrics() async {
    if (kIsWeb) return [BiometricType.fingerprint];
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Future<String> biometricLabel() async {
    if (kIsWeb) return 'Biometrics';
    final types = await availableBiometrics();
    if (types.contains(BiometricType.face)) return 'Face ID';
    if (types.contains(BiometricType.fingerprint)) return 'Fingerprint';
    if (types.contains(BiometricType.strong) || types.contains(BiometricType.weak)) {
      return 'Biometrics';
    }
    return 'Biometrics / Face ID';
  }

  Future<bool> authenticate({required String reason}) async {
    if (kIsWeb) return true;

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      if (!canCheck && !supported) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> saveUserForBiometric(Map<String, dynamic> userJson) async {
    await _storage.write(key: _biometricUserKey, value: jsonEncode(userJson));
  }

  Future<Map<String, dynamic>?> loadUserForBiometric() async {
    final raw = await _storage.read(key: _biometricUserKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearBiometricUser() async {
    await _storage.delete(key: _biometricUserKey);
  }

  Future<bool> hasStoredBiometricUser() async {
    final raw = await _storage.read(key: _biometricUserKey);
    return raw != null;
  }
}
