import '../entities/entreprise_entity.dart';
import '../repositories/entreprise_repository.dart';

class CreateEntrepriseUseCase {
  final EntrepriseRepository _repository;

  CreateEntrepriseUseCase(this._repository);

  Future<String> call(EntrepriseEntity entreprise) async {
    try {
      return await _repository.createEntreprise(entreprise);
    } catch (e) {
      throw Exception('Failed to create entreprise: $e');
    }
  }
}

class GetEntrepriseUseCase {
  final EntrepriseRepository _repository;

  GetEntrepriseUseCase(this._repository);

  Future<EntrepriseEntity?> call(String id) async {
    try {
      return await _repository.getEntrepriseById(id);
    } catch (e) {
      throw Exception('Failed to get entreprise: $e');
    }
  }
}

class UpdateEntrepriseUseCase {
  final EntrepriseRepository _repository;

  UpdateEntrepriseUseCase(this._repository);

  Future<void> call(EntrepriseEntity entreprise) async {
    try {
      await _repository.updateEntreprise(entreprise);
    } catch (e) {
      throw Exception('Failed to update entreprise: $e');
    }
  }
}

class DeleteEntrepriseUseCase {
  final EntrepriseRepository _repository;

  DeleteEntrepriseUseCase(this._repository);

  Future<void> call(String id) async {
    try {
      await _repository.deleteEntreprise(id);
    } catch (e) {
      throw Exception('Failed to delete entreprise: $e');
    }
  }
}

class GetAllEntreprisesUseCase {
  final EntrepriseRepository _repository;

  GetAllEntreprisesUseCase(this._repository);

  Future<List<EntrepriseEntity>> call() async {
    try {
      return await _repository.getAllEntreprises();
    } catch (e) {
      throw Exception('Failed to get all entreprises: $e');
    }
  }
}
