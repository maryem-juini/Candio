import '../entities/user_entity.dart';

abstract class ProfileRepository {
  /// Update user profile information
  Future<UserEntity> updateProfile(UserEntity user);

  /// Change user password
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Delete user account
  Future<void> deleteAccount(String password);

  /// Get user profile statistics
  Future<Map<String, int>> getProfileStatistics(String userId, String role);

  /// Update user preferences (notifications, etc.)
  Future<void> updatePreferences(
    String userId,
    Map<String, dynamic> preferences,
  );

  /// Get user preferences
  Future<Map<String, dynamic>> getPreferences(String userId);
}

