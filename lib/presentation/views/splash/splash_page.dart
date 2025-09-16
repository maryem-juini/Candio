// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/consts/assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/index.dart';
import '../../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.logoWhite,
              width: 120,
              height: 120,
              color: AppTheme.backgroundColor,
            ),
            const SizedBox(height: 40),

            // App name
            CustomText.title('Candio', color: AppTheme.backgroundColor),
          ],
        ),
      ),
    );
  }
}
