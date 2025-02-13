import 'package:flutter/cupertino.dart';

/// Core theme definitions for the app following Apple HIG with custom typography system
/// Contains both light and dark themes, plus reusable design tokens
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  /// DISPLAY TYPOGRAPHY - Artico Font
  /// Reserved for hero sections, major headlines, and brand moments
  /// Uses purposeful weight variations to create visual interest

  /// Hero Display - For main landing pages and key marketing messages
  /// Expanded variant for maximum impact
  static const TextStyle heroDisplay = TextStyle(
    fontFamily: 'Artico Expanded',
    fontSize: 48,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.5,
    height: 1.1, // Tighter leading for display text
  );

  /// Primary Display - For section headers and key content dividers
  static const TextStyle primaryDisplay = TextStyle(
    fontFamily: 'Artico',
    fontSize: 40,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.4,
    height: 1.15,
  );

  /// Secondary Display - For featured content and subsection headers
  static const TextStyle secondaryDisplay = TextStyle(
    fontFamily: 'Artico',
    fontSize: 32,
    fontWeight: FontWeight.w600, // Semi Bold
    letterSpacing: -0.3,
    height: 1.2,
  );

  /// NUMBER TYPOGRAPHY - Artico Font
  /// Specialized styles for numeric displays with purposeful weight and size variations
  /// to create clear visual hierarchy in data presentation

  /// Primary Hero Number - For main focal point numbers
  /// Used for primary metrics and large numerical displays
  static const TextStyle primaryHeroNumber = TextStyle(
    fontFamily: 'Artico',
    fontSize: 72,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -1.0,
    height: 1.0, // Tighter leading for numbers
  );

  /// Secondary Hero Number - For supporting numerical displays
  /// Used for secondary metrics and medium-sized number displays
  static const TextStyle secondaryHeroNumber = TextStyle(
    fontFamily: 'Artico',
    fontSize: 48,
    fontWeight: FontWeight.w600, // Semi Bold
    letterSpacing: -0.5,
    height: 1.0,
  );

  /// Tertiary Hero Number - For smaller numerical indicators
  /// Used for status indicators and supporting metrics
  static const TextStyle tertiaryHeroNumber = TextStyle(
    fontFamily: 'Artico',
    fontSize: 24,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: -0.2,
    height: 1.0,
  );

  /// Small Status Number - For the smallest numerical displays
  /// Used for badges, counters, and minor metrics
  static const TextStyle smallStatusNumber = TextStyle(
    fontFamily: 'Artico',
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0,
    height: 1.0,
  );

  /// CORE UI TYPOGRAPHY - SF Pro Font
  /// Used for all body copy, navigation elements, and interface components
  /// Following Apple HIG with optimized readability

  /// Large Title - For navigation bars and primary headers
  static const TextStyle largeTitle = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    height: 1.2,
  );

  /// Title 1 - For primary content headers
  static const TextStyle title1 = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.36,
    height: 1.3,
  );

  /// Title 2 - For secondary content headers
  static const TextStyle title2 = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.35,
    height: 1.3,
  );

  /// Title 3 - For tertiary content headers
  static const TextStyle title3 = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.3,
  );

  /// Headline - For emphasized UI elements
  static const TextStyle headline = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.4,
  );

  /// Body - Primary reading text
  static const TextStyle body = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 17,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.41,
    height: 1.5, // Increased for better readability
  );

  /// Body Strong - Emphasized body text
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.5,
  );

  /// Callout - For important UI elements
  static const TextStyle callout = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.32,
    height: 1.4,
  );

  /// Subheadline - For supporting text
  static const TextStyle subheadline = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 15,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.24,
    height: 1.4,
  );

  /// Footnote - For auxiliary information
  static const TextStyle footnote = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 13,
    fontWeight: FontWeight.normal,
    letterSpacing: -0.08,
    height: 1.3,
  );

  /// Caption 1 - For labels and small print
  static const TextStyle caption1 = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 1.3,
  );

  /// Caption 2 - For smallest UI elements
  static const TextStyle caption2 = TextStyle(
    fontFamily: 'sfpro',
    fontSize: 11,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.06,
    height: 1.3,
  );

  /// Spacing - Following 8-point grid system
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;

  /// Container sizes
  static const double containerSmall = 120;
  static const double containerMedium = 240;
  static const double containerLarge = 360;

  /// Border radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;

  /// Light Theme Colors
  static const CupertinoDynamicColor primaryLight = CupertinoColors.systemBlue;
  static const Color backgroundLight = CupertinoColors.systemBackground;
  static const Color surfaceLight = CupertinoColors.secondarySystemBackground;
  static const Color textPrimaryLight = CupertinoColors.label;
  static const Color textSecondaryLight = CupertinoColors.secondaryLabel;
  static const Color dividerLight = CupertinoColors.separator;

  /// Dark Theme Colors - Revised Luxury Palette
  /// Inspired by Apple's Space Black and Pro Display XDR aesthetics
  static const Color luxuryCharcoal = Color(0xFF121212); // Base depth
  static const Color obsidianSurface =
      Color(0xFF1E1E1E); // Rich layered surface
  static const Color titaniumAccent =
      Color(0xFF2C2C2E); // Metallic subtle elements
  static const Color platinumText = Color(0xFFF5F5F7); // Premium text contrast
  static const Color graphiteSecondary = Color(0xFF8E8E93); // Subdued elegance
  static const Color pacificBlue = Color(0xFF0A84FF); // Vibrant yet deep accent

  /// Frosted Glass Glow Colors - Light Theme
  static const Color glassGlowPrimaryLight = Color(0xFF9D5FFF); // Soft purple
  static const Color glassGlowSecondaryLight = Color(0xFFFF71CE); // Soft pink

  /// Alternative Frosted Glass Glow Colors - Light Theme (Luxury Metals)
  static const Color glassGlowGunmetalLight =
      Color(0xFF7F8487); // Light gunmetal grey
  static const Color glassGlowGoldLight =
      Color(0xFFBFA065); // Luxurious dull gold

  /// Frosted Glass Glow Colors - Dark Theme
  static const Color glassGlowPrimaryDark = Color(0xFF7B4FCC); // Deep purple
  static const Color glassGlowSecondaryDark = Color(0xFFCC5AA5); // Deep pink

  /// Alternative Frosted Glass Glow Colors - Dark Theme (Luxury Metals)
  static const Color glassGlowGunmetalDark =
      Color(0xFF4A4E51); // Dark gunmetal grey
  static const Color glassGlowGoldDark = Color(0xFF8B7355); // Deep dull gold

  /// Updated Dark Theme Colors
  static const CupertinoDynamicColor primaryDark = CupertinoDynamicColor(
    color: pacificBlue,
    darkColor: pacificBlue,
    highContrastColor: pacificBlue,
    darkHighContrastColor: pacificBlue,
    elevatedColor: pacificBlue,
    darkElevatedColor: pacificBlue,
    highContrastElevatedColor: pacificBlue,
    darkHighContrastElevatedColor: pacificBlue,
  );

  static const Color backgroundDark = luxuryCharcoal; // Deep base canvas
  static const Color surfaceDark = obsidianSurface; // Layered components
  static const Color textPrimaryDark = platinumText; // Maximum readability
  static const Color textSecondaryDark = graphiteSecondary; // Subtle hierarchy
  static const Color dividerDark = titaniumAccent; // Metallic separation

  /// Light Theme
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundLight,
      barBackgroundColor: surfaceLight,
      textTheme: CupertinoTextThemeData(
        textStyle: body,
        navTitleTextStyle: headline,
        navLargeTitleTextStyle: primaryDisplay,
        pickerTextStyle: body,
        dateTimePickerTextStyle: body,
      ),
    );
  }

  /// Dark Theme (Default)
  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundDark,
      barBackgroundColor: surfaceDark,
      textTheme: CupertinoTextThemeData(
        textStyle: body,
        navTitleTextStyle: headline,
        navLargeTitleTextStyle: primaryDisplay,
        pickerTextStyle: body,
        dateTimePickerTextStyle: body,
      ),
    ).copyWith(
      primaryContrastingColor: pacificBlue,
      barBackgroundColor: surfaceDark,
    );
  }
}
