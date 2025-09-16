import '../../domain/entities/experience_entity.dart';

class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    required super.id,
    required super.jobTitle,
    required super.company,
    required super.description,
    required super.startDate,
    super.endDate,
    super.isCurrentJob = false,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrentJob: json['isCurrentJob'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'company': company,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentJob': isCurrentJob,
    };
  }

  factory ExperienceModel.fromEntity(ExperienceEntity entity) {
    return ExperienceModel(
      id: entity.id,
      jobTitle: entity.jobTitle,
      company: entity.company,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isCurrentJob: entity.isCurrentJob,
    );
  }

  ExperienceEntity toEntity() {
    return ExperienceEntity(
      id: id,
      jobTitle: jobTitle,
      company: company,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isCurrentJob: isCurrentJob,
    );
  }
}
