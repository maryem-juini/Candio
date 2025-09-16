import 'dart:async';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../controllers/onboarding_controller.dart';
import '../../domain/usecases/auth_usecases.dart';

class SplashController extends GetxController {
  SplashController({required GetCurrentUserUseCase getCurrentUserUseCase})
    : _getCurrentUserUseCase = getCurrentUserUseCase;

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  Timer? _timer;
  static const Duration _splashDelay = Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final user = await _getCurrentUserUseCase();
      final bool isSignedIn = user != null;

      if (isSignedIn) {
        if (user.role == 'candidate') {
          _timer = Timer(
            _splashDelay,
            () => Get.offAllNamed(AppRoutes.candidateMain),
          );
        } else if (user.role == 'hr') {
          _timer = Timer(_splashDelay, () => Get.offAllNamed(AppRoutes.hrMain));
        } else {
          // Fallback to auth if role is not recognized
          _timer = Timer(_splashDelay, () => Get.offAllNamed(AppRoutes.onboarding));
        }
      } else {
        // User is not authenticated, check onboarding status
        final isOnboardingComplete =
            await OnboardingController.isOnboardingComplete();

        if (isOnboardingComplete) {
          _timer = Timer(_splashDelay, () => Get.offAllNamed(AppRoutes.onboarding));
        } else {
          _timer = Timer(
            _splashDelay,
            () => Get.offAllNamed(AppRoutes.onboarding),
          );
        }
      }
    } catch (_) {
      // If there's an error, default to onboarding
      final isOnboardingComplete =
          await OnboardingController.isOnboardingComplete();

      if (isOnboardingComplete) {
        _timer = Timer(_splashDelay, () => Get.offAllNamed(AppRoutes.onboarding));
      } else {
        _timer = Timer(
          _splashDelay,
          () => Get.offAllNamed(AppRoutes.onboarding),
        );
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
