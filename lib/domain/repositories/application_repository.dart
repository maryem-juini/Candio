import '../entities/application_entity.dart';

abstract class ApplicationRepository {
  Future<List<ApplicationEntity>> getApplicationsByJobOffer(String jobOfferId);
  Future<List<ApplicationEntity>> getApplicationsByCandidate(
    String candidateId,
  );
  Future<ApplicationEntity?> getApplicationById(String id);
  Future<ApplicationEntity> createApplication(ApplicationEntity application);
  Future<ApplicationEntity> updateApplicationStatus(
    String id,
    ApplicationStatus status,
  );
  Future<void> deleteApplication(String id);
  Future<bool> hasCandidateApplied(String candidateId, String jobOfferId);
}
