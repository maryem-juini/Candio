import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await getUserFromFirestore(user.uid);
    }
    return null;
  }

  @override
  Future<void> saveUserToFirestore(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
  }

  @override
  Future<UserEntity?> getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final userModel = UserModel.fromJson(doc.data()!);
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user from Firestore: $e');
    }
  }

  @override
  Future<void> updateUserInFirestore(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(userModel.toJson());
  }

  @override
  Future<void> deleteUserFromFirestore(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    try {
      debugPrint('Starting profile picture upload for path: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      // Read the file as bytes and convert to base64
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      // Create a data URL for the image
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      debugPrint('Profile picture converted to base64 successfully');

      return dataUrl;
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  @override
  Future<String> uploadCV(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      // Read the file as bytes and convert to base64
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      // Create a data URL for the CV
      final dataUrl = 'data:application/pdf;base64,$base64String';

      return dataUrl;
    } catch (e) {
      throw Exception('Failed to upload CV: $e');
    }
  }

  @override
  Future<String> uploadProfilePictureFromBytes(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      // Convert bytes to base64
      final base64String = base64Encode(bytes);

      // Create a data URL for the image
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      return dataUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  @override
  Future<String> uploadCVFromBytes(Uint8List bytes, String fileName) async {
    try {
      // Convert bytes to base64
      final base64String = base64Encode(bytes);

      // Create a data URL for the CV
      final dataUrl = 'data:application/pdf;base64,$base64String';

      return dataUrl;
    } catch (e) {
      throw Exception('Failed to upload CV: $e');
    }
  }

  @override
  Future<void> updateUserFavorites(String uid, List<String> favorites) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favorites': favorites,
      });
    } catch (e) {
      throw Exception('Failed to update user favorites: $e');
    }
  }
}
