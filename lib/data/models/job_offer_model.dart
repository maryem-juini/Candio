import '../../domain/entities/job_offer_entity.dart';

class JobOfferModel extends JobOfferEntity {
  const JobOfferModel({
    required super.id,
    required super.title,
    required super.company,
    required super.location,
    required super.contractType,
    required super.description,
    required super.requirements,
    super.salaryRange,
    required super.deadline,
    required super.entrepriseId,
    required super.createdAt,
    super.isActive,
  });

  factory JobOfferModel.fromJson(Map<String, dynamic> json) {
    return JobOfferModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      contractType: json['contractType'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      salaryRange: json['salaryRange'],
      deadline: DateTime.parse(json['deadline']),
      entrepriseId: json['entrepriseId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'contractType': contractType,
      'description': description,
      'requirements': requirements,
      'salaryRange': salaryRange,
      'deadline': deadline.toIso8601String(),
      'entrepriseId': entrepriseId,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory JobOfferModel.fromEntity(JobOfferEntity entity) {
    return JobOfferModel(
      id: entity.id,
      title: entity.title,
      company: entity.company,
      location: entity.location,
      contractType: entity.contractType,
      description: entity.description,
      requirements: entity.requirements,
      salaryRange: entity.salaryRange,
      deadline: entity.deadline,
      entrepriseId: entity.entrepriseId,
      createdAt: entity.createdAt,
      isActive: entity.isActive,
    );
  }

  JobOfferEntity toEntity() {
    return JobOfferEntity(
      id: id,
      title: title,
      company: company,
      location: location,
      contractType: contractType,
      description: description,
      requirements: requirements,
      salaryRange: salaryRange,
      deadline: deadline,
      entrepriseId: entrepriseId,
      createdAt: createdAt,
      isActive: isActive,
    );
  }
}
