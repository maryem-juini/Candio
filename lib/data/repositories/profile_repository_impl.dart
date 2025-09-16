import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity> updateProfile(UserEntity user) async {
    try {
      // Validate current user
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      if (currentUser.uid != user.uid) {
        throw Exception('Unauthorized: Cannot update another user\'s profile');
      }

      // Update user in Firestore
      final userModel = UserModel.fromEntity(user);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(userModel.toJson());

      // Update email in Firebase Auth if it changed
      if (currentUser.email != user.email) {
        await currentUser.verifyBeforeUpdateEmail(user.email);
      }

      return user;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );
      await currentUser.reauthenticateWithCredential(credential);

      // Change password
      await currentUser.updatePassword(newPassword);
    } catch (e) {
      if (e.toString().contains('wrong-password')) {
        throw Exception('Current password is incorrect');
      }
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Re-authenticate user before deleting account
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );
      await currentUser.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await _firestore.collection('users').doc(currentUser.uid).delete();

      // Delete user account from Firebase Auth
      await currentUser.delete();
    } catch (e) {
      if (e.toString().contains('wrong-password')) {
        throw Exception('Password is incorrect');
      }
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<Map<String, int>> getProfileStatistics(
    String userId,
    String role,
  ) async {
    try {
      final Map<String, int> statistics = {};

      if (role.toLowerCase() == 'candidate') {
        // Get candidate statistics
        final applicationsQuery =
            await _firestore
                .collection('applications')
                .where('candidateId', isEqualTo: userId)
                .get();

        final totalApplications = applicationsQuery.docs.length;
        final acceptedApplications =
            applicationsQuery.docs
                .where((doc) => doc.data()['status'] == 'accepted')
                .length;
        final pendingApplications =
            applicationsQuery.docs
                .where((doc) => doc.data()['status'] == 'pending')
                .length;

        // Get favorites count
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);
        final favoritesCount = favorites.length;

        statistics['applications'] = totalApplications;
        statistics['accepted'] = acceptedApplications;
        statistics['pending'] = pendingApplications;
        statistics['favorites'] = favoritesCount;
      } else if (role.toLowerCase() == 'hr') {
        // Get HR statistics - first get the user's entreprise ID
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final entrepriseId = userDoc.data()?['entrepriseId'];

        if (entrepriseId != null) {
          // Get job offers for this entreprise
          final jobOffersQuery =
              await _firestore
                  .collection('offers')
                  .where('entrepriseId', isEqualTo: entrepriseId)
                  .get();

          final totalJobOffers = jobOffersQuery.docs.length;
          final activeJobOffers =
              jobOffersQuery.docs
                  .where((doc) => doc.data()['isActive'] == true)
                  .length;

          // Get applications for all job offers of this entreprise
          final allApplications = <dynamic>[];
          for (final jobOffer in jobOffersQuery.docs) {
            final applicationsQuery =
                await _firestore
                    .collection('applications')
                    .where('jobOfferId', isEqualTo: jobOffer.id)
                    .get();
            allApplications.addAll(applicationsQuery.docs);
          }

          final totalApplications = allApplications.length;
          final hiredCandidates =
              allApplications
                  .where((doc) => doc.data()['status'] == 'accepted')
                  .length;

          statistics['jobOffers'] = totalJobOffers;
          statistics['activeOffers'] = activeJobOffers;
          statistics['applications'] = totalApplications;
          statistics['hired'] = hiredCandidates;
        } else {
          // If no entreprise ID, set all to 0
          statistics['jobOffers'] = 0;
          statistics['activeOffers'] = 0;
          statistics['applications'] = 0;
          statistics['hired'] = 0;
        }
      }

      return statistics;
    } catch (e) {
     debugPrint ('Error getting profile statistics: $e');
      // Return empty statistics on error
      return {
        'applications': 0,
        'accepted': 0,
        'pending': 0,
        'favorites': 0,
        'jobOffers': 0,
        'activeOffers': 0,
        'hired': 0,
      };
    }
  }

  @override
  Future<void> updatePreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'preferences': preferences,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getPreferences(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Map<String, dynamic>.from(data['preferences'] ?? {});
      }
      return {};
    } catch (e) {
      throw Exception('Failed to get preferences: $e');
    }
  }
}
