import 'package:equatable/equatable.dart';

class EntrepriseEntity extends Equatable {
  final String id;
  final String name;
  final String sector;
  final String description;
  final String location;
  final String? website;
  final String? linkedin;
  final String? logoUrl;
  final DateTime createdAt;

  const EntrepriseEntity({
    required this.id,
    required this.name,
    required this.sector,
    required this.description,
    required this.location,
    this.website,
    this.linkedin,
    this.logoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    sector,
    description,
    location,
    website,
    linkedin,
    logoUrl,
    createdAt,
  ];

  EntrepriseEntity copyWith({
    String? id,
    String? name,
    String? sector,
    String? description,
    String? location,
    String? website,
    String? linkedin,
    String? logoUrl,
    DateTime? createdAt,
  }) {
    return EntrepriseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      sector: sector ?? this.sector,
      description: description ?? this.description,
      location: location ?? this.location,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
