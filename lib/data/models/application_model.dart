import '../../domain/entities/application_entity.dart';

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.id,
    required super.jobOfferId,
    required super.candidateId,
    required super.candidateName,
    required super.candidateEmail,
    required super.candidatePhone,
    super.candidateCvUrl,
    super.candidateProfilePictureUrl,
    super.status,
    required super.appliedAt,
    super.updatedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? '',
      jobOfferId: json['jobOfferId'] ?? '',
      candidateId: json['candidateId'] ?? '',
      candidateName: json['candidateName'] ?? '',
      candidateEmail: json['candidateEmail'] ?? '',
      candidatePhone: json['candidatePhone'] ?? '',
      candidateCvUrl: json['candidateCvUrl'],
      candidateProfilePictureUrl: json['candidateProfilePictureUrl'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      appliedAt: DateTime.parse(json['appliedAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobOfferId': jobOfferId,
      'candidateId': candidateId,
      'candidateName': candidateName,
      'candidateEmail': candidateEmail,
      'candidatePhone': candidatePhone,
      'candidateCvUrl': candidateCvUrl,
      'candidateProfilePictureUrl': candidateProfilePictureUrl,
      'status': status.toString().split('.').last,
      'appliedAt': appliedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      jobOfferId: entity.jobOfferId,
      candidateId: entity.candidateId,
      candidateName: entity.candidateName,
      candidateEmail: entity.candidateEmail,
      candidatePhone: entity.candidatePhone,
      candidateCvUrl: entity.candidateCvUrl,
      candidateProfilePictureUrl: entity.candidateProfilePictureUrl,
      status: entity.status,
      appliedAt: entity.appliedAt,
      updatedAt: entity.updatedAt,
    );
  }

  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      jobOfferId: jobOfferId,
      candidateId: candidateId,
      candidateName: candidateName,
      candidateEmail: candidateEmail,
      candidatePhone: candidatePhone,
      candidateCvUrl: candidateCvUrl,
      candidateProfilePictureUrl: candidateProfilePictureUrl,
      status: status,
      appliedAt: appliedAt,
      updatedAt: updatedAt,
    );
  }
}
