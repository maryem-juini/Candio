import '../entities/application_entity.dart';
import '../repositories/application_repository.dart';

class GetApplicationsByJobOfferUseCase {
  final ApplicationRepository _repository;

  GetApplicationsByJobOfferUseCase(this._repository);

  Future<List<ApplicationEntity>> call(String jobOfferId) async {
    return await _repository.getApplicationsByJobOffer(jobOfferId);
  }
}

class GetApplicationsByCandidateUseCase {
  final ApplicationRepository _repository;

  GetApplicationsByCandidateUseCase(this._repository);

  Future<List<ApplicationEntity>> call(String candidateId) async {
    return await _repository.getApplicationsByCandidate(candidateId);
  }
}

class GetApplicationByIdUseCase {
  final ApplicationRepository _repository;

  GetApplicationByIdUseCase(this._repository);

  Future<ApplicationEntity?> call(String id) async {
    return await _repository.getApplicationById(id);
  }
}

class CreateApplicationUseCase {
  final ApplicationRepository _repository;

  CreateApplicationUseCase(this._repository);

  Future<ApplicationEntity> call(ApplicationEntity application) async {
    return await _repository.createApplication(application);
  }
}

class UpdateApplicationStatusUseCase {
  final ApplicationRepository _repository;

  UpdateApplicationStatusUseCase(this._repository);

  Future<ApplicationEntity> call(String id, ApplicationStatus status) async {
    return await _repository.updateApplicationStatus(id, status);
  }
}

class DeleteApplicationUseCase {
  final ApplicationRepository _repository;

  DeleteApplicationUseCase(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteApplication(id);
  }
}

class HasCandidateAppliedUseCase {
  final ApplicationRepository _repository;

  HasCandidateAppliedUseCase(this._repository);

  Future<bool> call(String candidateId, String jobOfferId) async {
    return await _repository.hasCandidateApplied(candidateId, jobOfferId);
  }
}
