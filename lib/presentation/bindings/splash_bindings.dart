import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../domain/usecases/auth_usecases.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // Register SplashController with GetCurrentUserUseCase dependency
    Get.lazyPut<SplashController>(
      () => SplashController(
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
      ),
    );
  }
}
