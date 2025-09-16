import 'package:get/get.dart';

/// Bindings for candidate pages - minimal dependencies to avoid infinite loops
class CandidateBinding extends Bindings {
  @override
  void dependencies() {
    // ProfileController and AudioSearchController are already registered globally in InitialBindings
    // No additional dependencies needed
  }
}
