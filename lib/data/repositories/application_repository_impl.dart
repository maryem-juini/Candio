import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/repositories/application_repository.dart';
import '../models/application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ApplicationEntity>> getApplicationsByJobOffer(
    String jobOfferId,
  ) async {
    try {
      debugPrint('Fetching applications for job offer: $jobOfferId');

      final querySnapshot =
          await _firestore
              .collection('applications')
              .where('jobOfferId', isEqualTo: jobOfferId)
              .get();

      debugPrint(
        'Found ${querySnapshot.docs.length} applications for job offer: $jobOfferId',
      );

      final applications =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>? ?? {};
                debugPrint('Application data: $data');
                return ApplicationModel.fromJson({...data, 'id': doc.id});
              })
              .map((model) => model.toEntity())
              .toList();

      // Sort by appliedAt descending manually
      applications.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

      return applications;
    } catch (e) {
      debugPrint('Error fetching applications by job offer: $e');
      throw Exception('Failed to fetch applications: $e');
    }
  }

  @override
  Future<List<ApplicationEntity>> getApplicationsByCandidate(
    String candidateId,
  ) async {
    try {
      debugPrint('Fetching applications for candidate: $candidateId');

      final querySnapshot =
          await _firestore
              .collection('applications')
              .where('candidateId', isEqualTo: candidateId)
              .get();

      debugPrint(
        'Found ${querySnapshot.docs.length} applications for candidate: $candidateId',
      );

      final applications =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>? ?? {};
                debugPrint('Application data: $data');
                return ApplicationModel.fromJson({...data, 'id': doc.id});
              })
              .map((model) => model.toEntity())
              .toList();

      // Sort by appliedAt descending manually
      applications.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

      return applications;
    } catch (e) {
      debugPrint('Error fetching applications by candidate: $e');
      throw Exception('Failed to fetch candidate applications: $e');
    }
  }

  @override
  Future<ApplicationEntity?> getApplicationById(String id) async {
    try {
      final doc = await _firestore.collection('applications').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return ApplicationModel.fromJson({...data, 'id': doc.id}).toEntity();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch application: $e');
    }
  }

  @override
  Future<ApplicationEntity> createApplication(
    ApplicationEntity application,
  ) async {
    try {
      debugPrint(
        'Creating application for candidate: ${application.candidateId}, job: ${application.jobOfferId}',
      );

      final applicationData = ApplicationModel.fromEntity(application).toJson();
      debugPrint('Application data to save: $applicationData');

      final docRef = await _firestore
          .collection('applications')
          .add(applicationData);

      debugPrint('Application created with ID: ${docRef.id}');

      return application.copyWith(id: docRef.id);
    } catch (e) {
      debugPrint('Error creating application: $e');
      throw Exception('Failed to create application: $e');
    }
  }

  @override
  Future<ApplicationEntity> updateApplicationStatus(
    String id,
    ApplicationStatus status,
  ) async {
    try {
      final updateData = {
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('applications').doc(id).update(updateData);

      final updatedDoc =
          await _firestore.collection('applications').doc(id).get();
      final data = updatedDoc.data()!;
      return ApplicationModel.fromJson({...data, 'id': id}).toEntity();
    } catch (e) {
      throw Exception('Failed to update application status: $e');
    }
  }

  @override
  Future<void> deleteApplication(String id) async {
    try {
      await _firestore.collection('applications').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete application: $e');
    }
  }

  @override
  Future<bool> hasCandidateApplied(
    String candidateId,
    String jobOfferId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('applications')
              .where('candidateId', isEqualTo: candidateId)
              .where('jobOfferId', isEqualTo: jobOfferId)
              .limit(1)
              .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check application status: $e');
    }
  }
}
