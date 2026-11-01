import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF121212);
  static const surfaceCard = Color(0xFF1C1C1E);
  static const surfaceInput = Color(0xFF1A1A1A);
  static const blue = Color(0xFF3B82F6);
  static const blueDark = Color(0xFF2563EB);
  static const blueLight = Color(0xFF4A90E2);
  static const blueDeep = Color(0xFF357ABD);
  static const purple = Color(0xFF8B5CF6);
  static const emerald = Color(0xFF4ADE80);
  static const rose = Color(0xFFF87171);
  static const amber = Color(0xFFFBBF24);
  static const yellow = Color(0xFFFACC15);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);
  static const border = Color(0x14FFFFFF);

  static const gradientIcon = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blueLight, blueDeep],
  );

  static const gradientShield = LinearGradient(
    colors: [blue, Color(0xFF6366F1), purple],
  );

  static const gradientScore = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF0F172A)],
  );
}
