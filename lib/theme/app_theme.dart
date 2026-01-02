import 'package:flutter/material.dart';

/// AppTheme - Complete theme definition for TrackFi App
/// Provides consistent light and dark themes with Material 3 design
/// Updated with modern color system and improved accessibility
class AppTheme {
  // ==================== SEMANTIC COLORS ====================

  // Primary Colors - Indigo based (Main brand color)
  static const Color kPrimary = Color(0xFF6366F1);
  static const Color kPrimaryLight = Color(0xFF818CF8);
  static const Color kPrimaryDark = Color(0xFF4F46E5);
  static const Color kPrimaryContainer = Color(0xFFE0E7FF);
  static const Color kOnPrimaryContainer = Color(0xFF1E1B4B);

  // Secondary Colors - Cyan based (Accent color)
  static const Color kSecondary = Color(0xFF06B6D4);
  static const Color kSecondaryLight = Color(0xFF22D3EE);
  static const Color kSecondaryDark = Color(0xFF0891B2);
  static const Color kSecondaryContainer = Color(0xFFCFFAFE);
  static const Color kOnSecondaryContainer = Color(0xFF164E63);

  // Tertiary Colors - Lime based (Success/Positive actions)
  static const Color kTertiary = Color(0xFF10B981);
  static const Color kTertiaryLight = Color(0xFF34D399);
  static const Color kTertiaryDark = Color(0xFF059669);
  static const Color kTertiaryContainer = Color(0xFFD1FAE5);
  static const Color kOnTertiaryContainer = Color(0xFF064E3B);

  // Success Colors - Green based (Positive feedback)
  static const Color kSuccess = Color(0xFF10B981);
  static const Color kSuccessLight = Color(0xFF34D399);
  static const Color kSuccessDark = Color(0xFF059669);
  static const Color kSuccessContainer = Color(0xFFD1FAE5);
  static const Color kOnSuccessContainer = Color(0xFF064E3B);

  // Warning Colors - Amber based (Caution/Attention)
  static const Color kWarning = Color(0xFFF59E0B);
  static const Color kWarningLight = Color(0xFFFBBF24);
  static const Color kWarningDark = Color(0xFFD97706);
  static const Color kWarningContainer = Color(0xFFFEF3C7);
  static const Color kOnWarningContainer = Color(0xFF78350F);

  // Error Colors - Rose based (Danger/Negative)
  static const Color kError = Color(0xFFF43F5E);
  static const Color kErrorLight = Color(0xFFF87171);
  static const Color kErrorDark = Color(0xFFE11D48);
  static const Color kErrorContainer = Color(0xFFFEE2E2);
  static const Color kOnErrorContainer = Color(0xFF7F1D1D);

  // Info Colors - Blue based (Information/Neutral)
  static const Color kInfo = Color(0xFF3B82F6);
  static const Color kInfoLight = Color(0xFF60A5FA);
  static const Color kInfoDark = Color(0xFF2563EB);
  static const Color kInfoContainer = Color(0xFFDBEAFE);
  static const Color kOnInfoContainer = Color(0xFF1E3A8A);

  // Neutral Colors - Gray based (Backgrounds, borders)
  static const Color kNeutral = Color(0xFF6B7280);
  static const Color kNeutralLight = Color(0xFF9CA3AF);
  static const Color kNeutralDark = Color(0xFF374151);
  static const Color kNeutralContainer = Color(0xFFF3F4F6);
  static const Color kOnNeutralContainer = Color(0xFF111827);

  // ==================== BACKWARD COMPATIBILITY ====================
  // Legacy color names (kept for compatibility - prefer semantic names above)
  static const Color kIndigo = kPrimary;
  static const Color kIndigoLight = kPrimaryLight;
  static const Color kIndigoDark = kPrimaryDark;
  static const Color kIndigoContainer = kPrimaryContainer;
  static const Color kOnIndigoContainer = kOnPrimaryContainer;

  static const Color kCyan = kSecondary;
  static const Color kCyanLight = kSecondaryLight;
  static const Color kCyanDark = kSecondaryDark;
  static const Color kCyanContainer = kSecondaryContainer;
  static const Color kOnCyanContainer = kOnSecondaryContainer;

  static const Color kLime = kTertiary;
  static const Color kLimeLight = kTertiaryLight;
  static const Color kLimeDark = kTertiaryDark;
  static const Color kLimeContainer = kTertiaryContainer;
  static const Color kOnLimeContainer = kOnTertiaryContainer;

  static const Color kAmber = kWarning;
  static const Color kAmberLight = kWarningLight;
  static const Color kAmberDark = kWarningDark;
  static const Color kAmberContainer = kWarningContainer;
  static const Color kOnAmberContainer = kOnWarningContainer;

