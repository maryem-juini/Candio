import 'package:flutter/material.dart';
import '../core/theme/index.dart';

/// A comprehensive custom text widget that handles:
/// - Translation support
/// - Text direction (RTL/LTR)
/// - Text styles with predefined themes
/// - Colors and theming
/// - Soft wrap and text overflow
/// - Text scale factor
/// - Different constructors for common use cases
class CustomText extends StatelessWidget {
  final String text;
  final String? translationKey;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? textScaleFactor;
  final bool enableTranslation;
  final Map<String, String>? translationArgs;

  const CustomText(
    this.text, {
    super.key,
    this.translationKey,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  });

  /// Constructor for large titles (H1)
  CustomText.title(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.heading2Bold,
       fontSize = null,
       fontWeight = null;

  /// Constructor for medium titles (H2)
  CustomText.subtitle(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.heading1Bold,
       fontSize = null,
       fontWeight = null;

  /// Constructor for body text
  CustomText.body(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body1Medium,
       fontSize = null;

  /// Constructor for small body text
  CustomText.bodySmall(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body2Medium,
       fontSize = null;

  /// Constructor for captions
  CustomText.caption(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.captionMedium,
       fontSize = null;

  /// Constructor for labels
  CustomText.label(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body2Semibold,
       fontSize = null;

  /// Constructor for button text
  CustomText.button(
    this.text, {
    super.key,
    this.translationKey,
    this.color,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body1Semibold,
       fontSize = null,
       fontWeight = null;

  /// Constructor for error messages
  CustomText.error(
    this.text, {
    super.key,
    this.translationKey,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body2Medium,
       color = AppTheme.errorColor,
       fontSize = null,
       fontWeight = null;

  /// Constructor for success messages
  CustomText.success(
    this.text, {
    super.key,
    this.translationKey,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body2Medium,
       color = AppTheme.successColor,
       fontSize = null,
       fontWeight = null;

  /// Constructor for warning messages
  CustomText.warning(
    this.text, {
    super.key,
    this.translationKey,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body2Medium,
       color = AppTheme.warningColor,
       fontSize = null,
       fontWeight = null;

  /// Constructor for info messages
  CustomText.info(
    this.text, {
    super.key,
    this.translationKey,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
    this.enableTranslation = false,
    this.translationArgs,
  }) : style = AppTheme.body2Medium,
       color = AppTheme.infoColor,
       fontSize = null,
       fontWeight = null;

  @override
  Widget build(BuildContext context) {
    // Get the final text to display
    final displayText = _getDisplayText();

    // Build the final text style
    final finalStyle = _buildTextStyle(context);

    // Determine text direction
    final finalTextDirection = textDirection ?? _getTextDirection(displayText);

    return Text(
      displayText,
      key: key,
      style: finalStyle,
      textAlign: textAlign,
      textDirection: finalTextDirection,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textScaleFactor: textScaleFactor,
    );
  }

  /// Get the text to display (with translation if enabled)
  String _getDisplayText() {
    if (enableTranslation && translationKey != null) {
      // TODO: Implement translation logic here
      // For now, return the translation key or fallback to text
      return translationKey!;
    }
    return text;
  }

  /// Build the final text style with all customizations
  TextStyle _buildTextStyle(BuildContext context) {
    TextStyle baseStyle = style ?? AppTheme.body1Medium;

    // Apply color
    if (color != null) {
      baseStyle = baseStyle.copyWith(color: color);
    }

    // Apply font size
    if (fontSize != null) {
      baseStyle = baseStyle.copyWith(fontSize: fontSize);
    }

    // Apply font weight
    if (fontWeight != null) {
      baseStyle = baseStyle.copyWith(fontWeight: fontWeight);
    }

    return baseStyle;
  }

  /// Determine text direction based on text content
  TextDirection _getTextDirection(String text) {
    // Check if text contains RTL characters
    final rtlRegex = RegExp(r'[\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC]');
    if (rtlRegex.hasMatch(text)) {
      return TextDirection.rtl;
    }

    // Check if text starts with RTL characters
    if (text.isNotEmpty) {
      final firstChar = text.codeUnitAt(0);
      if (firstChar >= 0x0591 && firstChar <= 0x07FF) {
        return TextDirection.rtl;
      }
    }

    return TextDirection.ltr;
  }

  /// Copy with method for easy modifications
  CustomText copyWith({
    String? text,
    String? translationKey,
    TextStyle? style,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextDirection? textDirection,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    double? textScaleFactor,
    bool? enableTranslation,
    Map<String, String>? translationArgs,
  }) {
    return CustomText(
      text ?? this.text,
      translationKey: translationKey ?? this.translationKey,
      style: style ?? this.style,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      enableTranslation: enableTranslation ?? this.enableTranslation,
      translationArgs: translationArgs ?? this.translationArgs,
    );
  }
}

/// Extension methods for easy text creation
extension CustomTextExtension on String {
  /// Create a title text
  CustomText get title => CustomText.title(this);

  /// Create a subtitle text
  CustomText get subtitle => CustomText.subtitle(this);

  /// Create a body text
  CustomText get body => CustomText.body(this);

  /// Create a small body text
  CustomText get bodySmall => CustomText.bodySmall(this);

  /// Create a caption text
  CustomText get caption => CustomText.caption(this);

  /// Create a label text
  CustomText get label => CustomText.label(this);

  /// Create a button text
  CustomText get button => CustomText.button(this);

  /// Create an error text
  CustomText get error => CustomText.error(this);

  /// Create a success text
  CustomText get success => CustomText.success(this);

  /// Create a warning text
  CustomText get warning => CustomText.warning(this);

  /// Create an info text
  CustomText get info => CustomText.info(this);
}
