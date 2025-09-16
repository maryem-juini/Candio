import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? firstButtonLabel;
  final String? secondButtonLabel;
  final VoidCallback? onFirstButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final Color? titleColor;
  final AppButtonVariant? firstButtonVariant;
  final AppButtonVariant? secondButtonVariant;
  final Color? firstButtonColor;
  final Color? secondButtonColor;
  final IconData? icon;
  final Color? iconColor;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.firstButtonLabel,
    this.secondButtonLabel,
    this.onFirstButtonPressed,
    this.onSecondButtonPressed,
    this.titleColor,
    this.firstButtonVariant,
    this.secondButtonVariant,
    this.firstButtonColor,
    this.secondButtonColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: titleColor ?? Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48, color: iconColor ?? AppTheme.primaryColor),
            const SizedBox(height: 16),
          ],
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (firstButtonLabel != null || secondButtonLabel != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                if (firstButtonLabel != null)
                  Expanded(
                    child: AppButton(
                      variant: firstButtonVariant ?? AppButtonVariant.secondary,
                      label: firstButtonLabel!,
                      onPressed:
                          onFirstButtonPressed ??
                          () => Navigator.of(context).pop(),
                      backgroundColor: firstButtonColor,
                      isExpanded: true,
                    ),
                  ),
                if (firstButtonLabel != null && secondButtonLabel != null)
                  const SizedBox(width: 12),
                if (secondButtonLabel != null)
                  Expanded(
                    child: AppButton(
                      variant: secondButtonVariant ?? AppButtonVariant.primary,
                      label: secondButtonLabel!,
                      onPressed:
                          onSecondButtonPressed ??
                          () => Navigator.of(context).pop(),
                      backgroundColor: secondButtonColor,
                      isExpanded: true,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
