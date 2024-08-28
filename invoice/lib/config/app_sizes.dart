import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppStyle globalStyle = AppStyle();

@immutable
class AppStyle {
  AppStyle({Size? screenSize, Orientation? orientation}) {
    if (screenSize == null || orientation == null) {
      scale = 1;
      return;
    }
    final shortestSide = screenSize.shortestSide;
    // final shortestSide = orientation == Orientation.landscape ? screenSize.longestSide : screenSize.shortestSide;
    // print("Shortestside: $shortestSide ");
    // ignore: unused_local_variable
    const desktop = 1200;
    const tabletXl = 1000;
    const tabletLg = 800;
    const tabletSm = 600;
    const phoneLg = 400;
    if (shortestSide > tabletXl) {
      scale = 1.65;
    } else if (shortestSide > tabletLg) {
      scale = 1.50;
    } else if (shortestSide > tabletSm) {
      scale = 1.35;
    } else if (shortestSide > phoneLg) {
      scale = .9; // phone
    } else {
      scale = .85; // small phone
    }
    debugPrint('screenSize=$screenSize, scale=$scale');

    isSmall = display.size.shortestSide / display.devicePixelRatio < 525;

    final orientations = <DeviceOrientation>[];

    if (!isSmall) {
      orientations.addAll([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    if (isSmall) {
      orientations.addAll([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    SystemChrome.setPreferredOrientations(orientations);
  }

  Display get display => PlatformDispatcher.instance.displays.first;

  late final double scale;

  late final bool isSmall;

  /// The current theme colors for the app
  // final AppColors colors = AppColors();

  /// Check type of device
  // bool get isTabletXl => scale >= ;

  /// Rounded edge corner radii
  // ignore: library_private_types_in_public_api
  late final _Corners corners = _Corners();

  // ignore: library_private_types_in_public_api
  late final _Shadows shadows = _Shadows();

  /// Padding and margin values
  // ignore: library_private_types_in_public_api
  late final _Insets insets = _Insets(scale);

  /// Text styles
  // ignore: library_private_types_in_public_api
  late final _Text text = _Text(scale);

  /// Animation Durations
  // final _Times times = _Times();

  /// Shared sizes
  // ignore: library_private_types_in_public_api
  late final _Sizes sizes = _Sizes();
}

@immutable
class _Text {
  _Text(this._scale);
  final double _scale;

  // final Map<String, TextStyle> _titleFonts = {
  //   'en': TextStyle(fontFamily: 'Tenor'),
  // };
  //
  // final Map<String, TextStyle> _monoTitleFonts = {
  //   'en': TextStyle(fontFamily: 'B612Mono'),
  // };
  //
  // final Map<String, TextStyle> _quoteFonts = {
  //   'en': TextStyle(fontFamily: 'Cinzel'),
  //   'zh': TextStyle(fontFamily: 'MaShanZheng'),
  // };
  //
  // final Map<String, TextStyle> _wonderTitleFonts = {
  //   'en': TextStyle(fontFamily: 'Yeseva'),
  // };
  //
  // final Map<String, TextStyle> _contentFonts = {
  //   'en': TextStyle(fontFamily: 'Raleway', fontFeatures: const [
  //     FontFeature.enable('kern'),
  //   ]),
  // };
  //
  // TextStyle _getFontForLocale(Map<String, TextStyle> fonts) {
  //   if (localeLogic.isLoaded) {
  //     return fonts.entries.firstWhere((x) => x.key == $strings.localeName, orElse: () => fonts.entries.first).value;
  //   } else {
  //     return fonts.entries.first.value;
  //   }
  // }

  TextStyle get titleFont => const TextStyle(fontFamily: 'Inter');
  TextStyle get quoteFont => const TextStyle(fontFamily: 'Inter');
  TextStyle get wonderTitleFont => const TextStyle(fontFamily: 'Inter');
  TextStyle get contentFont => const TextStyle(fontFamily: 'Inter');
  TextStyle get monoTitleFont => const TextStyle(fontFamily: 'Inter');

  late final TextStyle dropCase =
      _createFont(quoteFont, sizePx: 56, heightPx: 20);

  late final TextStyle wonderTitle =
      _createFont(wonderTitleFont, sizePx: 64, heightPx: 56);

  late final TextStyle h1 = _createFont(titleFont, sizePx: 64, heightPx: 62);
  late final TextStyle h2 =
      _createFont(titleFont, sizePx: 48, heightPx: 46, weight: FontWeight.bold);
  late final TextStyle h3 =
      _createFont(titleFont, sizePx: 32, heightPx: 36, weight: FontWeight.w600);
  late final TextStyle h4 = _createFont(contentFont,
      sizePx: 24, heightPx: 23, weight: FontWeight.bold);
  late final TextStyle h5 = _createFont(contentFont,
      sizePx: 19, heightPx: 23, weight: FontWeight.bold);
  late final TextStyle h6 = _createFont(contentFont, sizePx: 19, heightPx: 23);
  late final TextStyle tagline =
      _createFont(titleFont, sizePx: 32, heightPx: 36, weight: FontWeight.bold);
  late final TextStyle info = _createFont(contentFont,
      sizePx: 12, heightPx: 20, weight: FontWeight.bold);
  late final TextStyle btn = _createFont(contentFont,
      sizePx: 14, weight: FontWeight.bold, spacingPc: 2, heightPx: 14);
  late final TextStyle btn1 = _createFont(contentFont,
      sizePx: 14, weight: FontWeight.w500, spacingPc: 2, heightPx: 14);
  late final TextStyle receipt = _createFont(contentFont,
      sizePx: 14, weight: FontWeight.normal, spacingPc: 2, heightPx: 14);
  late final TextStyle error = _createFont(contentFont,
      sizePx: 12, heightPx: 20, weight: FontWeight.w600);

  late final TextStyle title1 =
      _createFont(titleFont, sizePx: 14, heightPx: 16);
  late final TextStyle title2 = _createFont(titleFont,
      sizePx: 14, heightPx: 16.38, weight: FontWeight.bold);
  late final TextStyle title3 =
      _createFont(titleFont, sizePx: 16, heightPx: 16, weight: FontWeight.w400);

  late final TextStyle body = _createFont(contentFont,
      sizePx: 16, heightPx: 26, weight: FontWeight.w600);
  late final TextStyle bodyBold = _createFont(contentFont,
      sizePx: 16, heightPx: 26, weight: FontWeight.w600);
  late final TextStyle bodySmall = _createFont(contentFont,
      sizePx: 14, heightPx: 23, weight: FontWeight.w500);
  late final TextStyle bodySmallBold = _createFont(contentFont,
      sizePx: 14, heightPx: 23, weight: FontWeight.w600);
  late final TextStyle bodyExtraSmall =
      _createFont(contentFont, sizePx: 12, heightPx: 20);
  late final TextStyle bodyExtraSmallBold = _createFont(contentFont,
      sizePx: 12, heightPx: 20, weight: FontWeight.w600);

  late final TextStyle quote1 = _createFont(quoteFont,
      sizePx: 32, heightPx: 40, weight: FontWeight.w600, spacingPc: -3);
  late final TextStyle quote2 =
      _createFont(quoteFont, sizePx: 21, heightPx: 32, weight: FontWeight.w400);
  late final TextStyle quote2Sub =
      _createFont(body, sizePx: 16, heightPx: 40, weight: FontWeight.w400);

  late final TextStyle caption = _createFont(contentFont,
          sizePx: 14, heightPx: 20, weight: FontWeight.w500)
      .copyWith(fontStyle: FontStyle.italic);

  late final TextStyle callout = _createFont(contentFont,
          sizePx: 16, heightPx: 26, weight: FontWeight.w600)
      .copyWith(fontStyle: FontStyle.italic);

  TextStyle _createFont(TextStyle style,
      {required double sizePx,
      double? heightPx,
      double? spacingPc,
      FontWeight? weight}) {
    sizePx *= _scale;
    if (heightPx != null) {
      heightPx *= _scale;
    }
    return style.copyWith(
      fontSize: sizePx,
      height: heightPx != null ? (heightPx / sizePx) : style.height,
      letterSpacing:
          spacingPc != null ? sizePx * spacingPc * 0.01 : style.letterSpacing,
      fontWeight: weight,
    );
  }
}

// @immutable
// class _Times {
//   final Duration fast = Duration(milliseconds: 300);
//   final Duration med = Duration(milliseconds: 600);
//   final Duration slow = Duration(milliseconds: 900);
//   final Duration pageTransition = Duration(milliseconds: 200);
// }

@immutable
class _Corners {
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

class _Sizes {
  double get maxContentWidth1 => 800;
  double get maxContentWidth2 => 600;
  double get maxContentWidth3 => 500;
  final Size minAppSize = const Size(380, 650);
}

@immutable
class _Insets {
  _Insets(this._scale);
  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;
}

@immutable
class _Shadows {
  final textSoft = [
    Shadow(
        color: Colors.black.withOpacity(.25),
        offset: const Offset(0, 2),
        blurRadius: 4),
  ];
  final text = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: const Offset(0, 2),
        blurRadius: 2),
  ];
  final textStrong = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: const Offset(0, 4),
        blurRadius: 6),
  ];
}

extension ScaleSizeExtension on num {
  double get scale => this * globalStyle.scale;
}
