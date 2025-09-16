import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';

/// Firebase configuration helper
class FirebaseConfig {
  static bool _isInitialized = false;

  /// Initialize Firebase safely, preventing duplicate app errors
  static Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint("Firebase already initialized, skipping...");
      return;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _isInitialized = true;
        debugPrint("Firebase initialized successfully");
      } else {
        _isInitialized = true;
        debugPrint("Firebase already initialized, continuing...");
      }
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        _isInitialized = true;
        debugPrint(
          "Firebase already initialized (caught duplicate-app error), continuing...",
        );
      } else {
        debugPrint("Error initializing Firebase: $e");
        rethrow;
      }
    }
  }

  /// Reset initialization state (useful for testing)
  static void reset() {
    _isInitialized = false;
  }
}
