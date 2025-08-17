import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// A highly customizable button widget that supports multiple variants,
/// loading states, icons, and accessibility features.
class AppButton extends StatelessWidget {
  /// The button variant to use for styling
  final AppButtonVariant variant;

  /// The callback function when the button is pressed
  final VoidCallback? onPressed;

  /// The child widget to display (takes priority over label)
  final Widget? child;

  /// The text label to display (used if child is null)
  final String? label;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Whether the button is active/enabled
  final bool isActive;

  /// Whether the button should expand to full width
  final bool isExpanded;

  /// Icon to display before the label/child
  final IconData? leadingIcon;

  /// Icon to display after the label/child
  final IconData? trailingIcon;

  /// Custom background color (overrides theme defaults)
  final Color? backgroundColor;

  /// Custom border radius
  final double? borderRadius;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom text style
  final TextStyle? textStyle;

  /// Custom border color (for outline variant)
  final Color? borderColor;

  /// Custom border width (for outline variant)
  final double? borderWidth;

  /// Custom loading indicator color
  final Color? loadingColor;

  /// Custom icon color
  final Color? iconColor;

  /// Custom icon size
  final double? iconSize;

  /// Whether to show splash effects
  final bool showSplash;

  /// Custom height for the button
  final double? height;

  /// Custom minimum width for the button
  final double? minWidth;

  const AppButton({
    super.key,
    this.variant = AppButtonVariant.primary,
    this.onPressed,
    this.child,
    this.label,
    this.isLoading = false,
    this.isActive = true,
    this.isExpanded = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
    this.loadingColor,
    this.iconColor,
    this.iconSize,
    this.showSplash = true,
    this.height,
    this.minWidth,
  }) : assert(
         child != null || label != null,
         'Either child or label must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine if button should be disabled
    final isDisabled = !isActive || isLoading;

    // Get button colors based on variant and state
    final colors = _getButtonColors(context, isDisabled, isDark);

    // Get text style
    final effectiveTextStyle = _getTextStyle(context, colors.textColor);

    // Get border radius
    final effectiveBorderRadius = borderRadius ?? 8.0;

    // Get padding
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

    // Get height
    final effectiveHeight = height ?? 48.0;

    // Get icon size
    final effectiveIconSize = iconSize ?? 20.0;

    // Get icon color
    final effectiveIconColor = iconColor ?? colors.textColor;

    // Get loading color
    final effectiveLoadingColor = loadingColor ?? colors.textColor;

    // Get border properties
    final borderProperties = _getBorderProperties(isDark);

    // Create the button content
    Widget buttonContent = _buildButtonContent(
      context,
      effectiveTextStyle,
      effectiveIconSize,
      effectiveIconColor,
      effectiveLoadingColor,
    );

    // Create the main button container
    Widget button = Container(
      height: effectiveHeight,
      width: isExpanded ? double.infinity : minWidth,
      constraints:
          minWidth != null ? BoxConstraints(minWidth: minWidth!) : null,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: borderProperties.border,
        boxShadow: colors.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Padding(
            padding: effectivePadding,
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );

    // Add semantic label for accessibility
    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: _getAccessibilityLabel(),
      child: button,
    );
  }

