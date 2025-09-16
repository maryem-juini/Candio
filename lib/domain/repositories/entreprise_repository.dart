import '../entities/entreprise_entity.dart';

abstract class EntrepriseRepository {
  Future<List<EntrepriseEntity>> getAllEntreprises();
  Future<EntrepriseEntity?> getEntrepriseById(String id);
  Future<String> createEntreprise(EntrepriseEntity entreprise);
  Future<void> updateEntreprise(EntrepriseEntity entreprise);
  Future<void> deleteEntreprise(String id);
  Future<String> uploadLogo(String filePath);
}
