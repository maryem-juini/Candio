import 'package:flutter/cupertino.dart';

import 'data_seeding_service.dart';

class DevelopmentService {
  static final DataSeedingService _dataSeedingService = DataSeedingService();

  /// Seeds the database with sample data for development/testing
  static Future<void> seedDatabase() async {
    try {
      debugPrint('🔄 Starting database seeding...');
      await _dataSeedingService.seedDatabase();
      debugPrint('✅ Database seeding completed successfully!');
    } catch (e) {
      debugPrint('❌ Error seeding database: $e');
    }
  }

  /// Clears all sample data from the database
  static Future<void> clearSampleData() async {
    try {
      debugPrint('🔄 Clearing sample data...');
      await _dataSeedingService.clearSampleData();
      debugPrint('✅ Sample data cleared successfully!');
    } catch (e) {
      debugPrint('❌ Error clearing sample data: $e');
    }
  }

  /// Resets the database by clearing and reseeding
  static Future<void> resetDatabase() async {
    try {
      debugPrint('🔄 Resetting database...');
      await clearSampleData();
      await seedDatabase();
      debugPrint('✅ Database reset completed successfully!');
    } catch (e) {
      debugPrint('❌ Error resetting database: $e');
    }
  }
}
