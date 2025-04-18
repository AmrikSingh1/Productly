import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005E);

  // Secondary Colors
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1E192B);

  // Tertiary Colors
  static const Color tertiary = Color(0xFF7D5260);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // Surface Colors
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color surfaceTint = primary;
  
  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);

  // Outline
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // Shadow
  static const Color shadow = Color(0xFF000000);
  
  // Custom App Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);
  static const Color warning = Color(0xFFFFC107);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color warningLight = Color(0xFFFFF8E1);
}

class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 57,
        height: 1.12,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 45,
        height: 1.16,
      );

  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 36,
        height: 1.22,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 32,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 28,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        height: 1.33,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 22,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.45,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.15,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
      );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadow,
        scrim: AppColors.shadow,
        inverseSurface: Color(0xFF313033),
        onInverseSurface: Color(0xFFF4EFF4),
        inversePrimary: Color(0xFFD0BCFF),
        surfaceTint: AppColors.primary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.onSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        labelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurfaceVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }
} 