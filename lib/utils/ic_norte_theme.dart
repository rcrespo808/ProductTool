import 'package:flutter/material.dart';

/// IC Norte Design System Theme Configuration
/// Matches the UI/UX Guidelines for Product Audit Tool

// ============================================================================
// COLORS
// ============================================================================

/// Brand colors (same in both light and dark themes)
class ICNBrandColors {
  static const Color brandForest = Color(0xFF1C4922);
  static const Color brandPrimary = Color(0xFF3BB947);
  static const Color brandSecondary = Color(0xFF2D9637);
}

/// Status colors (same in both light and dark themes)
class ICNStatusColors {
  static const Color statusSuccess = Color(0xFF3BB947);
  static const Color statusError = Color(0xFFE1362C);
  static const Color statusWarning = Color(0xFFE7A300);
  static const Color statusInfo = Color(0xFF1B74E4);
}

/// Light theme colors
class ICNLightColors {
  // Backgrounds
  final Color bgPrimary = const Color(0xFFF3F5F8);
  final Color bgSurface = const Color(0xFFFFFFFF);
  final Color bgSurfaceAlt = const Color(0xFFEBEEF5);

  // Text
  final Color textPrimary = const Color(0xFF000000);
  final Color textSecondary = const Color(0xFFB5B7C1);
  final Color textOnBrand = const Color(0xFFFFFFFF);
  final Color textOnError = const Color(0xFFFFFFFF);

  // Borders
  final Color borderSubtle = const Color(0xFFE7E9EE);
}

/// Dark theme colors
class ICNDarkColors {
  // Backgrounds
  final Color bgPrimary = const Color(0xFF000000);
  final Color bgSurface = const Color(0xFF16181D);
  final Color bgSurfaceAlt = const Color(0xFF1D2026);

  // Text
  final Color textPrimary = const Color(0xFFF4F6F8);
  final Color textSecondary = const Color(0xFFAAB2BC);
  final Color textOnBrand = const Color(0xFFFFFFFF);
  final Color textOnError = const Color(0xFFFFFFFF);

  // Borders
  final Color borderSubtle = const Color(0xFF262A31);
}

/// Context-aware color accessor
class ICNColors {
  static ICNLightColors get light => ICNLightColors();
  static ICNDarkColors get dark => ICNDarkColors();

  /// Get theme-aware colors based on current theme
  static dynamic of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? ICNDarkColors() : ICNLightColors();
  }

  // Brand colors (direct access)
  static const Color brandForest = ICNBrandColors.brandForest;
  static const Color brandPrimary = ICNBrandColors.brandPrimary;
  static const Color brandSecondary = ICNBrandColors.brandSecondary;

  // Status colors (direct access)
  static const Color statusSuccess = ICNStatusColors.statusSuccess;
  static const Color statusError = ICNStatusColors.statusError;
  static const Color statusWarning = ICNStatusColors.statusWarning;
  static const Color statusInfo = ICNStatusColors.statusInfo;

  // Text colors (direct access - same in both themes)
  static const Color textOnBrand = Color(0xFFFFFFFF);
  static const Color textOnError = Color(0xFFFFFFFF);
}

// ============================================================================
// SPACING
// ============================================================================

class ICNSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Component-specific spacing
  static const double cardPadding = 12.0;
  static const double pagePadding = 16.0;
  static const double buttonPaddingH = 8.0;
  static const double buttonPaddingV = 6.0;
  static const double inputPadding = 12.0;
}

// ============================================================================
// BORDER RADIUS
// ============================================================================

class ICNRadius {
  static const double xs = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
  static const double full = 999.0;

  // Component-specific
  static const double card = 16.0;
  static const double button = 12.0;
  static const double input = 12.0;
  static const double chip = 12.0;

  // Pre-built BorderRadius objects
  static BorderRadius get cardBorderRadius => BorderRadius.circular(card);
  static BorderRadius get buttonBorderRadius => BorderRadius.circular(button);
  static BorderRadius get chipBorderRadius => BorderRadius.circular(chip);
  static BorderRadius get stadiumBorder => const BorderRadius.horizontal(
        left: Radius.circular(full),
        right: Radius.circular(full),
      );
  static BorderRadius get circleBorder => BorderRadius.circular(full);
}

// ============================================================================
// ELEVATION
// ============================================================================

class ICNElevation {
  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
}

// ============================================================================
// TYPOGRAPHY
// ============================================================================

class ICNTypography {
  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.20,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.20,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.20,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.20,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.20,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.20,
  );

  // Product Audit Tool specific: Badge text (10px, bold)
  static const TextStyle badgeText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  // Button text style
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}

// ============================================================================
// THEME DATA
// ============================================================================

