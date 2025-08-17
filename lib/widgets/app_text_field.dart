import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

/// A highly customizable text field widget that supports various input types,
/// validation, styling, and accessibility features.
class AppTextField extends StatefulWidget {
  /// Text editing controller (optional - will create one if not provided)
  final TextEditingController? controller;

  /// Initial value for the text field
  final String? initialValue;

  /// Label text to display above the text field
  final String? label;

  /// Hint text to display when the field is empty
  final String? hint;

  /// Whether to show an asterisk for required fields
  final bool isRequired;

  /// Whether the field is read-only
  final bool readOnly;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Whether to show password toggle button
  final bool showPasswordToggle;

  /// Whether the field is in loading/validating state
  final bool isLoading;

  /// Whether the field is required
  final bool isRequiredField;

  /// Maximum number of characters allowed
  final int? maxLength;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Whether the field should expand vertically
  final bool expands;

  /// Keyboard type for the text field
  final TextInputType? keyboardType;

  /// Text capitalization mode
  final TextCapitalization textCapitalization;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Whether to enable autocorrect
  final bool autocorrect;

  /// Whether to enable suggestions
  final bool enableSuggestions;

  /// Whether to enable IMEPersonalizedLearning
  final bool enableIMEPersonalizedLearning;

  /// Focus node for the text field
  final FocusNode? focusNode;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when text is submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when field is tapped
  final VoidCallback? onTap;

  /// Validation function
  final String? Function(String?)? validator;

  /// Debounce duration for onChanged events
  final Duration? debounceDuration;

  /// Whether to auto-scroll into view when focused
  final bool autoScrollIntoView;

  // Styling properties
  /// Custom text style
  final TextStyle? textStyle;

  /// Custom hint style
  final TextStyle? hintStyle;

  /// Custom label style
  final TextStyle? labelStyle;

  /// Custom error text style
  final TextStyle? errorStyle;

  /// Border color
  final Color? borderColor;

  /// Focused border color
  final Color? focusedBorderColor;

  /// Error border color
  final Color? errorBorderColor;

  /// Border width
  final double? borderWidth;

  /// Border radius
  final double? borderRadius;

  /// Fill color
  final Color? fillColor;

  /// Cursor color
  final Color? cursorColor;

  /// Cursor height
  final double? cursorHeight;

  /// Padding around the text field
  final EdgeInsetsGeometry? padding;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  // Widget properties
  /// Prefix widget (icon, text, etc.)
  final Widget? prefix;

  /// Suffix widget (icon, button, etc.)
  final Widget? suffix;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Prefix icon color
  final Color? prefixIconColor;

  /// Suffix icon color
  final Color? suffixIconColor;

  /// Prefix icon size
  final double? prefixIconSize;

  /// Suffix icon size
  final double? suffixIconSize;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Autofill hints
  final Iterable<String>? autofillHints;

  /// Whether to enable autofill
  final bool enableAutofill;

  /// Whether to show cursor
  final bool showCursor;

  /// Whether to enable selection
  final bool enableInteractiveSelection;

  /// Whether to enable copy/paste
  final bool enableCopyPaste;

  /// Whether to enable spell check
  final bool enableSpellCheck;

