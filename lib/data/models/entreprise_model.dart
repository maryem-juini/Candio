import '../../domain/entities/entreprise_entity.dart';

class EntrepriseModel extends EntrepriseEntity {
  const EntrepriseModel({
    required super.id,
    required super.name,
    required super.sector,
    required super.description,
    required super.location,
    super.website,
    super.linkedin,
    super.logoUrl,
    required super.createdAt,
  });

  factory EntrepriseModel.fromJson(Map<String, dynamic> json) {
    return EntrepriseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sector: json['sector'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      website: json['website'],
      linkedin: json['linkedin'],
      logoUrl: json['logoUrl'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sector': sector,
      'description': description,
      'location': location,
      'website': website,
      'linkedin': linkedin,
      'logoUrl': logoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EntrepriseModel.fromEntity(EntrepriseEntity entity) {
    return EntrepriseModel(
      id: entity.id,
      name: entity.name,
      sector: entity.sector,
      description: entity.description,
      location: entity.location,
      website: entity.website,
      linkedin: entity.linkedin,
      logoUrl: entity.logoUrl,
      createdAt: entity.createdAt,
    );
  }

  EntrepriseEntity toEntity() {
    return EntrepriseEntity(
      id: id,
      name: name,
      sector: sector,
      description: description,
      location: location,
      website: website,
      linkedin: linkedin,
      logoUrl: logoUrl,
      createdAt: createdAt,
    );
  }
}
