import '../entities/job_offer_entity.dart';
import '../repositories/job_offer_repository.dart';

class GetAllJobOffersUseCase {
  final JobOfferRepository _repository;

  GetAllJobOffersUseCase(this._repository);

  Future<List<JobOfferEntity>> call() async {
    return await _repository.getAllJobOffers();
  }
}

class GetJobOffersByEntrepriseUseCase {
  final JobOfferRepository _repository;

  GetJobOffersByEntrepriseUseCase(this._repository);

  Future<List<JobOfferEntity>> call(String entrepriseId) async {
    return await _repository.getJobOffersByEntreprise(entrepriseId);
  }
}

class GetJobOfferByIdUseCase {
  final JobOfferRepository _repository;

  GetJobOfferByIdUseCase(this._repository);

  Future<JobOfferEntity?> call(String id) async {
    return await _repository.getJobOfferById(id);
  }
}

class CreateJobOfferUseCase {
  final JobOfferRepository _repository;

  CreateJobOfferUseCase(this._repository);

  Future<JobOfferEntity> call(JobOfferEntity jobOffer) async {
    return await _repository.createJobOffer(jobOffer);
  }
}

class UpdateJobOfferUseCase {
  final JobOfferRepository _repository;

  UpdateJobOfferUseCase(this._repository);

  Future<JobOfferEntity> call(JobOfferEntity jobOffer) async {
    return await _repository.updateJobOffer(jobOffer);
  }
}

class DeleteJobOfferUseCase {
  final JobOfferRepository _repository;

  DeleteJobOfferUseCase(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteJobOffer(id);
  }
}

class SearchJobOffersUseCase {
  final JobOfferRepository _repository;

  SearchJobOffersUseCase(this._repository);

  Future<List<JobOfferEntity>> call({
    String? location,
    String? contractType,
    String? company,
    List<String>? skills,
    String? searchQuery,
    String? salaryRange,
    String? experienceLevel,
  }) async {
    return await _repository.searchJobOffers(
      location: location,
      contractType: contractType,
      company: company,
      skills: skills,
      searchQuery: searchQuery,
      salaryRange: salaryRange,
      experienceLevel: experienceLevel,
    );
  }
}