  static const Color kRose = kError;
  static const Color kRoseLight = kErrorLight;
  static const Color kRoseDark = kErrorDark;
  static const Color kRoseContainer = kErrorContainer;
  static const Color kOnRoseContainer = kOnErrorContainer;

  // Legacy Text Colors (for backward compatibility)
  // These are kept for files that still reference them directly
  static const Color kTextPrimary = Color(0xFF1F2937);
  static const Color kTextSecondary = Color(0xFF6B7280);

  // Text Colors - Light Theme
  static const Color kTextPrimaryLight = Color(0xFF1F2937);
  static const Color kTextSecondaryLight = Color(0xFF6B7280);
  static const Color kTextTertiaryLight = Color(0xFF9CA3AF);

  // Text Colors - Dark Theme
  static const Color kTextPrimaryDark = Color(0xFFF1F5F9);
  static const Color kTextSecondaryDark = Color(0xFF94A3B8);
  static const Color kTextTertiaryDark = Color(0xFF64748B);

  // ==================== LIGHT THEME COLORS ====================
  // Clean, modern light palette with proper contrast ratios

  static const Color kLightBackground = Color(0xFFF8FAFF);        // Main background
  static const Color kLightSurface = Color(0xFFFFFFFF);           // Primary surface (cards, dialogs)
  static const Color kLightSurfaceVariant = Color(0xFFF1F5F9);    // Secondary surface
  static const Color kLightSurfaceContainer = Color(0xFFE2E8F0);  // Container surfaces
  static const Color kLightSurfaceContainerHighest = Color(0xFFD1D5DB); // Highest elevation
  static const Color kLightCardBackground = Color(0xFFFFFFFF);    // Card backgrounds
  static const Color kLightBorder = Color(0xFFE5E7EB);            // Border colors
  static const Color kLightOutline = Color(0xFFD1D5DB);           // Outline colors
  static const Color kLightShadow = Color(0x1A000000);            // Shadow color (10% opacity)

  // ==================== DARK THEME COLORS ====================
  // GitHub-inspired warm dark palette for better eye comfort
  // Reduces blue tint for less eye strain in low-light environments

  static const Color kDarkBackground = Color(0xFF0D1117);         // Main background (warm)
  static const Color kDarkSurface = Color(0xFF161B22);            // Primary surface
  static const Color kDarkSurfaceVariant = Color(0xFF21262D);     // Secondary surface
  static const Color kDarkSurfaceContainer = Color(0xFF30363D);   // Container surfaces
  static const Color kDarkSurfaceContainerHighest = Color(0xFF3C424D); // Highest elevation
  static const Color kDarkCardBackground = Color(0xFF21262D);     // Card backgrounds
  static const Color kDarkBorder = Color(0xFF484F58);             // Border colors
  static const Color kDarkOutline = Color(0xFF6E7681);            // Outline colors
  static const Color kDarkShadow = Color(0x40000000);             // Shadow color (25% opacity)

  // ==================== BACKWARD COMPATIBILITY - SURFACE COLORS ====================
  // Legacy surface color names (kept for compatibility)
  static const Color kBg = kLightBackground;
  static const Color kLightBg = kLightBackground;
  static const Color kLightCardBg = kLightCardBackground;

  static const Color kDarkBg = kDarkBackground;
  static const Color kDarkSurfaceL1 = kDarkSurfaceVariant;
  static const Color kDarkSurfaceL2 = kDarkSurfaceContainer;
  static const Color kDarkSurfaceL3 = kDarkCardBackground;
  static const Color kDarkCardBg = kDarkCardBackground;

  // ==================== BACKWARD COMPATIBILITY - TEXT COLORS ====================
  // Legacy text color names (kept for compatibility)
  static const Color kDarkOnSurface = Color(0xFFC9D1D9);           // Primary text (89% white)
  static const Color kDarkOnSurfaceVariant = Color(0xFF8B949E);   // Secondary text (60% white)
  static const Color kDarkOnSurfaceTertiary = Color(0xFF6E7681);  // Tertiary text (45% white)

  // ==================== SHIMMER/LOADING COLORS ====================
  // Smooth animated loading effects for better UX
  
  // Light theme shimmer colors
  static const Color kShimmerBaseLight = Color(0xFFE2E8F0);
  static const Color kShimmerHighlightLight = Color(0xFFF8FAFC);
  
  // Dark theme shimmer colors
  static const Color kShimmerBaseDark = Color(0xFF30363D);
  static const Color kShimmerHighlightDark = Color(0xFF484F58);
  
