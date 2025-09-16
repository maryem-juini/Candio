import '../entities/job_offer_entity.dart';

abstract class JobOfferRepository {
  Future<List<JobOfferEntity>> getAllJobOffers();
  Future<List<JobOfferEntity>> getJobOffersByEntreprise(String entrepriseId);
  Future<JobOfferEntity?> getJobOfferById(String id);
  Future<JobOfferEntity> createJobOffer(JobOfferEntity jobOffer);
  Future<JobOfferEntity> updateJobOffer(JobOfferEntity jobOffer);
  Future<void> deleteJobOffer(String id);
  Future<List<JobOfferEntity>> searchJobOffers({
    String? location,
    String? contractType,
    String? company,
    List<String>? skills,
    String? searchQuery,
    String? salaryRange,
    String? experienceLevel,
  });
}
