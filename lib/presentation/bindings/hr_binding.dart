import 'package:get/get.dart';

/// Bindings for HR pages - minimal dependencies to avoid infinite loops
class HrBinding extends Bindings {
  @override
  void dependencies() {
    // ProfileController is already registered globally in InitialBindings
    // No additional dependencies needed
  }
}
