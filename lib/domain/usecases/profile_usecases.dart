import '../repositories/profile_repository.dart';
import '../entities/user_entity.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) async {
    try {
      return await repository.updateProfile(user);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call(String currentPassword, String newPassword) async {
    try {
      // Validate password requirements
      if (newPassword.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }

      if (currentPassword == newPassword) {
        throw Exception('New password must be different from current password');
      }

      await repository.changePassword(currentPassword, newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}

class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call(String password) async {
    try {
      await repository.deleteAccount(password);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}

class GetProfileStatisticsUseCase {
  final ProfileRepository repository;

  GetProfileStatisticsUseCase(this.repository);

  Future<Map<String, int>> call(String userId, String role) async {
    try {
      return await repository.getProfileStatistics(userId, role);
    } catch (e) {
      throw Exception('Failed to get profile statistics: $e');
    }
  }
}

class UpdatePreferencesUseCase {
  final ProfileRepository repository;

  UpdatePreferencesUseCase(this.repository);

  Future<void> call(String userId, Map<String, dynamic> preferences) async {
    try {
      await repository.updatePreferences(userId, preferences);
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }
}

class GetPreferencesUseCase {
  final ProfileRepository repository;

  GetPreferencesUseCase(this.repository);

  Future<Map<String, dynamic>> call(String userId) async {
    try {
      return await repository.getPreferences(userId);
    } catch (e) {
      throw Exception('Failed to get preferences: $e');
    }
  }
}

