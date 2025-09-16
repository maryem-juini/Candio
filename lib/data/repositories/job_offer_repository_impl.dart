import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_offer_entity.dart';
import '../../domain/repositories/job_offer_repository.dart';
import '../models/job_offer_model.dart';

class JobOfferRepositoryImpl implements JobOfferRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<JobOfferEntity>> getAllJobOffers() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('offers')
              .where('isActive', isEqualTo: true)
              .get();

      List<JobOfferEntity> offers =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>? ?? {};
                return JobOfferModel.fromJson({...data, 'id': doc.id});
              })
              .map((model) => model.toEntity())
              .toList();

      // Sort by createdAt in memory (temporary solution until index is created)
      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return offers;
    } catch (e) {
      throw Exception('Failed to fetch job offers: $e');
    }
  }

  @override
  Future<List<JobOfferEntity>> getJobOffersByEntreprise(
    String entrepriseId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('offers')
              .where('entrepriseId', isEqualTo: entrepriseId)
              .where('isActive', isEqualTo: true)
              .get();

      List<JobOfferEntity> offers =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>? ?? {};
                return JobOfferModel.fromJson({...data, 'id': doc.id});
              })
              .map((model) => model.toEntity())
              .toList();

      // Sort by createdAt in memory (temporary solution until index is created)
      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return offers;
    } catch (e) {
      throw Exception('Failed to fetch entreprise job offers: $e');
    }
  }

  @override
  Future<JobOfferEntity?> getJobOfferById(String id) async {
    try {
      final doc = await _firestore.collection('offers').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return JobOfferModel.fromJson({...data, 'id': doc.id}).toEntity();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch job offer: $e');
    }
  }

  @override
  Future<JobOfferEntity> createJobOffer(JobOfferEntity jobOffer) async {
    try {
      final docRef = await _firestore
          .collection('offers')
          .add(JobOfferModel.fromEntity(jobOffer).toJson());
      return jobOffer.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create job offer: $e');
    }
  }

  @override
  Future<JobOfferEntity> updateJobOffer(JobOfferEntity jobOffer) async {
    try {
      await _firestore
          .collection('offers')
          .doc(jobOffer.id)
          .update(JobOfferModel.fromEntity(jobOffer).toJson());
      return jobOffer;
    } catch (e) {
      throw Exception('Failed to update job offer: $e');
    }
  }

  @override
  Future<void> deleteJobOffer(String id) async {
    try {
      await _firestore.collection('offers').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete job offer: $e');
    }
  }

  @override
  Future<List<JobOfferEntity>> searchJobOffers({
    String? location,
    String? contractType,
    String? company,
    List<String>? skills,
    String? searchQuery,
    String? salaryRange,
    String? experienceLevel,
  }) async {
    try {
      Query query = _firestore
          .collection('offers')
          .where('isActive', isEqualTo: true);

      if (location != null && location.isNotEmpty) {
        query = query.where('location', isEqualTo: location);
      }

      if (contractType != null && contractType.isNotEmpty) {
        query = query.where('contractType', isEqualTo: contractType);
      }

      if (company != null && company.isNotEmpty) {
        query = query.where('company', isEqualTo: company);
      }

      final querySnapshot = await query.get();

      List<JobOfferEntity> results =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>? ?? {};
                return JobOfferModel.fromJson({...data, 'id': doc.id});
              })
              .map((model) => model.toEntity())
              .toList();

      // Filter by skills if provided
      if (skills != null && skills.isNotEmpty) {
        results =
            results.where((offer) {
              return skills.any(
                (skill) => offer.requirements.any(
                  (req) => req.toLowerCase().contains(skill.toLowerCase()),
                ),
              );
            }).toList();
      }

      // Filter by search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        results =
            results.where((offer) {
              return offer.title.toLowerCase().contains(query) ||
                  offer.company.toLowerCase().contains(query) ||
                  offer.description.toLowerCase().contains(query) ||
                  offer.location.toLowerCase().contains(query) ||
                  offer.requirements.any(
                    (req) => req.toLowerCase().contains(query),
                  );
            }).toList();
      }

      // Filter by salary range if provided
      if (salaryRange != null &&
          salaryRange.isNotEmpty &&
          salaryRange != 'Tous les salaires') {
        results =
            results.where((offer) {
              if (offer.salaryRange == null) return false;

              final salary = offer.salaryRange!.toLowerCase();
              switch (salaryRange) {
                case '0€ - 30k€':
                  return salary.contains('0') ||
                      salary.contains('30') ||
                      (salary.contains('k') &&
                          !salary.contains('50') &&
                          !salary.contains('70') &&
                          !salary.contains('100'));
                case '30k€ - 50k€':
                  return salary.contains('30') ||
                      salary.contains('40') ||
                      salary.contains('50');
                case '50k€ - 70k€':
                  return salary.contains('50') ||
                      salary.contains('60') ||
                      salary.contains('70');
                case '70k€ - 100k€':
                  return salary.contains('70') ||
                      salary.contains('80') ||
                      salary.contains('90') ||
                      salary.contains('100');
                case '100k€+':
                  return salary.contains('100') || salary.contains('+');
                default:
                  return true;
              }
            }).toList();
      }

      // Filter by experience level if provided
      if (experienceLevel != null &&
          experienceLevel.isNotEmpty &&
          experienceLevel != 'Tous les niveaux') {
        results =
            results.where((offer) {
              final description = offer.description.toLowerCase();
              final requirements = offer.requirements.join(' ').toLowerCase();
              final combined = '$description $requirements';

              switch (experienceLevel) {
                case 'Débutant (0-2 ans)':
                  return combined.contains('débutant') ||
                      combined.contains('junior') ||
                      combined.contains('0') ||
                      combined.contains('1') ||
                      combined.contains('2');
                case 'Intermédiaire (2-5 ans)':
                  return combined.contains('intermédiaire') ||
                      combined.contains('middle') ||
                      combined.contains('2') ||
                      combined.contains('3') ||
                      combined.contains('4') ||
                      combined.contains('5');
                case 'Expérimenté (5-10 ans)':
                  return combined.contains('expérimenté') ||
                      combined.contains('senior') ||
                      combined.contains('5') ||
                      combined.contains('6') ||
                      combined.contains('7') ||
                      combined.contains('8') ||
                      combined.contains('9') ||
                      combined.contains('10');
                case 'Senior (10+ ans)':
                  return combined.contains('senior') ||
                      combined.contains('expert') ||
                      combined.contains('10') ||
                      combined.contains('+');
                default:
                  return true;
              }
            }).toList();
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search job offers: $e');
    }
  }
}
