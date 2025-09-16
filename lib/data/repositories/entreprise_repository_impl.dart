import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/entreprise_repository.dart';
import '../../domain/entities/entreprise_entity.dart';
import '../models/entreprise_model.dart';

class EntrepriseRepositoryImpl implements EntrepriseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<EntrepriseEntity>> getAllEntreprises() async {
    try {
      final querySnapshot = await _firestore.collection('entreprises').get();
      return querySnapshot.docs
          .map((doc) => EntrepriseModel.fromJson({...doc.data(), 'id': doc.id}))
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get all entreprises: $e');
    }
  }

  @override
  Future<EntrepriseEntity?> getEntrepriseById(String id) async {
    try {
      final doc = await _firestore.collection('entreprises').doc(id).get();
      if (doc.exists) {
        final entrepriseModel = EntrepriseModel.fromJson({
          ...doc.data()!,
          'id': doc.id,
        });
        return entrepriseModel.toEntity();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get entreprise by id: $e');
    }
  }

  @override
  Future<String> createEntreprise(EntrepriseEntity entreprise) async {
    try {
      final entrepriseModel = EntrepriseModel.fromEntity(entreprise);
      final docRef = await _firestore
          .collection('entreprises')
          .add(entrepriseModel.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create entreprise: $e');
    }
  }

  @override
  Future<void> updateEntreprise(EntrepriseEntity entreprise) async {
    try {
      final entrepriseModel = EntrepriseModel.fromEntity(entreprise);
      await _firestore
          .collection('entreprises')
          .doc(entreprise.id)
          .update(entrepriseModel.toJson());
    } catch (e) {
      throw Exception('Failed to update entreprise: $e');
    }
  }

  @override
  Future<void> deleteEntreprise(String id) async {
    try {
      await _firestore.collection('entreprises').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete entreprise: $e');
    }
  }

  @override
  Future<String> uploadLogo(String filePath) async {
    throw UnimplementedError('Logo upload not implemented');
  }
}
