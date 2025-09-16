import 'package:equatable/equatable.dart';

class JobOfferEntity extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String contractType;
  final String description;
  final List<String> requirements;
  final String? salaryRange;
  final DateTime deadline;
  final String entrepriseId;
  final DateTime createdAt;
  final bool isActive;

  const JobOfferEntity({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.contractType,
    required this.description,
    required this.requirements,
    this.salaryRange,
    required this.deadline,
    required this.entrepriseId,
    required this.createdAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    location,
    contractType,
    description,
    requirements,
    salaryRange,
    deadline,
    entrepriseId,
    createdAt,
    isActive,
  ];

  JobOfferEntity copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? contractType,
    String? description,
    List<String>? requirements,
    String? salaryRange,
    DateTime? deadline,
    String? entrepriseId,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return JobOfferEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      contractType: contractType ?? this.contractType,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      salaryRange: salaryRange ?? this.salaryRange,
      deadline: deadline ?? this.deadline,
      entrepriseId: entrepriseId ?? this.entrepriseId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
