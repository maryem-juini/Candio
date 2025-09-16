import 'dart:typed_data';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    try {
      final userCredential = await repository.signInWithEmailAndPassword(
        email,
        password,
      );
      if (userCredential.user != null) {
        return await repository.getUserFromFirestore(userCredential.user!.uid);
      }
      return null;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity?> call(
    String email,
    String password,
    UserEntity userData,
  ) async {
    try {
      final userCredential = await repository.createUserWithEmailAndPassword(
        email,
        password,
      );
      if (userCredential.user != null) {
        final user = userData.copyWith(uid: userCredential.user!.uid);
        await repository.saveUserToFirestore(user);
        return user;
      }
      return null;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> call() async {
    try {
      await repository.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }
}

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email) async {
    try {
      await repository.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() async {
    try {
      return await repository.getCurrentUser();
    } catch (e) {
      throw Exception('Get current user failed: $e');
    }
  }
}

class GetUserByIdUseCase {
  final AuthRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<UserEntity?> call(String uid) async {
    try {
      return await repository.getUserFromFirestore(uid);
    } catch (e) {
      throw Exception('Get user by ID failed: $e');
    }
  }
}

class UploadProfilePictureUseCase {
  final AuthRepository repository;

  UploadProfilePictureUseCase(this.repository);

  Future<String> call(String filePath) async {
    try {
      return await repository.uploadProfilePicture(filePath);
    } catch (e) {
      throw Exception('Upload profile picture failed: $e');
    }
  }
}

class UploadCVUseCase {
  final AuthRepository repository;

  UploadCVUseCase(this.repository);

  Future<String> call(String filePath) async {
    try {
      return await repository.uploadCV(filePath);
    } catch (e) {
      throw Exception('Upload CV failed: $e');
    }
  }
}

class UploadProfilePictureFromBytesUseCase {
  final AuthRepository repository;

  UploadProfilePictureFromBytesUseCase(this.repository);

  Future<String> call(Uint8List bytes, String fileName) async {
    try {
      return await repository.uploadProfilePictureFromBytes(bytes, fileName);
    } catch (e) {
      throw Exception('Upload profile picture failed: $e');
    }
  }
}

class UploadCVFromBytesUseCase {
  final AuthRepository repository;

  UploadCVFromBytesUseCase(this.repository);

  Future<String> call(Uint8List bytes, String fileName) async {
    try {
      return await repository.uploadCVFromBytes(bytes, fileName);
    } catch (e) {
      throw Exception('Upload CV failed: $e');
    }
  }
}

class UpdateUserFavoritesUseCase {
  final AuthRepository repository;

  UpdateUserFavoritesUseCase(this.repository);

  Future<void> call(String uid, List<String> favorites) async {
    try {
      await repository.updateUserFavorites(uid, favorites);
    } catch (e) {
      throw Exception('Update user favorites failed: $e');
    }
  }
}