  final TextDirection textDirection;

  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.isRequired = false,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.showPasswordToggle = true,
    this.isLoading = false,
    this.isRequiredField = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.enableIMEPersonalizedLearning = true,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.debounceDuration,
    this.autoScrollIntoView = true,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.fillColor,
    this.cursorColor,
    this.cursorHeight,
    this.padding,
    this.contentPadding,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.prefixIconSize,
    this.suffixIconSize,
    this.inputFormatters,
    this.autofillHints,
    this.enableAutofill = true,
    this.showCursor = true,
    this.enableInteractiveSelection = true,
    this.enableCopyPaste = true,
    this.enableSpellCheck = true,
    this.textDirection = TextDirection.ltr,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFocusChanged() {
    if (widget.autoScrollIntoView && _focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _onChanged(String value) {
    if (widget.debounceDuration != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDuration!, () {
        widget.onChanged?.call(value);
      });
    } else {
      widget.onChanged?.call(value);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get effective styles
    final effectiveTextStyle = _getTextStyle(theme, isDark);
    final effectiveHintStyle = _getHintStyle(theme, isDark);
    final effectiveLabelStyle = _getLabelStyle(theme, isDark);
    //final effectiveErrorStyle = _getErrorStyle(theme, isDark);

    // Get effective colors
    final effectiveBorderColor = _getBorderColor(theme, isDark);
    final effectiveFillColor = _getFillColor(theme, isDark);
    final effectiveCursorColor = _getCursorColor(theme, isDark);

    // Get effective dimensions
    final effectiveBorderRadius = widget.borderRadius ?? 8.0;
    final effectiveBorderWidth = widget.borderWidth ?? 1.0;
    final effectivePadding = widget.padding ?? const EdgeInsets.all(0);
    final effectiveContentPadding =
        widget.contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    // Build prefix widget
    final prefixWidget = _buildPrefixWidget(theme, isDark);

    // Build suffix widget
    final suffixWidget = _buildSuffixWidget(theme, isDark);

    return Padding(
      padding: effectivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (widget.label != null) ...[
            Row(
              children: [
                Text(widget.label!, style: effectiveLabelStyle),
                if (widget.isRequired || widget.isRequiredField) ...[
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: effectiveLabelStyle.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Text Field
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            readOnly: widget.readOnly,
            textDirection: widget.textDirection,
            enabled: widget.enabled && !widget.isLoading,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            expands: widget.expands,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.textInputAction,
            autocorrect: widget.autocorrect,
            enableSuggestions: widget.enableSuggestions,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
            inputFormatters: widget.inputFormatters,
            autofillHints: widget.enableAutofill ? widget.autofillHints : null,
            showCursor: widget.showCursor,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            cursorColor: effectiveCursorColor,
            cursorHeight: widget.cursorHeight,
            style: effectiveTextStyle,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: effectiveHintStyle,
              hintTextDirection: widget.textDirection,
              filled: true,
              fillColor: effectiveFillColor,
              contentPadding: effectiveContentPadding,
              prefixIcon: prefixWidget,
              suffixIcon: suffixWidget,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                borderSide: BorderSide(
                  color: effectiveBorderColor,
                  width: effectiveBorderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                borderSide: BorderSide(
                  color: effectiveBorderColor,
                  width: effectiveBorderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? theme.colorScheme.primary,
                  width: effectiveBorderWidth + 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                borderSide: BorderSide(
                  color: widget.errorBorderColor ?? theme.colorScheme.error,
                  width: effectiveBorderWidth,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                borderSide: BorderSide(
                  color: widget.errorBorderColor ?? theme.colorScheme.error,
                  width: effectiveBorderWidth + 1,
                ),
              ),
            ),
            onChanged: _onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            validator: _validate,
          ),

          // Error Text - Removed internal error display
          // Form validation will handle error display
        ],
      ),
    );
  }

  Widget? _buildPrefixWidget(ThemeData theme, bool isDark) {
    if (widget.prefix != null) return widget.prefix;

    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        color:
            widget.prefixIconColor ??
            (isDark ? Colors.grey[400] : Colors.grey[600]),
        size: widget.prefixIconSize ?? 20,
      );
    }

    return null;
  }

  Widget? _buildSuffixWidget(ThemeData theme, bool isDark) {
    if (widget.suffix != null) return widget.suffix;

    // Loading indicator
    if (widget.isLoading) {
      return SizedBox(
        width: widget.suffixIconSize ?? 20,
        height: widget.suffixIconSize ?? 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      );
    }

    // Password toggle
    if (widget.obscureText && widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color:
              widget.suffixIconColor ??
              (isDark ? Colors.grey[400] : Colors.grey[600]),
          size: widget.suffixIconSize ?? 20,
        ),
        onPressed: _togglePasswordVisibility,
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return Icon(
        widget.suffixIcon,
        color:
            widget.suffixIconColor ??
            (isDark ? Colors.grey[400] : Colors.grey[600]),
        size: widget.suffixIconSize ?? 20,
      );
    }

    return null;
  }

  TextStyle _getTextStyle(ThemeData theme, bool isDark) {
    final baseStyle = AppTheme.body1Medium.copyWith(
      color: isDark ? Colors.white : Colors.black87,
    );

    return widget.textStyle?.merge(baseStyle) ?? baseStyle;
  }

  TextStyle _getHintStyle(ThemeData theme, bool isDark) {
    final baseStyle = AppTheme.body1Medium.copyWith(
      color: isDark ? Colors.grey[400] : Colors.grey[600],
    );

    return widget.hintStyle?.merge(baseStyle) ?? baseStyle;
  }

  TextStyle _getLabelStyle(ThemeData theme, bool isDark) {
    final baseStyle = AppTheme.body2Semibold.copyWith(
      color: isDark ? Colors.white : Colors.black87,
    );

    return widget.labelStyle?.merge(baseStyle) ?? baseStyle;
  }

  // TextStyle _getErrorStyle(ThemeData theme, bool isDark) {
  //   final baseStyle = AppTheme.captionMedium.copyWith(
  //     color: theme.colorScheme.error,
  //   );

  //   return widget.errorStyle?.merge(baseStyle) ?? baseStyle;
  // }

  Color _getBorderColor(ThemeData theme, bool isDark) {
    return widget.borderColor ??
        (isDark ? Colors.grey[600]! : Colors.grey[400]!);
  }

  Color _getFillColor(ThemeData theme, bool isDark) {
    return widget.fillColor ?? (isDark ? Colors.grey[800]! : Colors.grey[100]!);
  }

  Color _getCursorColor(ThemeData theme, bool isDark) {
    return widget.cursorColor ?? theme.colorScheme.primary;
  }
}
