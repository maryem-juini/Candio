import 'package:get/get.dart';

class WelcomeBindings extends Bindings {
  @override
  void dependencies() {
    // WelcomeController is already registered globally in InitialBindings
    // This binding is kept for route-specific dependencies if needed in the future
  }
}