  // Shimmer gradients (using factory for const compatibility)
  static LinearGradient get kShimmerGradientLight => const LinearGradient(
    colors: [Color(0xFFE2E8F0), Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );
  
  static LinearGradient get kShimmerGradientDark => const LinearGradient(
    colors: [Color(0xFF30363D), Color(0xFF484F58), Color(0xFF30363D)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );

  // ==================== GRADIENTS ====================

  // Light theme gradients
  static const LinearGradient kLightSurfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark theme gradients
  static const LinearGradient kDarkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1F2940), Color(0xFF151E32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kDarkCardGradient = LinearGradient(
    colors: [Color(0xFF243045), Color(0xFF1F2940)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [kIndigo, kIndigoLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kSecondaryGradient = LinearGradient(
    colors: [kCyan, kCyanLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== THEME DATA ====================

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: kPrimary,
      brightness: Brightness.light,
      primary: kPrimary,
      onPrimary: Colors.white,
      primaryContainer: kPrimaryContainer,
      onPrimaryContainer: kOnPrimaryContainer,
      secondary: kSecondary,
      onSecondary: Colors.white,
      secondaryContainer: kSecondaryContainer,
      onSecondaryContainer: kOnSecondaryContainer,
      tertiary: kTertiary,
      onTertiary: Colors.white,
      tertiaryContainer: kTertiaryContainer,
      onTertiaryContainer: kOnTertiaryContainer,
      error: kError,
      onError: Colors.white,
      errorContainer: kErrorContainer,
      onErrorContainer: kOnErrorContainer,
      surface: kLightBackground,
      onSurface: kTextPrimaryLight,
      surfaceContainerHighest: kLightSurfaceVariant,
      onSurfaceVariant: kTextSecondaryLight,
      outline: kLightOutline,
      outlineVariant: kLightBorder,
    );

    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: kLightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: kTextPrimaryLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: kTextPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: kLightCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextPrimaryLight.withAlpha(31)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextPrimaryLight.withAlpha(31)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimary, width: 2),
        ),
        hintStyle: const TextStyle(color: kTextSecondaryLight),
        labelStyle: const TextStyle(color: kTextSecondaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: kPrimary.withAlpha(80),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimary,
          side: BorderSide(color: kPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: kLightSurface,
        contentTextStyle: const TextStyle(color: kTextPrimaryLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(color: kTextPrimaryLight),
        displayMedium: const TextStyle(color: kTextPrimaryLight),
        displaySmall: const TextStyle(color: kTextPrimaryLight),
        headlineLarge: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleSmall: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodyLarge: const TextStyle(
          color: kTextPrimaryLight,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          color: kTextPrimaryLight,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: kTextSecondaryLight,
          height: 1.5,
        ),
        labelLarge: const TextStyle(
          color: kPrimary,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: kTextSecondaryLight,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: kTextSecondaryLight,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kLightSurface,
        selectedItemColor: kIndigo,
        unselectedItemColor: kTextSecondaryLight,
        showUnselectedLabels: true,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: kIndigo),
        unselectedIconTheme: IconThemeData(color: kTextSecondaryLight),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kLightSurface,
        indicatorColor: kIndigoContainer,
      ),
      dividerTheme: const DividerThemeData(
        color: kLightBorder,
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: kLightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        shadowColor: kLightShadow,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: kLightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: kTextPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: kTextSecondaryLight,
          fontSize: 14,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: kLightSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
        shadowColor: kLightShadow,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: kLightSurface,
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedColor: kIndigo,
        iconColor: kTextSecondaryLight,
        textColor: kTextPrimaryLight,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigo;
          }
          return kLightSurfaceContainer;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigo.withAlpha(100);
          }
          return kLightSurfaceContainer;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigo;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: kLightBorder, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigo;
          }
          return kLightBorder;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: kIndigo,
        inactiveTrackColor: kLightSurfaceContainer,
        thumbColor: kIndigo,
        activeTickMarkColor: Colors.white,
        inactiveTickMarkColor: kLightBorder,
        overlayColor: kIndigo.withAlpha(30),
        valueIndicatorColor: kIndigo,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kIndigo,
        linearTrackColor: kLightSurfaceContainer,
        circularTrackColor: kLightSurfaceContainer,
        linearMinHeight: 4,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: kIndigo,
        labelColor: kIndigo,
        unselectedLabelColor: kTextSecondaryLight,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: kIndigo, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kLightSurfaceVariant,
        selectedColor: kIndigoContainer,
        disabledColor: kLightSurfaceContainer,
        labelStyle: const TextStyle(
          color: kTextPrimaryLight,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        secondaryLabelStyle: const TextStyle(
          color: kIndigo,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        checkmarkColor: kIndigo,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: kIndigo,
        selectionColor: kIndigo.withAlpha(70),
        selectionHandleColor: kIndigo,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(kLightBorder),
        trackColor: WidgetStateProperty.all(kLightSurfaceVariant),
        trackBorderColor: WidgetStateProperty.all(kLightBorder),
        thickness: WidgetStateProperty.all(6),
        radius: const Radius.circular(3),
        crossAxisMargin: 2,
        mainAxisMargin: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: kPrimary,
      brightness: Brightness.dark,
      primary: kPrimaryLight,
      onPrimary: Color(0xFF1E1B4B),
      primaryContainer: Color(0xFF312E81),
      onPrimaryContainer: kPrimaryContainer,
      secondary: kSecondaryLight,
      onSecondary: Color(0xFF164E63),
      secondaryContainer: Color(0xFF164E63),
      onSecondaryContainer: kSecondaryContainer,
      tertiary: kTertiaryLight,
      onTertiary: Color(0xFF064E3B),
      tertiaryContainer: Color(0xFF065F46),
      onTertiaryContainer: kTertiaryContainer,
      error: kErrorLight,
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: kErrorContainer,
      surface: kDarkBackground,
      onSurface: kDarkOnSurface,
      surfaceContainerHighest: kDarkSurfaceVariant,
      onSurfaceVariant: kDarkOnSurfaceVariant,
      outline: kDarkOutline,
      outlineVariant: kDarkBorder,
    );

    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: kDarkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: kDarkOnSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: kDarkOnSurface),
      ),
      cardTheme: CardThemeData(
        color: kDarkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kDarkBorder),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kDarkBorder.withAlpha(150)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kIndigoLight, width: 2),
        ),
        hintStyle: TextStyle(color: kDarkOnSurfaceVariant.withAlpha(200)),
        labelStyle: TextStyle(color: kDarkOnSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: kPrimary.withAlpha(80),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kIndigoLight,
          side: const BorderSide(color: kIndigoLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kIndigoLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: kDarkSurfaceContainer,
        contentTextStyle: TextStyle(color: kDarkOnSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: kDarkOnSurface),
        displayMedium: TextStyle(color: kDarkOnSurface),
        displaySmall: TextStyle(color: kDarkOnSurface),
        headlineLarge: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleSmall: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          color: kDarkOnSurface,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: kDarkOnSurface,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: kDarkOnSurfaceVariant,
          height: 1.5,
        ),
        labelLarge: const TextStyle(
          color: kPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: kDarkOnSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: kDarkOnSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kDarkSurface,
        selectedItemColor: kIndigoLight,
        unselectedItemColor: kDarkOnSurfaceVariant,
        showUnselectedLabels: true,
        elevation: 0,
        selectedIconTheme: const IconThemeData(color: kIndigoLight),
        unselectedIconTheme: IconThemeData(color: kDarkOnSurfaceVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kDarkSurface,
        indicatorColor: kPrimary.withAlpha(60),
      ),
      dividerTheme: const DividerThemeData(
        color: kDarkBorder,
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: kDarkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: kDarkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: kDarkOnSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: kDarkOnSurfaceVariant,
          fontSize: 14,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: kDarkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: kDarkSurface,
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedColor: kIndigoLight,
        iconColor: kDarkOnSurfaceVariant,
        textColor: kDarkOnSurface,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigoLight;
          }
          return kDarkSurfaceContainer;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigoLight.withAlpha(100);
          }
          return kDarkSurfaceContainer;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigoLight;
          }
          return Colors.transparent;
        }),
        side: BorderSide(color: kDarkBorder, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return kIndigoLight;
          }
          return kDarkBorder;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: kIndigoLight,
        inactiveTrackColor: kDarkSurfaceContainer,
        thumbColor: kIndigoLight,
        activeTickMarkColor: kDarkBg,
        inactiveTickMarkColor: kDarkBorder,
        overlayColor: kIndigoLight.withAlpha(30),
        valueIndicatorColor: kIndigoLight,
        valueIndicatorTextStyle: const TextStyle(
          color: kDarkBg,
          fontWeight: FontWeight.w600,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kIndigoLight,
        linearTrackColor: kDarkSurfaceContainer,
        circularTrackColor: kDarkSurfaceContainer,
        linearMinHeight: 4,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: kIndigoLight,
        labelColor: kIndigoLight,
        unselectedLabelColor: kDarkOnSurfaceVariant,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: kIndigoLight, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kDarkSurfaceContainer,
        selectedColor: kIndigo.withAlpha(60),
        disabledColor: kDarkSurfaceContainer,
        labelStyle: TextStyle(
          color: kDarkOnSurface,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        secondaryLabelStyle: const TextStyle(
          color: kIndigoLight,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        checkmarkColor: kIndigoLight,
        side: BorderSide(color: kDarkBorder, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: kIndigoLight,
        selectionColor: kIndigoLight.withAlpha(70),
        selectionHandleColor: kIndigoLight,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(kDarkBorder),
        trackColor: WidgetStateProperty.all(kDarkSurfaceContainer),
        trackBorderColor: WidgetStateProperty.all(kDarkBorder),
        thickness: WidgetStateProperty.all(6),
        radius: const Radius.circular(3),
        crossAxisMargin: 2,
        mainAxisMargin: 4,
      ),
    );
  }
}

