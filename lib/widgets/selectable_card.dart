// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'custom_text.dart';
import '../core/theme/app_theme.dart';

/// A custom card widget that can be selected or unselected
/// Used for gender and country selection in onboarding
class SelectableCard extends StatelessWidget {
  /// The title text to display
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional icon to display
  final IconData? icon;

  /// Whether the card is currently selected
  final bool isSelected;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Custom background color when selected
  final Color? selectedColor;

  /// Custom border color when selected
  final Color? selectedBorderColor;

  /// Custom text color when selected
  final Color? selectedTextColor;

  /// Custom icon color when selected
  final Color? selectedIconColor;

  /// Border radius for the card
  final double? borderRadius;

  /// Padding inside the card
  final EdgeInsetsGeometry? padding;

  /// Whether to show a checkmark when selected
  final bool showCheckmark;

  const SelectableCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
    this.selectedBorderColor,
    this.selectedTextColor,
    this.selectedIconColor,
    this.borderRadius,
    this.padding,
    this.showCheckmark = true,
  });

  @override
  Widget build(BuildContext context) {
    // Get effective colors based on selection state
    final effectiveBackgroundColor = _getBackgroundColor();
    final effectiveBorderColor = _getBorderColor();
    final effectiveTextColor = _getTextColor();
    final effectiveIconColor = _getIconColor();

    // Get effective dimensions
    final effectiveBorderRadius = borderRadius ?? 12.0;
    final effectivePadding = padding ?? const EdgeInsets.all(16.0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          border: Border.all(
            color: effectiveBorderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: (selectedColor ?? AppTheme.primaryColor)
                          .withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Row(
          children: [
            // Icon
            if (icon != null) ...[
              Icon(icon, color: effectiveIconColor, size: 24),
              const SizedBox(width: 12),
            ],

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.body(
                    title,
                    color: effectiveTextColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    CustomText.bodySmall(
                      subtitle!,
                      color: effectiveTextColor.withOpacity(0.7),
                    ),
                  ],
                ],
              ),
            ),

            // Checkmark when selected
            if (isSelected && showCheckmark) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                color: selectedColor ?? AppTheme.primaryColor,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return selectedColor?.withOpacity(0.1) ??
          AppTheme.primaryColor.withOpacity(0.1);
    }
    return AppTheme.backgroundColor;
  }

  Color _getBorderColor() {
    if (isSelected) {
      return selectedBorderColor ?? AppTheme.primaryColor;
    }
    return AppTheme.primaryColor.withOpacity(0.3);
  }

  Color _getTextColor() {
    if (isSelected) {
      return selectedTextColor ?? AppTheme.primaryColor;
    }
    return AppTheme.onBackgroundColor;
  }

  Color _getIconColor() {
    if (isSelected) {
      return selectedIconColor ?? AppTheme.primaryColor;
    }
    return AppTheme.onBackgroundColor.withOpacity(0.6);
  }
}
