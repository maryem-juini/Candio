// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final Color itemColor;
  final String itemText;
  final int itemCount;

  const ProfileItem({
    super.key,
    required this.itemColor,
    required this.itemText,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 64,
      decoration: BoxDecoration(
        color: itemColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: itemColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            itemCount.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: itemColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            itemText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: itemColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

