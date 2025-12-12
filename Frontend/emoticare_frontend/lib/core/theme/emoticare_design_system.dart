import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// EmotiCare Design System
/// A comprehensive design system for emotional wellness applications
class EmotiCareDesignSystem {
  EmotiCareDesignSystem._();

  // ============================================
  // COLOR PALETTE - Emotional Wellness Theme
  // ============================================

  // Primary Colors - Soft Purple & Lavender
  static const Color primaryPurple = Color(0xFFA78BFA);
  static const Color primaryLavender = Color(0xFFC4B5FD);
  static const Color primaryLight = Color(0xFFE9D5FF);
  static const Color primaryDark = Color(0xFF7C3AED);

  // Secondary Colors - Soft Pink & Blue
  static const Color secondaryPink = Color(0xFFFBCFE8);
  static const Color secondaryBlue = Color(0xFF93C5FD);
  static const Color secondaryTeal = Color(0xFF81E6D9);
  static const Color secondaryCoral = Color(0xFFFCA5A5);

  // Neutral Colors
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralGray50 = Color(0xFFF8FAFC);
  static const Color neutralGray100 = Color(0xFFF1F5F9);
  static const Color neutralGray200 = Color(0xFFE2E8F0);
  static const Color neutralGray300 = Color(0xFFCBD5E1);
  static const Color neutralGray400 = Color(0xFF94A3B8);
  static const Color neutralGray500 = Color(0xFF64748B);
  static const Color neutralGray600 = Color(0xFF475569);
  static const Color neutralGray700 = Color(0xFF334155);
  static const Color neutralGray800 = Color(0xFF1E293B);
  static const Color neutralGray900 = Color(0xFF0F172A);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Emotion Colors
  static const Color emotionHappy = Color(0xFFFFE066);
  static const Color emotionCalm = Color(0xFF93C5FD);
  static const Color emotionSad = Color(0xFFC4B5FD);
  static const Color emotionAnxious = Color(0xFFFFB74D);
  static const Color emotionTired = Color(0xFF94A3B8);
  static const Color emotionExcited = Color(0xFFFBCFE8);

  // ============================================
  // GRADIENT SETS
  // ============================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryLavender, secondaryPink],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryBlue, secondaryTeal, primaryLavender],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryPink, secondaryCoral, emotionHappy],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient calmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryBlue, primaryLavender, secondaryTeal],
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient glowGradient = RadialGradient(
    center: Alignment.center,
    colors: [
      primaryPurple,
      primaryLavender,
      Colors.transparent,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Background Gradients
  static List<Color> get backgroundGradientColors => [
        primaryPurple.withOpacity(0.08),
        primaryLavender.withOpacity(0.06),
        secondaryPink.withOpacity(0.04),
        secondaryBlue.withOpacity(0.03),
        neutralGray50,
      ];

  // ============================================
  // TYPOGRAPHY SCALE
  // ============================================

  static TextTheme get textTheme {
    final baseText = GoogleFonts.interTextTheme();
    
    return baseText.copyWith(
      // Display
      displayLarge: baseText.displayLarge?.copyWith(
        fontFamily: GoogleFonts.inter().fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.2,
      ),
      displayMedium: baseText.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.2,
      ),
      displaySmall: baseText.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      
      // Headline
      headlineLarge: baseText.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.4,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      ),
      
      // Title
      titleLarge: baseText.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.5,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      
      // Body
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.6,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.6,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
      ),
      
      // Label
      labelLarge: baseText.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      labelMedium: baseText.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.4,
      ),
      labelSmall: baseText.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.3,
      ),
    );
  }

  // ============================================
  // SPACING SYSTEM (8px grid)
  // ============================================

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 64.0;

  // ============================================
  // BORDER RADIUS SYSTEM
  // ============================================

  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusXXXL = 32.0;
  static const double radiusFull = 9999.0;

  // ============================================
  // SHADOW PRESETS
  // ============================================

  static List<BoxShadow> get shadowXS => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowSM => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.08),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMD => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLG => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowXL => [
        BoxShadow(
          color: neutralGray900.withOpacity(0.15),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get shadowGlow => [
        BoxShadow(
          color: primaryPurple.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 5,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> shadowColored(Color color, {double opacity = 0.2}) => [
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
      ];

  // ============================================
  // ANIMATION DURATIONS
  // ============================================

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  static const Curve curveDefault = Curves.easeOutCubic;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveSmooth = Curves.easeInOutCubic;

  // ============================================
  // COMPONENT SIZES
  // ============================================

  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 48.0;
  static const double buttonHeightLG = 56.0;

  static const double inputHeightSM = 40.0;
  static const double inputHeightMD = 48.0;
  static const double inputHeightLG = 56.0;

  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  // ============================================
  // APP BAR CONFIGURATION
  // ============================================

  static const double appBarHeight = 64.0;
  static const double appBarExpandedHeight = 120.0;

  // ============================================
  // BREAKPOINTS (Responsive)
  // ============================================

  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;
}

