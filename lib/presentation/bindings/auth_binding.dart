import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is already registered globally in InitialBindings
    // This binding is kept for route-specific dependencies if needed in the future
  }
}
