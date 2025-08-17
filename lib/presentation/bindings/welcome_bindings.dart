import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
