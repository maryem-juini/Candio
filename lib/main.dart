import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'init.dart';
import 'core/config/index.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // .env file not found, continue without environment variables
    debugPrint("Warning: .env file not found. Using default configuration.");
  }
  await AppInit.init();

  // Initialize Firebase safely
  await FirebaseConfig.initialize();

  // Uncomment the line below to seed the database with sample data
  // await DevelopmentService.seedDatabase();

  runApp(const AppWidget());
}
