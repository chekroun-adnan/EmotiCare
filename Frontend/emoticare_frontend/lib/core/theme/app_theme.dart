import 'package:flutter/material.dart';
import 'emoticare_design_system.dart';

class AppTheme {
  // Import from design system
  static const Color softPurple = EmotiCareDesignSystem.primaryPurple;
  static const Color lavender = EmotiCareDesignSystem.primaryLavender;
  static const Color lightPink = EmotiCareDesignSystem.secondaryPink;
  static const Color softBlue = EmotiCareDesignSystem.secondaryBlue;
  static const Color warmWhite = EmotiCareDesignSystem.neutralGray50;
  static const Color neutralGrey = EmotiCareDesignSystem.neutralGray300;
  
  // Legacy colors for backward compatibility
  static const Color primaryTeal = softPurple;
  static const Color secondaryLavender = lavender;
  static const Color accentCoral = lightPink;
  static const Color backgroundWarm = warmWhite;
  static const Color surfaceSoft = Colors.white;
  static const Color textPrimary = EmotiCareDesignSystem.neutralGray800;
  static const Color textSecondary = EmotiCareDesignSystem.neutralGray500;

  static ThemeData light() {
    // Create a custom color scheme using design system
    final colorScheme = ColorScheme.light(
      primary: EmotiCareDesignSystem.primaryPurple,
      secondary: EmotiCareDesignSystem.primaryLavender,
      tertiary: EmotiCareDesignSystem.secondaryPink,
      surface: EmotiCareDesignSystem.neutralWhite,
      background: EmotiCareDesignSystem.neutralGray50,
      error: EmotiCareDesignSystem.error,
      onPrimary: EmotiCareDesignSystem.neutralWhite,
      onSecondary: EmotiCareDesignSystem.neutralWhite,
      onTertiary: EmotiCareDesignSystem.neutralWhite,
      onSurface: EmotiCareDesignSystem.neutralGray800,
      onBackground: EmotiCareDesignSystem.neutralGray800,
      onError: EmotiCareDesignSystem.neutralWhite,
      primaryContainer: EmotiCareDesignSystem.neutralGray100,
      secondaryContainer: EmotiCareDesignSystem.neutralGray100,
      tertiaryContainer: EmotiCareDesignSystem.neutralGray100,
      onPrimaryContainer: EmotiCareDesignSystem.primaryDark,
      onSecondaryContainer: EmotiCareDesignSystem.primaryDark,
      onTertiaryContainer: EmotiCareDesignSystem.neutralGray700,
    );

    // Use design system typography
    final baseText = EmotiCareDesignSystem.textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: baseText.copyWith(
        headlineLarge: baseText.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: baseText.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(
          color: textPrimary,
          height: 1.6, // More readable line height
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          color: textSecondary,
          height: 1.5,
        ),
      ),
      scaffoldBackgroundColor: EmotiCareDesignSystem.neutralGray50,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: EmotiCareDesignSystem.neutralGray800,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: EmotiCareDesignSystem.neutralGray800,
        ),
        toolbarHeight: EmotiCareDesignSystem.appBarHeight,
      ),
      cardTheme: CardThemeData(
        color: EmotiCareDesignSystem.neutralWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXXL),
        ),
        elevation: 0,
        shadowColor: EmotiCareDesignSystem.primaryPurple.withOpacity(0.1),
        margin: EdgeInsets.all(EmotiCareDesignSystem.spacingMD),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EmotiCareDesignSystem.neutralWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: BorderSide(
            color: EmotiCareDesignSystem.neutralGray300,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: BorderSide(
            color: EmotiCareDesignSystem.neutralGray300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: const BorderSide(
            color: EmotiCareDesignSystem.primaryPurple,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: const BorderSide(
            color: EmotiCareDesignSystem.error,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: EmotiCareDesignSystem.spacingLG,
          vertical: EmotiCareDesignSystem.spacingMD,
        ),
        hintStyle: TextStyle(
          color: EmotiCareDesignSystem.neutralGray500.withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: EmotiCareDesignSystem.neutralGray500,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: EmotiCareDesignSystem.primaryPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusLG),
        ),
        backgroundColor: EmotiCareDesignSystem.neutralGray800,
        contentTextStyle: baseText.bodyMedium?.copyWith(
          color: EmotiCareDesignSystem.neutralWhite,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EmotiCareDesignSystem.primaryPurple,
          foregroundColor: EmotiCareDesignSystem.neutralWhite,
          elevation: 0,
          shadowColor: EmotiCareDesignSystem.primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: EmotiCareDesignSystem.spacingXL,
            vertical: EmotiCareDesignSystem.spacingMD,
          ),
          minimumSize: Size(0, EmotiCareDesignSystem.buttonHeightMD),
          textStyle: baseText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return EmotiCareDesignSystem.neutralWhite.withOpacity(0.2);
              }
              return null;
            },
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: EmotiCareDesignSystem.primaryPurple,
          textStyle: baseText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: EmotiCareDesignSystem.primaryPurple,
        foregroundColor: EmotiCareDesignSystem.neutralWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXXL),
        ),
      ),
    );
  }

  static ThemeData dark() {
    // Create a custom color scheme for dark mode
    final colorScheme = ColorScheme.dark(
      primary: EmotiCareDesignSystem.primaryPurple,
      secondary: EmotiCareDesignSystem.primaryLavender,
      tertiary: EmotiCareDesignSystem.secondaryPink,
      surface: EmotiCareDesignSystem.neutralGray800,
      background: EmotiCareDesignSystem.neutralGray900,
      error: EmotiCareDesignSystem.error,
      onPrimary: EmotiCareDesignSystem.neutralWhite,
      onSecondary: EmotiCareDesignSystem.neutralWhite,
      onTertiary: EmotiCareDesignSystem.neutralWhite,
      onSurface: EmotiCareDesignSystem.neutralGray100,
      onBackground: EmotiCareDesignSystem.neutralGray100,
      onError: EmotiCareDesignSystem.neutralWhite,
      primaryContainer: EmotiCareDesignSystem.neutralGray800,
      secondaryContainer: EmotiCareDesignSystem.neutralGray800,
      tertiaryContainer: EmotiCareDesignSystem.neutralGray800,
      onPrimaryContainer: EmotiCareDesignSystem.primaryLight,
      onSecondaryContainer: EmotiCareDesignSystem.primaryLight,
      onTertiaryContainer: EmotiCareDesignSystem.neutralGray200,
    );

    final baseText = EmotiCareDesignSystem.textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      textTheme: baseText.copyWith(
        headlineLarge: baseText.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: EmotiCareDesignSystem.neutralGray100,
          letterSpacing: -0.5,
        ),
        headlineMedium: baseText.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: EmotiCareDesignSystem.neutralGray100,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: EmotiCareDesignSystem.neutralGray100,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(
          color: EmotiCareDesignSystem.neutralGray200,
          height: 1.6,
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          color: EmotiCareDesignSystem.neutralGray300,
          height: 1.5,
        ),
      ),
      scaffoldBackgroundColor: EmotiCareDesignSystem.neutralGray900,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: EmotiCareDesignSystem.neutralGray100,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: EmotiCareDesignSystem.neutralGray100,
        ),
        toolbarHeight: EmotiCareDesignSystem.appBarHeight,
      ),
      cardTheme: CardThemeData(
        color: EmotiCareDesignSystem.neutralGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXXL),
        ),
        elevation: 0,
        shadowColor: EmotiCareDesignSystem.primaryPurple.withOpacity(0.2),
        margin: EdgeInsets.all(EmotiCareDesignSystem.spacingMD),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EmotiCareDesignSystem.neutralGray800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: BorderSide(
            color: EmotiCareDesignSystem.neutralGray700,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: BorderSide(
            color: EmotiCareDesignSystem.neutralGray700,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: const BorderSide(
            color: EmotiCareDesignSystem.primaryPurple,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          borderSide: const BorderSide(
            color: EmotiCareDesignSystem.error,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: EmotiCareDesignSystem.spacingLG,
          vertical: EmotiCareDesignSystem.spacingMD,
        ),
        hintStyle: TextStyle(
          color: EmotiCareDesignSystem.neutralGray500.withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          color: EmotiCareDesignSystem.neutralGray400,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: EmotiCareDesignSystem.primaryPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusLG),
        ),
        backgroundColor: EmotiCareDesignSystem.neutralGray700,
        contentTextStyle: baseText.bodyMedium?.copyWith(
          color: EmotiCareDesignSystem.neutralWhite,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EmotiCareDesignSystem.primaryPurple,
          foregroundColor: EmotiCareDesignSystem.neutralWhite,
          elevation: 0,
          shadowColor: EmotiCareDesignSystem.primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXL),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: EmotiCareDesignSystem.spacingXL,
            vertical: EmotiCareDesignSystem.spacingMD,
          ),
          minimumSize: Size(0, EmotiCareDesignSystem.buttonHeightMD),
          textStyle: baseText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return EmotiCareDesignSystem.neutralWhite.withOpacity(0.2);
              }
              return null;
            },
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: EmotiCareDesignSystem.primaryPurple,
          textStyle: baseText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: EmotiCareDesignSystem.primaryPurple,
        foregroundColor: EmotiCareDesignSystem.neutralWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EmotiCareDesignSystem.radiusXXL),
        ),
      ),
    );
  }
}
