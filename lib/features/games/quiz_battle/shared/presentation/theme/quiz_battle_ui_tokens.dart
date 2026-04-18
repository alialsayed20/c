import 'package:flutter/material.dart';

abstract final class QuizBattleUiTokens {
  // ===== Colors =====

  static const Color pageBackground = Color(0xFF06131A);
  static const Color surfacePrimary = Color(0xFF0D1F29);
  static const Color surfaceSecondary = Color(0xFF122A36);
  static const Color surfaceTertiary = Color(0xFF173544);

  static const Color borderPrimary = Color(0xFF244657);
  static const Color borderSoft = Color(0x332D5B70);

  static const Color textPrimary = Color(0xFFF4FBFF);
  static const Color textSecondary = Color(0xFFB8CBD6);
  static const Color textMuted = Color(0xFF89A1AF);

  static const Color success = Color(0xFF21C67A);
  static const Color warning = Color(0xFFFFB547);
  static const Color danger = Color(0xFFFF5D5D);
  static const Color info = Color(0xFF57B8FF);

  static const Color boardTileAvailableTop = Color(0xFF1D4F8C);
  static const Color boardTileAvailableBottom = Color(0xFF143A67);

  static const Color boardTileUsedTop = Color(0xFF22333D);
  static const Color boardTileUsedBottom = Color(0xFF18262F);

  static const Color highlightTop = Color(0xFF17C3B2);
  static const Color highlightBottom = Color(0xFF0E8FA0);

  // ===== Gradients =====

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF0A1B24),
      Color(0xFF07141B),
      Color(0xFF051017),
    ],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF1AC8B9),
      Color(0xFF0FA3B1),
    ],
  );

  static const LinearGradient boardTileAvailableGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      boardTileAvailableTop,
      boardTileAvailableBottom,
    ],
  );

  static const LinearGradient boardTileUsedGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      boardTileUsedTop,
      boardTileUsedBottom,
    ],
  );

  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF23D2C3),
      Color(0xFF1497A8),
    ],
  );

  // ===== Radius =====

  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 22;
  static const double radiusXl = 28;

  // ===== Spacing =====

  static const double space2 = 2;
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space28 = 28;
  static const double space32 = 32;

  // ===== Elevation / Shadow =====

  static const List<BoxShadow> softShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> strongShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x44000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  // ===== Border Radius =====

  static BorderRadius get cardRadius =>
      BorderRadius.circular(radiusLg);

  static BorderRadius get tileRadius =>
      BorderRadius.circular(radiusMd);

  static BorderRadius get chipRadius =>
      BorderRadius.circular(radiusXl);

  // ===== Text Styles =====

  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    height: 1.15,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.35,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textMuted,
    height: 1.3,
  );

  static const TextStyle scoreValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: textPrimary,
    height: 1,
  );

  static const TextStyle boardValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: textPrimary,
    height: 1,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1,
  );

  // ===== Decorations =====

  static BoxDecoration primaryCardDecoration({
    Color? color,
    Gradient? gradient,
    Border? border,
  }) {
    return BoxDecoration(
      color: gradient == null ? (color ?? surfacePrimary) : null,
      gradient: gradient,
      borderRadius: cardRadius,
      border: border ??
          Border.all(
            color: borderPrimary,
            width: 1,
          ),
      boxShadow: softShadow,
    );
  }

  static BoxDecoration secondaryCardDecoration() {
    return BoxDecoration(
      color: surfaceSecondary,
      borderRadius: cardRadius,
      border: Border.all(
        color: borderSoft,
        width: 1,
      ),
      boxShadow: softShadow,
    );
  }

  static BoxDecoration boardTileDecoration({
    required bool isUsed,
  }) {
    return BoxDecoration(
      gradient: isUsed
          ? boardTileUsedGradient
          : boardTileAvailableGradient,
      borderRadius: tileRadius,
      border: Border.all(
        color: isUsed ? borderSoft : borderPrimary,
        width: 1.2,
      ),
      boxShadow: strongShadow,
    );
  }

  static BoxDecoration highlightedCardDecoration() {
    return BoxDecoration(
      gradient: headerGradient,
      borderRadius: cardRadius,
      boxShadow: strongShadow,
    );
  }

  // ===== Insets =====

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: space16,
    vertical: space16,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(space16);

  static const EdgeInsets tilePadding = EdgeInsets.all(space12);

  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: space12,
    vertical: space8,
  );
}