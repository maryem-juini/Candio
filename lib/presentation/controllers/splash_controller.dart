import 'dart:async';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  final isLoading = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startLoading() {
    // Simulate loading for 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      isLoading.value = false;
      _navigateToWelcome();
    });
  }

  void _navigateToWelcome() {
    Get.offAllNamed(AppRoutes.welcome);
  }
}
