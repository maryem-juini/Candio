import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final bool showDivider;

  const ProfileOption({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed,
          leading: Icon(
            icon,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          minLeadingWidth: 24,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}