class ICNTheme {
  /// Light theme configuration
  static ThemeData lightTheme() {
    final lightColors = ICNLightColors();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: ICNBrandColors.brandPrimary,
        secondary: ICNBrandColors.brandSecondary,
        surface: lightColors.bgSurface,
        background: lightColors.bgPrimary,
        error: ICNStatusColors.statusError,
        onPrimary: lightColors.textOnBrand,
        onSecondary: lightColors.textOnBrand,
        onSurface: lightColors.textPrimary,
        onBackground: lightColors.textPrimary,
        onError: lightColors.textOnError,
      ),
      scaffoldBackgroundColor: lightColors.bgPrimary,
      appBarTheme: AppBarTheme(
        backgroundColor: ICNBrandColors.brandForest,
        foregroundColor: lightColors.textOnBrand,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: lightColors.bgSurface,
        elevation: ICNElevation.md,
        shape: RoundedRectangleBorder(
          borderRadius: ICNRadius.cardBorderRadius,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: ICNTypography.displayLarge.copyWith(
          color: lightColors.textPrimary,
        ),
        displayMedium: ICNTypography.displayMedium.copyWith(
          color: lightColors.textPrimary,
        ),
        displaySmall: ICNTypography.displaySmall.copyWith(
          color: lightColors.textPrimary,
        ),
        headlineLarge: ICNTypography.headlineLarge.copyWith(
          color: lightColors.textPrimary,
        ),
        headlineMedium: ICNTypography.headlineMedium.copyWith(
          color: lightColors.textPrimary,
        ),
        headlineSmall: ICNTypography.headlineSmall.copyWith(
          color: lightColors.textPrimary,
        ),
        titleLarge: ICNTypography.titleLarge.copyWith(
          color: lightColors.textPrimary,
        ),
        titleMedium: ICNTypography.titleMedium.copyWith(
          color: lightColors.textPrimary,
        ),
        titleSmall: ICNTypography.titleSmall.copyWith(
          color: lightColors.textPrimary,
        ),
        bodyLarge: ICNTypography.bodyLarge.copyWith(
          color: lightColors.textPrimary,
        ),
        bodyMedium: ICNTypography.bodyMedium.copyWith(
          color: lightColors.textPrimary,
        ),
        bodySmall: ICNTypography.bodySmall.copyWith(
          color: lightColors.textSecondary,
        ),
        labelLarge: ICNTypography.labelLarge.copyWith(
          color: lightColors.textPrimary,
        ),
        labelMedium: ICNTypography.labelMedium.copyWith(
          color: lightColors.textPrimary,
        ),
        labelSmall: ICNTypography.labelSmall.copyWith(
          color: lightColors.textPrimary,
        ),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData darkTheme() {
    final darkColors = ICNDarkColors();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: ICNBrandColors.brandPrimary,
        secondary: ICNBrandColors.brandSecondary,
        surface: darkColors.bgSurface,
        background: darkColors.bgPrimary,
        error: ICNStatusColors.statusError,
        onPrimary: darkColors.textOnBrand,
        onSecondary: darkColors.textOnBrand,
        onSurface: darkColors.textPrimary,
        onBackground: darkColors.textPrimary,
        onError: darkColors.textOnError,
      ),
      scaffoldBackgroundColor: darkColors.bgPrimary,
      appBarTheme: AppBarTheme(
        backgroundColor: ICNBrandColors.brandForest,
        foregroundColor: darkColors.textOnBrand,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: darkColors.bgSurface,
        elevation: ICNElevation.md,
        shape: RoundedRectangleBorder(
          borderRadius: ICNRadius.cardBorderRadius,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: ICNTypography.displayLarge.copyWith(
          color: darkColors.textPrimary,
        ),
        displayMedium: ICNTypography.displayMedium.copyWith(
          color: darkColors.textPrimary,
        ),
        displaySmall: ICNTypography.displaySmall.copyWith(
          color: darkColors.textPrimary,
        ),
        headlineLarge: ICNTypography.headlineLarge.copyWith(
          color: darkColors.textPrimary,
        ),
        headlineMedium: ICNTypography.headlineMedium.copyWith(
          color: darkColors.textPrimary,
        ),
        headlineSmall: ICNTypography.headlineSmall.copyWith(
          color: darkColors.textPrimary,
        ),
        titleLarge: ICNTypography.titleLarge.copyWith(
          color: darkColors.textPrimary,
        ),
        titleMedium: ICNTypography.titleMedium.copyWith(
          color: darkColors.textPrimary,
        ),
        titleSmall: ICNTypography.titleSmall.copyWith(
          color: darkColors.textPrimary,
        ),
        bodyLarge: ICNTypography.bodyLarge.copyWith(
          color: darkColors.textPrimary,
        ),
        bodyMedium: ICNTypography.bodyMedium.copyWith(
          color: darkColors.textPrimary,
        ),
        bodySmall: ICNTypography.bodySmall.copyWith(
          color: darkColors.textSecondary,
        ),
        labelLarge: ICNTypography.labelLarge.copyWith(
          color: darkColors.textPrimary,
        ),
        labelMedium: ICNTypography.labelMedium.copyWith(
          color: darkColors.textPrimary,
        ),
        labelSmall: ICNTypography.labelSmall.copyWith(
          color: darkColors.textPrimary,
        ),
      ),
    );
  }
}

