import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<UserEntity?> getCurrentUser();
  Future<void> saveUserToFirestore(UserEntity user);
  Future<UserEntity?> getUserFromFirestore(String uid);
  Future<void> updateUserInFirestore(UserEntity user);
  Future<void> deleteUserFromFirestore(String uid);

  // File upload methods
  Future<String> uploadProfilePicture(String filePath);
  Future<String> uploadCV(String filePath);
  Future<String> uploadProfilePictureFromBytes(
    Uint8List bytes,
    String fileName,
  );
  Future<String> uploadCVFromBytes(Uint8List bytes, String fileName);

  // User preferences methods
  Future<void> updateUserFavorites(String uid, List<String> favorites);
}