  /// Builds the button content (text, icons, loading indicator)
  Widget _buildButtonContent(
    BuildContext context,
    TextStyle textStyle,
    double iconSize,
    Color iconColor,
    Color loadingColor,
  ) {
    if (isLoading) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      );
    }

    final content =
        child ?? Text(label!, style: textStyle, textAlign: TextAlign.center);

    // If no icons, return content as is
    if (leadingIcon == null && trailingIcon == null) {
      return content;
    }

    // Build row with icons and content
    final children = <Widget>[];

    if (leadingIcon != null) {
      children.add(Icon(leadingIcon, size: iconSize, color: iconColor));
      children.add(const SizedBox(width: 8.0));
    }

    children.add(Flexible(child: content));

    if (trailingIcon != null) {
      children.add(const SizedBox(width: 8.0));
      children.add(Icon(trailingIcon, size: iconSize, color: iconColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  /// Gets button colors based on variant and state
  _ButtonColors _getButtonColors(
    BuildContext context,
    bool isDisabled,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    switch (variant) {
      case AppButtonVariant.primary:
        if (isDisabled) {
          return _ButtonColors(
            backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            textColor: isDark ? Colors.grey[600]! : Colors.grey[500]!,
            shadow: [],
          );
        }
        return _ButtonColors(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          textColor: Colors.white,
          shadow: [
            BoxShadow(
              color: (backgroundColor ?? theme.primaryColor).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case AppButtonVariant.secondary:
        if (isDisabled) {
          return _ButtonColors(
            backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            textColor: isDark ? Colors.grey[600]! : Colors.grey[500]!,
            shadow: [],
          );
        }
        return _ButtonColors(
          backgroundColor:
              backgroundColor ??
              (isDark ? Colors.grey[700]! : Colors.grey[100]!),
          textColor: isDark ? Colors.white : Colors.black87,
          shadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        );

      case AppButtonVariant.outline:
        if (isDisabled) {
          return _ButtonColors(
            backgroundColor: Colors.transparent,
            textColor: isDark ? Colors.grey[600]! : Colors.grey[500]!,
            shadow: [],
          );
        }
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          textColor: isDark ? Colors.white : Colors.black87,
          shadow: [],
        );

      case AppButtonVariant.text:
        if (isDisabled) {
          return _ButtonColors(
            backgroundColor: Colors.transparent,
            textColor: isDark ? Colors.grey[600]! : Colors.grey[500]!,
            shadow: [],
          );
        }
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          textColor: backgroundColor ?? theme.primaryColor,
          shadow: [],
        );

      case AppButtonVariant.social:
        if (isDisabled) {
          return _ButtonColors(
            backgroundColor: Colors.transparent,
            textColor: isDark ? Colors.grey[600]! : Colors.grey[500]!,
            shadow: [],
          );
        }
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          textColor: isDark ? Colors.white : Colors.black87,
          shadow: [],
        );
    }
  }

  /// Gets text style for the button
  TextStyle _getTextStyle(BuildContext context, Color textColor) {
    // Use AppTheme's predefined text styles as base
    final baseStyle = AppTheme.body2Medium.copyWith(color: textColor);

    // If custom text style is provided, merge it with base style
    // but ensure the custom style takes precedence
    if (textStyle != null) {
      return textStyle!.copyWith(color: textStyle!.color ?? textColor);
    }

    return baseStyle;
  }

  /// Gets border properties for outline variant
  _BorderProperties _getBorderProperties(bool isDark) {
    if (variant != AppButtonVariant.outline &&
        variant != AppButtonVariant.social) {
      return _BorderProperties(border: null);
    }

    final effectiveBorderColor =
        borderColor ?? (isDark ? Colors.grey[600]! : Colors.grey[400]!);
    final effectiveBorderWidth = borderWidth ?? 1.0;

    return _BorderProperties(
      border: Border.all(
        color: effectiveBorderColor,
        width: effectiveBorderWidth,
      ),
    );
  }

  /// Gets accessibility label for the button
  String _getAccessibilityLabel() {
    if (isLoading) {
      return 'Loading...';
    }

    if (label != null) {
      return label!;
    }

    return 'Button';
  }
}

/// Button variant enum
enum AppButtonVariant { primary, secondary, outline, text, social }

/// Helper class for button colors
class _ButtonColors {
  final Color backgroundColor;
  final Color textColor;
  final List<BoxShadow> shadow;

  const _ButtonColors({
    required this.backgroundColor,
    required this.textColor,
    required this.shadow,
  });
}

/// Helper class for border properties
class _BorderProperties {
  final Border? border;

  const _BorderProperties({this.border});
}
